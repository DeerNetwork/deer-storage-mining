#!/bin/bash

config_help()
{
cat << EOF
Usage:
	help			show help information
	show			show configurations
	set			set configurations
EOF
}

config_show()
{
	cat $installdir/config.json | jq .
}

config_set_all()
{
	line=2
	local node_name=""
	read -p "Enter node name: " node_name
	while [[ x"$node_name" =~ \ |\' || -z "$node_name" ]]; do
		read -p "The node name can't contain spaces, please re-enter：" node_name
	done
	node_name=`echo "$node_name"`
	sed -i "${line}c \\  \"nodename\": \"$node_name\"," $installdir/config.json &>/dev/null
	log_success "Set node name: '$node_name' successfully"

	line=$((line+1))
	local mnemonic=""
	read -p "Enter your controllor mnemonic : " mnemonic
	mnemonic=`echo "$mnemonic"`
	if [ x"$mnemonic" == x"" ]; then
		log_err "Mnemonic cannot be empty"
		exit 1
	fi
	sed -i "${line}c \\  \"mnemonic\": \"$mnemonic\"," $installdir/config.json &>/dev/null
	log_success "Set your controllor mnemonic: '$mnemonic' successfully"

	line=$((line+1))
	local disk_size=""
	read -p "Enter your disk_size reserved for teaclave in 1-1048576 gatebytes: " disk_size
	disk_size=`echo "$disk_size"`
	if [[ "$disk_size" =~ ^[0-9]+$ ]] && [[ "$disk_size" -ge 1 ]] && [[ "$disk_size" -le 1048576 ]]; then
		sleep 0
	else
		log_err "The disk_size should be integer in [1, 1048576]"
		exit 1
	fi
	sed -i "${line}c \\  \"disk_size\": $disk_size," $installdir/config.json &>/dev/null
	log_success "Set disk_size: '$disk_size' successfully"

	line=$((line+1))
	local chain_data_dir=""
	read -p "Enter your chain_data_dir [/opt/nft360/data/chain]: " chain_data_dir
	chain_data_dir=`echo "${chain_data_dir:-"/opt/nft360/data/chain"}"`
	mkdir -p "$chain_data_dir" > /dev/null 2>&1
	if [[ ! -d "$chain_data_dir" ]]; then
		log_err "The chain_data_dir is invalid"
	fi
	sed -i "${line}c \\  \"chain_data_dir\": \"$chain_data_dir\"," $installdir/config.json &>/dev/null
	log_success "Set chain_data_dir: '$chain_data_dir' successfully"

	line=$((line+1))
	local ipfs_data_dir=""
	read -p "Enter your ipfs_data_dir [/opt/nft360/data/ipfs]: " ipfs_data_dir
	ipfs_data_dir=`echo "${ipfs_data_dir:-"/opt/nft360/data/ipfs"}"`
	mkdir -p "$ipfs_data_dir" > /dev/null 2>&1
	if [[ ! -d "$ipfs_data_dir" ]]; then
		log_err "The ipfs_data_dir is invalid"
	fi
	sed -i "${line}c \\  \"ipfs_data_dir\": \"$ipfs_data_dir\"," $installdir/config.json &>/dev/null
	log_success "Set ipfs_data_dir: '$ipfs_data_dir' successfully"

	line=$((line+1))
	local teaclave_data_dir=""
	read -p "Enter your teaclave_data_dir [/opt/nft360/data/teaclave]: " teaclave_data_dir
	teaclave_data_dir=`echo "${teaclave_data_dir:-"/opt/nft360/data/teaclave"}"`
	mkdir -p "$teaclave_data_dir" > /dev/null 2>&1
	if [[ ! -d "$teaclave_data_dir" ]]; then
		log_err "The teaclave_data_dir is invalid"
	fi
	sed -i "${line}c \\  \"teaclave_data_dir\": \"$teaclave_data_dir\"," $installdir/config.json &>/dev/null
	log_success "Set teaclave_data_dir: '$teaclave_data_dir' successfully"
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
		*)
			config_help
	esac
}
