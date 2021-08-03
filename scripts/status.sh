#!/bin/bash

status()
{
	local node_block=$(curl -sH "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "system_syncState", "params":[]}' http://localhost:9933 | jq '.result.currentBlock')
	node_status=$(check_docker_status chain)
	teaclave_status=$(check_docker_status teaclave)
	worker_status=$(check_docker_status worker)
	ipfs_status=$(check_docker_status ipfs)

	cat << EOF
chain is ${node_status}, current block is ${node_block}
teaclave is ${teaclave_status}
worker is ${worker_status}
ipfs is ${ipfs_status}
EOF
}
