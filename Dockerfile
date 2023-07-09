# Base Image used to create this Image
FROM bitnami/minideb:bullseye

# Maintainer
LABEL maintainer="hi@bluemedia.dev"

ENV DEBIAN_FRONTEND noninteractive
ENV RTMP_PORT 1935
ENV HTTP_PORT 8080
ENV HLS_FRAGMENT_LENGTH 3
ENV HLS_PLAYLIST_LENGTH 20

# Update and install packages
RUN install_packages nginx libnginx-mod-rtmp

# Create nginx user
RUN useradd -s /bin/false nginx

# Copy files into image
COPY config/ /template/
COPY frontend/ /var/www/html/
COPY entrypoint /entrypoint
RUN chmod +x /entrypoint && chown -R www-data:www-data /var/www/html/

ENTRYPOINT ["/entrypoint"]
CMD ["/usr/sbin/nginx"]
