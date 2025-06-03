FROM debian:11-slim

RUN apt update -y \
    && apt install -y --no-install-recommends wget curl vim supervisor init \
    && apt clean all && rm -rf /var/lib/apt/lists/* /usr/share/man/* /usr/share/doc/* /tmp/* /var/tmp/*
WORKDIR /root
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
