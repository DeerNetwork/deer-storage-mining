#!/bin/bash


stop_help() 
{
cat << EOF
Usage:
	stop {all|chain|teaclave|worker|ipfs}		use docker kill to stop module
EOF
}

stop_docker()
{
	target=$1
	log_info "----------Stop $target----------"
	docker kill $target

	if [ $? -ne 0 ]; then
		log_err "----------Stop failed----------"
		exit 1
	fi
}

stop()
{
	case "$1" in
		chain | teaclave | worker | ipfs)
			stop_docker $1
			;;
		all)
			stop_docker chain
			stop_docker ipfs
			stop_docker teaclave
			stop_docker worker
			;;
		*)
			log_err "----------Parameter error----------"
			stop_help
			exit 1
	esac
}
