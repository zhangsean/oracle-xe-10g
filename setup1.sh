#!/bin/bash

# avoid dpkg frontend dialog / frontend warnings
export DEBIAN_FRONTEND=noninteractive

echo ----- Install Dependinces -----
dpkg --add-architecture i386
apt-get update
apt-get install -y bc:i386 libaio1:i386 libc6-i386 net-tools wget
apt-get clean all

exit $?
