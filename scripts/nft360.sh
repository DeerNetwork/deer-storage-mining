#!/bin/bash

installdir=/opt/nft360
scriptdir=$installdir/scripts

source $scriptdir/utils.sh
source $scriptdir/config.sh
source $scriptdir/install_nft360.sh
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
	install {init|isgx|dcap}			install your nft360 services
	uninstall               			uninstall your nft360 scripts
	start {all|chain|teaclave|worker|ipfs}		start your nft360 services
	stop {all|chain|teaclave|worker|ipfs}		use docker kill to stop module
	restart {chain|teaclave|worker|ipfs}		restart nft360 services
	config						configure your nft360 
	status						display the running status of all components
	update {scripts|images|image}			update nft360 services
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
