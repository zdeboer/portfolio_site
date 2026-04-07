#!/usr/bin/env bash
set -euo pipefail

# ---- Config (env) ----
MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-}"   # if empty: root can login without password locally
DB_NAME="${DB_NAME:-music}"

# Web root inside the container (assignment uses /deboer_zack_final_site)
DOCROOT="${DOCROOT:-/var/www/html}"

# Optional app DB user (not required for the seed, but useful)
DB_USER="${DB_USER:-app}"
DB_PASS="${DB_PASS:-app}"

# Optional: admin seeding (your seed_admin.php uses these)
ADMIN_USERNAME="${ADMIN_USERNAME:-admin}"
ADMIN_EMAIL="${ADMIN_EMAIL:-admin@example.com}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-admin}"

# ---- MariaDB runtime dirs ----
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# ---- Web app writable dirs (uploads) ----
# Apache in this image runs as www-data. Ensure uploads dirs are writable on every start.
if [ -d "${DOCROOT}/8-track" ]; then
  mkdir -p "${DOCROOT}/8-track/uploads/playlist_images"
  chown -R www-data:www-data "${DOCROOT}/8-track/uploads"
  chmod -R u+rwX,g+rwX "${DOCROOT}/8-track/uploads"
fi

# Initialize MariaDB data dir on first run
if [ ! -d /var/lib/mysql/mysql ]; then
  mkdir -p /var/lib/mysql
  chown -R mysql:mysql /var/lib/mysql
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null
fi

# Start MariaDB in background (local only)
mariadbd --user=mysql --datadir=/var/lib/mysql \
  --bind-address=127.0.0.1 --port=3306 \
  --socket=/run/mysqld/mysqld.sock --pid-file=/run/mysqld/mysqld.pid &

# Wait for DB
for i in {1..60}; do
  if mariadb-admin --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

# One-time bootstrap (schema + users)
if [ ! -f /var/lib/mysql/.bootstrapped ]; then
  # Decide how to connect as root (handles existing volumes with/without root password)
  root_nopass=(mariadb --socket=/run/mysqld/mysqld.sock -uroot)

  if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
    root_withpass=(mariadb --socket=/run/mysqld/mysqld.sock -uroot -p"$MYSQL_ROOT_PASSWORD")

    if "${root_withpass[@]}" -e "SELECT 1" >/dev/null 2>&1; then
      root_mysql=("${root_withpass[@]}")
    elif "${root_nopass[@]}" -e "SELECT 1" >/dev/null 2>&1; then
      # Root currently has no password; set it now.
      "${root_nopass[@]}" <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
SQL
      root_mysql=("${root_withpass[@]}")
    else
      echo "ERROR: Cannot connect to MariaDB as root. If you're using a persisted volume, make sure MYSQL_ROOT_PASSWORD matches the existing root password (or delete the volume)." >&2
      exit 1
    fi
  else
    # No password provided; assume root is passwordless (local only).
    root_mysql=("${root_nopass[@]}")
  fi

  # Create DB + app user (safe to re-run)
  "${root_mysql[@]}" <<SQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
SQL

  # Import schema.sql if present
  if [ -f /docker-init/schema.sql ]; then
    "${root_mysql[@]}" < /docker-init/schema.sql
  fi

  # Seed admin (if script exists in the 8-track folder)
  if [ -f "${DOCROOT}/8-track/seed_admin.php" ]; then
    ADMIN_USERNAME="$ADMIN_USERNAME" \
    ADMIN_EMAIL="$ADMIN_EMAIL" \
    ADMIN_PASSWORD="$ADMIN_PASSWORD" \
    DB_NAME="$DB_NAME" \
    php "${DOCROOT}/8-track/seed_admin.php" || true
  fi

  touch /var/lib/mysql/.bootstrapped
fi

# Start Apache (foreground)
exec apache2-foreground