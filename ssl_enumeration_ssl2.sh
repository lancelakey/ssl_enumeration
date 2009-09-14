#!/usr/bin/env bash

usage()
{
cat << EOF
Usage: $0

This script will list enabled and not enabled SSL ciphers.

Syntax:
$0 host:port

Example:
$0 domain.com:443

EOF
}

if [ -z "${1}" ]
then
	usage
	exit 1
fi

echo "Enabled:"
for cipher in `openssl ciphers 'ALL,eNULL,aNULL' | tr ':' ' '` ; do
	result=`echo -e 'GET / HTTP/1.1\r\nHost: localhost\r\n\r\n' | openssl s_client -ssl2 -connect ${1} -cipher $cipher 2>/dev/null | egrep -i '(bit|bits)'`
	if [ -n "$result" ]
		then
		echo $cipher $result
	fi
done

echo -e '\r'
echo "Not Enabled:"
for cipher in `openssl ciphers 'ALL,eNULL,aNULL' | tr ':' ' '` ; do
	result=`echo -e 'GET / HTTP/1.1\r\nHost: localhost\r\n\r\n' | openssl s_client -ssl2 -connect ${1} -cipher $cipher 2>/dev/null | egrep -i '(bit|bits)'`
	if [ -z "$result" ]
		then
		echo $cipher
	fi
done