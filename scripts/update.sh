#!/bin/bash

update_help() 
{
cat << EOF
Usage:
	update {self|images}				update nft360 services 
	update image {chain|teaclave|worker|ipfs} 	update sinle service
EOF
}


update_scripts()
{
	log_info "----------Update nft360 script----------"

	mkdir -p /tmp/nft360
	wget https://github.com/nft360/nft360-storage-mining/archive/main.zip -O /tmp/nft360/main.zip
	unzip /tmp/nft360/main.zip -d /tmp/nft360
	rm -rf /opt/nft360/scripts
	cp -r /tmp/nft360/nft360-storage-mining-main/scripts /opt/nft360/scripts
	mv /opt/nft360/scripts/nft360.sh /usr/bin/nft360
	chmod +x /usr/bin/nft360
	chmod +x /opt/nft360/scripts/*

	log_success "----------Update success----------"
	rm -rf /tmp/nft360
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
