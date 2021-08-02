#!/bin/bash

logs_help()
{
cat << EOF
Usage:
	logs {chain|teaclave|worker|ipfs}		show node module logs
EOF
}


logs()
{
	case "$1" in
		chain | teaclave | worker | ipfs)
			docker logs $1
			;;
		*)
			log_err "----------Parameter error----------"
			logs_help
			exit 1
	esac
}