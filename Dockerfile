# 1) Build the React/Vite portfolio into /dist
FROM node:20-alpine AS build
WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

COPY . .
RUN npm run build


# 2) Single-container runtime: Apache+PHP + MariaDB + phpMyAdmin
FROM php:8.2-apache

# Assignment requirement: host site files in a working dir called
# "lastName_firstName_final_site" (this project is "deboer_zack_final_site").
WORKDIR /deboer_zack_final_site
ENV DOCROOT=/deboer_zack_final_site

# Apache modules
RUN a2enmod rewrite headers

# System deps + MariaDB + PHP extensions commonly needed by phpMyAdmin
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    curl \
    unzip \
    ca-certificates \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
  && docker-php-ext-install pdo_mysql mysqli mbstring zip gd \
  && rm -rf /var/lib/apt/lists/*

# Install phpMyAdmin (served at /phpmyadmin/)
ARG PHPMYADMIN_VERSION=5.2.1
RUN mkdir -p ${DOCROOT}/phpmyadmin \
  && curl -fsSL "https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip" -o /tmp/pma.zip \
  && unzip -q /tmp/pma.zip -d /tmp \
  && mv "/tmp/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages/"* ${DOCROOT}/phpmyadmin/ \
  && rm -rf /tmp/pma.zip "/tmp/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages"

# phpMyAdmin minimal config (cookie auth; connects to local MariaDB)
# You can override PMA_BLOWFISH_SECRET at runtime for best practice.
COPY docker/phpmyadmin/config.inc.php ${DOCROOT}/phpmyadmin/config.inc.php

# Copy built portfolio to Apache docroot (/)
COPY --from=build /app/dist/ ${DOCROOT}/

# Copy 8-Track PHP app to /8-track
COPY src/projects/8-Track/ ${DOCROOT}/8-track/

# Ensure Apache (www-data) can write uploads
RUN mkdir -p ${DOCROOT}/8-track/uploads/playlist_images \
  && chown -R www-data:www-data ${DOCROOT}/8-track/uploads \
  && chmod -R u+rwX,g+rwX ${DOCROOT}/8-track/uploads

# Copy Ladybug static site so it can be linked from the portfolio
COPY src/projects/LadybugSite/ ${DOCROOT}/ladybug/

# Make Apache serve the assignment working dir as the docroot.
RUN rm -rf /var/www/html \
  && ln -s ${DOCROOT} /var/www/html

# Copy DB schema into image (imported on first container start)
COPY docker/schema.sql /docker-init/schema.sql

# PHP config overrides (upload limits)
COPY docker/php/uploads.ini /usr/local/etc/php/conf.d/uploads.ini

# Entrypoint (starts MariaDB, imports schema, seeds admin, then starts Apache)
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
  && sed -i 's/\r$//' /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]