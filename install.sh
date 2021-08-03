#!/bin/bash

basedir=$(cd `dirname $0`;pwd)
scriptdir=$basedir/scripts
installdir=/opt/nft360

install_scripts()
{
	echo "----------Install nft360----------"

	if [ -f /usr/bin/nft360 ]; then
		rm /usr/bin/nft360
		rm -rf $installdir/scripts
	fi
	echo "Install nft360 data"
	mkdir -p $installdir
	cp $installdir/config.json $installdir/config.json.bak 
	cp $basedir/config.json $installdir/
	cp -r $basedir/scripts $installdir/scripts

	echo "Install nft360 command line tool"
	chmod +x $installdir/scripts/nft360.sh
	ln -s $installdir/scripts/nft360.sh /usr/bin/nft360

	echo "----------Install success----------"
}

if [ $(id -u) -ne 0 ]; then
	echo "Please run with sudo!"
	exit 1
fi

install_scripts