#!/bin/bash

uninstall()
{
	if [ -f /usr/bin/deer ]; then
		for item in "${service_images[@]}" ; do
			docker rm -f "${item%%:*}"
			docker rmi -f "${item##*:}"
		done
		local chain_data_dir=$(cat $config_json | jq -r '.chain_data_dir')
		[ -d "$chain_data_dir" ] && rm -r $chain_data_dir
		local teaclave_data_dir=$(cat $config_json | jq -r '.teaclave_data_dir')
		[ -d "$teaclave_data_dir" ] && rm -r $teaclave_data_dir
		local ipfs_data_dir=$(cat $config_json | jq -r '.ipfs_data_dir')
		[ -d "$ipfs_data_dir" ] && rm -r $ipfs_data_dir
		rm /usr/bin/deer
	fi

	rm -rf $installdir

	log_success "---------------Uninstall deer node sucess---------------"
}

