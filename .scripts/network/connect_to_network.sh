#!/bin/bash

if [ -z "$1" ]
then
	echo "Must provide network name"
	exit 1
fi

if [ -z "$2" ]
then
	echo "Must provide network password"
	exit 1
fi

nmcli d wifi connect "$1" password "$2"
