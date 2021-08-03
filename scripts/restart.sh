#!/bin/bash


restart_help() 
{
cat << EOF
Usage:
	restart {chain|teaclave|worker|ipfs}		restart services
EOF
}

restart()
{
	case "$1" in
		chain | teaclave | worker | ipfs)
			exec_docker_restart $1
			;;
		*)
			restart_help
			exit 1
	esac
}
