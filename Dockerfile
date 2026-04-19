FROM ubuntu:24.04

LABEL org.opencontainers.image.authors="Montala Ltd"

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update && apt-get install -y \
    apache2 \
    subversion \
    imagemagick \
    ghostscript \
    antiword \
    poppler-utils \
    libimage-exiftool-perl \
    php \
    php-apcu \
    php-curl \
    php-dev \
    php-gd \
    php-intl \
    php-mysql \
    php-mbstring \
    php-zip \
    libapache2-mod-php \
    ffmpeg \
    python3 \
    python3-opencv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# PHP tuning
RUN sed -i "s/upload_max_filesize.*/upload_max_filesize = 100M/" /etc/php/8.3/apache2/php.ini && \
    sed -i "s/post_max_size.*/post_max_size = 100M/" /etc/php/8.3/apache2/php.ini && \
    sed -i "s/max_execution_time.*/max_execution_time = 300/" /etc/php/8.3/apache2/php.ini && \
    sed -i "s/memory_limit.*/memory_limit = 1G/" /etc/php/8.3/apache2/php.ini

WORKDIR /var/www/html

# Install ResourceSpace
RUN rm -f index.html && \
    svn co -q https://svn.resourcespace.com/svn/rs/releases/10.7 . && \
    mkdir -p filestore

# Fix ownership BEFORE dropping privileges
RUN chown -R www-data:www-data /var/www/html

# Apache config (optional hardening)
RUN echo "<Directory /var/www/html>\nAllowOverride All\n</Directory>" >> /etc/apache2/apache2.conf

# Switch to non-root
USER www-data

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
