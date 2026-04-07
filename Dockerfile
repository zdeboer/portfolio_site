# 1) Build the React/Vite portfolio into /dist
FROM node:20-alpine AS build
WORKDIR /app

COPY package.json package-lock.json* ./
RUN npm ci

COPY . .
RUN npm run build


# 2) Single-container runtime: Apache+PHP + MariaDB + phpMyAdmin
FROM php:8.2-apache

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
RUN mkdir -p /var/www/html/phpmyadmin \
  && curl -fsSL "https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip" -o /tmp/pma.zip \
  && unzip -q /tmp/pma.zip -d /tmp \
  && mv "/tmp/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages/"* /var/www/html/phpmyadmin/ \
  && rm -rf /tmp/pma.zip "/tmp/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages"

# phpMyAdmin minimal config (cookie auth; connects to local MariaDB)
# You can override PMA_BLOWFISH_SECRET at runtime for best practice.
COPY docker/phpmyadmin/config.inc.php /var/www/html/phpmyadmin/config.inc.php

# Copy built portfolio to Apache docroot (/)
COPY --from=build /app/dist/ /var/www/html/

# Copy 8-Track PHP app to /8-track
COPY src/projects/8-Track/ /var/www/html/8-track/

# Copy Ladybug static site so it can be linked from the portfolio
COPY src/projects/LadybugSite/ /var/www/html/ladybug/

# Copy DB schema into image (imported on first container start)
COPY docker/schema.sql /docker-init/schema.sql

# Entrypoint (starts MariaDB, imports schema, seeds admin, then starts Apache)
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
  && sed -i 's/\r$//' /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]