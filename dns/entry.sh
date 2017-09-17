#!/bin/bash

echo "Starting DNS server with:"
echo "Legit IP: " $LEGIT_IP
echo "Legit name: " $LEGIT_DNSNAME
echo "Evil IP: " $EVIL_IP
echo "Evil name: " $EVIL_DNSNAME

exec dnsmasq -k -d
