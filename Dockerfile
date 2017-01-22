#
# Dockerfile for samba
#

FROM alpine:edge

RUN apk add --update \
    samba-common-tools \
    samba-client \
    samba-server \
    && rm -rf /var/cache/apk/*

EXPOSE 137/udp \
       138/udp \
       139/tcp \
       445/tcp

ENTRYPOINT ["smbd", "--foreground", "--log-stdout"]
CMD []
