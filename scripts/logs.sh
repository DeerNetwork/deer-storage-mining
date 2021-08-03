#!/bin/bash

logs_help()
{
cat << EOF
Usage:
	logs {chain|teaclave|worker|ipfs}		show nft360 service logs
EOF
}


logs()
{
	case "$1" in
		chain | teaclave | worker | ipfs)
			exec_docker_log $1
			;;
		*)
			logs_help
			exit 1
	esac
}