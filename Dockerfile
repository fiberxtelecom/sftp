FROM alpine:latest

# This image is based of https://github.com/atmoz/sftp
# Thanks to Adrian Dvergsdal [atmoz.net]

# Steps done in one RUN layer:
# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN  set -ex && echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && apk add --no-cache bash shadow@community openssh-server-pam openssh-sftp-server && \
    ln -s /usr/sbin/sshd.pam /usr/sbin/sshd && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

COPY sshd_config /etc/ssh/sshd_config
COPY create-sftp-user /usr/local/bin/
COPY entrypoint /

RUN chmod +x /entrypoint
RUN chmod +x /usr/local/bin/create-sftp-user

EXPOSE 22

ENTRYPOINT ["/entrypoint"]