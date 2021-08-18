#!/bin/bash

update_help() 
{
cat << EOF
Usage:
	update scripts                      		update deer scripts
	update images                      		update all service images
	update image {chain|teaclave|worker|ipfs} 	update single service
EOF
}


update_scripts()
{
	log_info "----------Update deer script----------"

	mkdir -p /tmp/deer
	wget https://github.com/deer/deer-storage-mining/archive/main.zip -O /tmp/deer/main.zip
	unzip /tmp/deer/main.zip -d /tmp/deer
	rm -rf /opt/deer/scripts
	cp -r /tmp/deer/deer-storage-mining-main/scripts /opt/deer/scripts
	mv /opt/deer/scripts/deer.sh /usr/bin/deer
	chmod +x /usr/bin/deer
	chmod +x /opt/deer/scripts/*

	log_success "----------Update success----------"
	rm -rf /tmp/deer
}


update()
{
	case "$1" in
		scripts)
			update_scripts
			;;
		images)
			batch_exec exec_docker_pull
			;;
		image)
			shift 1
			if [ -z "$1" ]; then
				update_help
				exit 1
			fi
			exec_docker_pull $1
			;;
		*)
			update_help
			exit 1
	esac
}
