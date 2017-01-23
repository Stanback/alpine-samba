#
# Dockerfile for samba
#

FROM alpine:edge

RUN apk add --update \
    samba-common-tools \
    samba-client \
    samba-server \
    tini \
    && rm -rf /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh

VOLUME /var/log/samba

EXPOSE 137/udp \
       138/udp \
       139/tcp \
       445/tcp

ENTRYPOINT ["tini", "--", "/entrypoint.sh"]
CMD []
