#!/bin/bash

set -e

# Because postfix seems to cache failed lookups we must implement this polling logic in the start script
poll_for_db() {
    local MAX=$1
    for TRY in $(seq 1 $MAX); do
        echo "Polling MySQL DB attempt ${TRY} of ${MAX}"
        sleep 1
        postmap -q example.com mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf 2>&1 | grep "query error" && continue
        postmap -q email1@example.com mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf 2>&1 | grep "query error" && continue
        postmap -q alias@example.com mysql:/etc/postfix/mysql-virtual-alias-maps.cf 2>&1 | grep "query error" && continue
        return
    done
    echo "Failed to connect to MySQL DB"
    exit 1
}

# Default vars
export POSTFIX_MYHOSTNAME=${POSTFIX_MYHOSTNAME:-"mx.example.com"}
export POSTFIX_MYDOMAIN=${POSTFIX_MYDOMAIN:-"example.com"}
export POSTFIX_MYSQL_USERNAME=${POSTFIX_MYSQL_USERNAME:-"dbuser"}
export POSTFIX_MYSQL_PASSWORD=${POSTFIX_MYSQL_PASSWORD:-"dbpassword"}
export POSTFIX_MYSQL_HOST=${POSTFIX_MYSQL_HOST:-"localhost"}
export POSTFIX_MYSQL_DBNAME=${POSTFIX_MYSQL_DBNAME:-"mailserver"}
export DOVECOT_POSTMASTER_ADDRESS=${DOVECOT_POSTMASTER_ADDRESS:-"postmaster@${POSTFIX_MYDOMAIN}"}
export DOVECOT_PWSCHEME=${DOVECOT_PWSCHEME:-"SHA512-CRYPT"}
export POSTFIX_MYSQL_MAX_RETRIES=${POSTFIX_MYSQL_MAX_RETRIES:-"120"}

# Mailbox permissions
MAIL_GID=${MAIL_GID:-"5000"}
MAIL_UID=${MAIL_UID:-"5000"}

addgroup \
    -g ${MAIL_GID} \
    vmail

usermod \
    -u ${MAIL_UID} \
    -g vmail \
    vmail

if ! [ -d /mail ]; then
    mkdir -v -p /mail
fi

chown -v -R vmail:vmail /mail

confd -onetime -backend env

set +e
trap "exit 1" INT
poll_for_db $POSTFIX_MYSQL_MAX_RETRIES
trap - INT
trap
set -e

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf