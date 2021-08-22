ARG TAG=latest
FROM spartan65/openwrt:$TAG

ARG IPADDR=192.168.0.101
ARG GATEWAY=192.168.0.1
ARG DNSADDR=192.168.0.1

RUN sed -i "s/#IPADDR/${IPADDR}/g" /etc/config/network \
    && sed -i "s/#GATEWAY/${GATEWAY}/g" /etc/config/network \
    && sed -i "s/#DNS/${DNSADDR}/g" /etc/config/network
