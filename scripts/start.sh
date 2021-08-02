#!/bin/bash

start_help() 
{
cat << EOF
Usage:
	start {all|chain|teaclave|worker|ipfs}		start your node modules
EOF
}

start_chain()
{
	log_info "---------Start chain----------"
	local node_name=$(cat $installdir/config.json | jq -r '.nodename')
	if [ -z $node_name ]; then
		config_set_all
		local node_name=$(cat $installdir/config.json | jq -r '.nodename')
	fi

	log_info "your node name:$node_name"

	if [ ! -z $(docker ps -qf "name=chain") ]; then
		log_info "---------chain already exists----------"
		exit 0
	fi

	local chain_data_dir=$(cat $installdir/config.json | jq -r '.chain_data_dir')
	local chain_args=$(cat $installdir/config.json | jq -r '.chain_args')
	docker run -d --net host --rm --name chain -e NODE_NAME=$node_name -v $chain_data_dir:/root/data nft360/nft360 \
		$chain_args --name $node_name --base-path /root/data --validator --pruning archive \
		--port 30666 --rpc-port 9933 --ws-port 9944 --wasm-execution compiled --in-peers 75 --out-peers 75 
	if [ $? -ne 0 ]; then
		log_err "----------Start chain failed-------------"
		exit 1
	fi
}

start_teaclave()
{
	log_info "----------Start teaclave----------"
	if [ ! -z $(docker ps -qf "name=teaclave") ]; then
		log_info "---------teaclave already exists----------"
		exit 0
	fi
	
	local res_sgx=$(ls /dev | grep -w sgx)
	local res_isgx=$(ls /dev | grep -w isgx)
	local teaclave_data_dir=$(cat $installdir/config.json | jq -r '.teaclave_data_dir')
	local disk_size=$(cat $installdir/config.json | jq -r '.disk_size')

	if [ x"$res_sgx" == x"sgx" ] && [ x"$res_isgx" == x"" ]; then
		docker run -d --net host --rm --name teaclave -v $teaclave_data_dir:/root/data --device /dev/sgx/enclave -e EXTRA_OPTS="--disk-size $disk_size" --device /dev/sgx/provision nft360/nft360-storage-teaclave
	elif [ x"$res_isgx" == x"isgx" ] && [ x"$res_sgx" == x"" ]; then
		docker run -d --net host --rm --name teaclave -v $teaclave_data_dir:/root/data --device /dev/isgx -e EXTRA_OPTS="--disk-size $disk_size" nft360/nft360-storage-teaclave 
	else
		log_err "----------sgx/dcap driver not install----------"
		exit 1
	fi

	if [ $? -ne 0 ]; then
		log_err "----------Start teaclave failed----------"
		exit 1
	fi
}

start_worker()
{
	log_info "----------Start worker----------"
	if [ ! -z $(docker ps -qf "name=worker") ]; then
		log_info "---------worker already exists----------"
		exit 0
	fi

	local mnemonic=$(cat $installdir/config.json | jq -r '.mnemonic')

	docker run -d --net host --rm --name worker -e WORKER__MNEMONIC="$mnemonic" nft360/nft360-storage-worker
	if [ $? -ne 0 ]; then
		log_err "----------Start worker failed----------"
		exit 1
	fi
}

start_ipfs()
{
	log_info "----------Start ifps----------"
	if [ ! -z $(docker ps -qf "name=ifps") ]; then
		log_info "---------ipfs already exists----------"
		exit 0
	fi

	local ipfs_data_dir=$(cat $installdir/config.json | jq -r '.ipfs_data_dir')
	local ipfs_boot_node=$(cat $installdir/config.json | jq -r '.ipfs_boot_node')
	docker run -d --net host --rm --name ipfs --entrypoint "/sbin/tini" -v $ipfs_data_dir:/data/ipfs ipfs/go-ipfs -- /bin/sh -c "/usr/local/bin/start_ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/37773 && /usr/local/bin/start_ipfs config Datastore.StorageMax 250GB && /usr/local/bin/start_ipfs bootstrap add $ipfs_boot_node && /usr/local/bin/start_ipfs daemon --enable-gc --migrate=true"

	if [ $? -ne 0 ]; then
		log_err "----------Start ipfs failed----------"
		exit 1
	fi
}

start()
{
	local mnemonic=$(cat $installdir/config.json | jq -r '.mnemonic')
	if [ -z "$mnemonic" ]; then
		config_set_all
	fi

	case "$1" in
		chain)
			start_chain
			;;
		teaclave)
			start_teaclave
			;;
		worker)
			start_worker
			;;
		ipfs)
			start_ipfs
			;;
		all)
			start_ipfs
			start_chain
			start_teaclave
			sleep 30
			start_worker
			;;
		*)
			log_err "----------Parameter error----------"
			start_help
			exit 1
	esac
}
