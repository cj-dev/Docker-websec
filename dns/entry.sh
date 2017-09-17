#!/bin/bash

set -e
set -u

echo "Starting DNS server with:"
echo "Legit IP: " $LEGIT_IP
echo "Legit name: " $LEGIT_DNSNAME
echo "Evil IP: " $EVIL_IP
echo "Evil name: " $EVIL_DNSNAME

echo -e "$LEGIT_IP\t$LEGIT_DNSNAME" >> /etc/hosts
echo -e "$EVIL_IP\t$EVIL_DNSNAME" >> /etc/hosts
exec dnsmasq -k -d
# exec /bin/bash
