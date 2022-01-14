#!/bin/bash

sgx_test() {
    image=$(get_docker_image sgx-test)
	devices=""
	if [ -c /dev/isgx ]; then
		devices=$devices" --device /dev/isgx"
	fi
	if [ -c /dev/sgx/enclave ]; then
		devices=$devices" --device /dev/sgx/enclave"
	fi
	if [ -c /dev/sgx/provision ]; then
		devices=$devices" --device /dev/sgx/provision"
	fi
	if [ -c /dev/sgx/sgx_enclave ]; then
		devices=$devices" --device /dev/sgx/sgx_enclave"
	fi
	if [ -c /dev/sgx/sgx_provision ]; then
		devices=$devices" --device /dev/sgx/sgx_provision"
	fi
	if [ -n "$devices" ]; then
		docker run -ti --rm --name sgx-test  $devices $image
	else
		log_info "----------Maybe no sgx driver!----------"
		exit 1
	fi
}