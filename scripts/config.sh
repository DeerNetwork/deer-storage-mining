#!/bin/bash


config_help()
{
cat << EOF
Usage:
	help			show help information
	show			show configurations
	set			set configurations
	network      		choose mainnet or testnet
EOF
}

config_show()
{
	cat $config_json | jq .
}


config_set_all()
{

	local node_name=""
	read -p "Enter node name: " node_name
	while [[ x"$node_name" =~ \ |\' || -z "$node_name" ]]; do
		read -p "The node name can't contain spaces, please re-enter：" node_name
	done
	node_name=`echo "$node_name"`
	jq '.nodename = "'"$node_name"'"' $config_json | sponge $config_json
	log_success "Set node name: '$node_name' successfully"

	local mnemonic=""
	read -p "Enter your controllor mnemonic : " mnemonic
	mnemonic=`echo "$mnemonic"`
	if [ x"$mnemonic" == x"" ]; then
		log_err "Mnemonic cannot be empty"
		exit 1
	fi
	jq '.mnemonic = "'"$mnemonic"'"' $config_json | sponge $config_json
	log_success "Set your controllor mnemonic: '$mnemonic' successfully"

	local disk_size=""
	read -p "Enter your disk_size reserved for teaclave in 1-1048576 gatebytes: " disk_size
	disk_size=`echo "$disk_size"`
	if [[ "$disk_size" =~ ^[0-9]+$ ]] && [[ "$disk_size" -ge 1 ]] && [[ "$disk_size" -le 1048576 ]]; then
		sleep 0
	else
		log_err "The disk_size should be integer in [1, 1048576]"
		exit 1
	fi
	jq '.disk_size = "'"$disk_size"'"' $config_json | sponge $config_json
	log_success "Set disk_size: '$disk_size' successfully"

	local chain_data_dir=""
	read -p "Enter your chain_data_dir [/opt/deer/data/chain]: " chain_data_dir
	chain_data_dir=`echo "${chain_data_dir:-"/opt/deer/data/chain"}"`
	mkdir -p "$chain_data_dir" > /dev/null 2>&1
	if [[ ! -d "$chain_data_dir" ]]; then
		log_err "The chain_data_dir is invalid"
	fi
	jq '.chain_data_dir = "'"$chain_data_dir"'"' $config_json | sponge $config_json
	log_success "Set chain_data_dir: '$chain_data_dir' successfully"

	local ipfs_data_dir=""
	read -p "Enter your ipfs_data_dir [/opt/deer/data/ipfs]: " ipfs_data_dir
	ipfs_data_dir=`echo "${ipfs_data_dir:-"/opt/deer/data/ipfs"}"`
	mkdir -p "$ipfs_data_dir" > /dev/null 2>&1
	if [[ ! -d "$ipfs_data_dir" ]]; then
		log_err "The ipfs_data_dir is invalid"
	fi
	jq '.ipfs_data_dir = "'"$ipfs_data_dir"'"' $config_json | sponge $config_json
	log_success "Set ipfs_data_dir: '$ipfs_data_dir' successfully"

	local teaclave_data_dir=""
	read -p "Enter your teaclave_data_dir [/opt/deer/data/teaclave]: " teaclave_data_dir
	teaclave_data_dir=`echo "${teaclave_data_dir:-"/opt/deer/data/teaclave"}"`
	mkdir -p "$teaclave_data_dir" > /dev/null 2>&1
	if [[ ! -d "$teaclave_data_dir" ]]; then
		log_err "The teaclave_data_dir is invalid"
	fi
	jq '.teaclave_data_dir = "'"$teaclave_data_dir"'"' $config_json | sponge $config_json
	log_success "Set teaclave_data_dir: '$teaclave_data_dir' successfully"
}

config_set_network()
{
	local network=""
	read -p "Choose network: [mainnet|testnet] " network
	network=`echo "$network"`
	if [ x"$network" == x"mainnet" ] || [ x"$network" == x"testnet" ]; then
		jq '.network = "'$network'"' $config_json | sponge $config_json
	else
		log_err "Network must be mainnet or testnet"
		exit 1
	fi
	log_success "Set network: '$network' successfully"
}

config()
{
	case "$1" in
		show)
			config_show
			;;
		set)
			config_set_all
			;;
		network)
			config_set_network
			;;
		*)
			config_help
	esac
}
