from debian:jessie

RUN apt-get update -y && apt-get install -y dnsmasq
COPY entry.sh /root/entry.sh
RUN chmod +x /root/entry.sh
CMD ["bash", "/root/entry.sh"]
