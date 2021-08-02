#!/bin/bash

update_help() 
{
cat << EOF
Usage:
	update {self|images}				update nft360 node
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


update_images()
{
	log_info "----------Update images----------"

	stop_and_clean_containers

	download_docker_images

	log_success "----------Update success----------"
}

update()
{
	case "$1" in
		scripts)
			update_scripts
			;;
		images)
			update_images
			;;
		*)
			log_err "----------Parameter error----------"
			update_help
			exit 1
	esac
}
