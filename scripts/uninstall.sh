#!/bin/bash

stop_and_clean_containers() {
	docker stop worker && docker rmi -f nft360/nft360-storage-worker
	docker stop teaclave && docker rmi -f nft360/nft360-storage-teaclave
	docker stop chain && docker rmi -f nft360/nft360
	docker stop ipfs && docker rmi -f ipfs/go-ipfs
}

uninstall()
{
	if [ -f /usr/bin/nft360 ]; then
		stop_and_clean_containers
		local chain_data_dir=$(cat $installdir/config.json | jq -r '.chain_data_dir')
		[ -d "$chain_data_dir" ] && rm -r $chain_data_dir
		local teaclave_data_dir=$(cat $installdir/config.json | jq -r '.teaclave_data_dir')
		[ -d "$teaclave_data_dir" ] && rm -r $teaclave_data_dir
		rm /usr/bin/nft360
	fi

	rm -rf $installdir

	log_success "---------------Uninstall nft360 node sucess---------------"
}
