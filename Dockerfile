# The Base Image used to create this Image
FROM debian:buster-slim

# Just my name who wrote this file
LABEL maintainer="oliver@traber-info.de"

ENV DEBIAN_FRONTEND noninteractive
ENV RTMP_PORT 1935
ENV HTTP_PORT 8080

# Update and install logrotate
RUN apt update -y && \
    apt upgrade -y && \
    apt autoremove -y && \
    apt install nginx libnginx-mod-rtmp -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create users
RUN useradd -s /bin/false stunnel && useradd -s /bin/false nginx

# Copy files into image
COPY config/ /template/
COPY frontend/ /var/www/html/
COPY entrypoint /entrypoint
RUN chmod +x /entrypoint && chown -R www-data:www-data /var/www/html/

ENTRYPOINT ["/entrypoint"]
CMD ["/usr/sbin/nginx"]
