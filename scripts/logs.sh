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
		chain)
			docker logs chain
			;;
		teaclave)
			docker logs teaclave
			;;
		worker)
			docker logs worker
			;;
		ipfs)
			docker logs ipfs
			;;
		*)
			log_err "----------Parameter error----------"
			logs_help
			exit 1
	esac
}