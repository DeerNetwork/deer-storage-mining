#!/bin/bash

status()
{
	local node_status="stop"
	local node_block=$(curl -sH "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "system_syncState", "params":[]}' http://localhost:9933 | jq '.result.currentBlock')
	local teaclave_status="stop"
	local worker_status="stop"
	local ipfs_status="stop"

	check_docker_status chain
	local res=$?
	if [ $res -eq 0 ]; then
		node_status="running"
	elif [ $res -eq 2 ]; then
		node_status="exited"
	fi

	check_docker_status teaclave
	local res=$?
	if [ $res -eq 0 ]; then
		teaclave_status="running"
	elif [ $res -eq 2 ]; then
		teaclave_status="exited"
	fi

	check_docker_status worker
	local res=$?
	if [ $res -eq 0 ]; then
		worker_status="running"
	elif [ $res -eq 2 ]; then
		worker_status="exited"
	fi

	check_docker_status ipfs
	local res=$?
	if [ $res -eq 0 ]; then
		ipfs_status="running"
	elif [ $res -eq 2 ]; then
		ipfs_status="exited"
	fi

	cat << EOF
------------------------------------------------------------------------
	Service		Status			CurrentBlock
------------------------------------------------------------------------
	chain		${node_status}		${node_block}
	teaclave	${teaclave_status}
	worker		${worker_status}
	go-ipfs 	${ipfs_status}
------------------------------------------------------------------------
EOF
}
