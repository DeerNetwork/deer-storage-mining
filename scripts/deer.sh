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
Usage:
	help						show help information
	install {init|isgx|dcap}			install your deer services
	uninstall               			uninstall your deer scripts
	start {all|chain|teaclave|worker|ipfs}		start your deer services
	stop {all|chain|teaclave|worker|ipfs}		use docker kill to stop module
	restart {chain|teaclave|worker|ipfs}		restart deer services
	config						configure your deer 
	status						display the running status of all components
	update {scripts|images|image}			update deer services
	logs {chain|teaclave|worker|ipfs}		show services logs
EOF
exit 0
}


case "$1" in
	install)
		install $2
		;;
	config)
		config $2
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
