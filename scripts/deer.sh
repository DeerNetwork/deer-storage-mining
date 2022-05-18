#!/bin/bash

installdir=/opt/deer
scriptdir=$installdir/scripts
config_json=$installdir/config.json

source $scriptdir/utils.sh
source $scriptdir/config.sh
source $scriptdir/install_deer.sh
source $scriptdir/logs.sh
source $scriptdir/start.sh
source $scriptdir/restart.sh
source $scriptdir/status.sh
source $scriptdir/stop.sh
source $scriptdir/uninstall.sh
source $scriptdir/update.sh

help()
{
cat << EOF
deer v1.2.1
Usage:
	help						show help information
	install {init|isgx|dcap}			install your deer services
	uninstall               			uninstall your deer scripts
	start {all|chain|teaclave|worker|ipfs}		start your deer services
	stop {all|chain|teaclave|worker|ipfs}		use docker kill to stop module
	restart {chain|teaclave|worker|ipfs}		restart deer services
	rotate-key 					rotate session keys
	config						configure your deer 
	network	{mainnet|testnet}			choose network
	status						display the running status of all components
	update {scripts|images|image}			update deer services
	logs {chain|teaclave|worker|ipfs}		show services logs
EOF
exit 0
}

set_network() {
	if ! { [ -x "$(command -v jq)" ] && [ -x "$(command -v sponge)" ]; }; then
		log_info "----------Install depencies----------"
		apt-get update && apt-get install -y jq moreutils
	fi
	network=$1
	if [ x"$network" == x"mainnet" ] || [ x"$network" == x"testnet" ]; then
		jq '.network = "'$network'"' $config_json | sponge $config_json
	else
		log_err "Network must be mainnet or testnet"
		exit 1
	fi
	log_success "Set network: '$network' successfully"
}

rotate_key() {
	curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "author_rotateKeys", "params":[]}' http://localhost:9933
}

case "$1" in
	install)
		install $2
		;;
	config)
		config $2
		;;
	network)
		set_network $2
		;;
	start)
		shift 1
		start $@
		;;
	restart)
		shift 1
		restart $@
		;;
	stop)
		stop $2
		;;
	status)
		status $@
		;;
	rotate-key)
		rotate_key
		;;
	update)
		shift 1
		update $@
		;;
	logs)
		logs $2
		;;
	uninstall)
		uninstall
		;;
	*)
		help
		;;
esac

exit 0
