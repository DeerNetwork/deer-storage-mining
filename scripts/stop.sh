#!/bin/bash


stop_help() 
{
cat << EOF
Usage:
	stop {all|chain|teaclave|worker|ipfs}		stop services
EOF
}

stop()
{
	case "$1" in
		chain | teaclave | worker | ipfs)
			exec_docker_stop $1
			;;
		all)
			batch_exec exec_docker_stop
			;;
		*)
			stop_help
			exit 1
	esac
}
