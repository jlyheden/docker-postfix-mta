#!/bin/bash

set -e

# Default vars
export POSTFIX_MYHOSTNAME=${POSTFIX_MYHOSTNAME:-"mx.example.com"}
export POSTFIX_MYDOMAIN=${POSTFIX_MYDOMAIN:-"example.com"}
export POSTFIX_MYSQL_USERNAME=${POSTFIX_MYSQL_USERNAME:-"dbuser"}
export POSTFIX_MYSQL_PASSWORD=${POSTFIX_MYSQL_PASSWORD:-"dbpassword"}
export POSTFIX_MYSQL_HOST=${POSTFIX_MYSQL_HOST:-"localhost"}
export POSTFIX_MYSQL_DBNAME=${POSTFIX_MYSQL_DBNAME:-"mailserver"}
export DOVECOT_POSTMASTER_ADDRESS=${DOVECOT_POSTMASTER_ADDRESS:-"postmaster@${POSTFIX_MYDOMAIN}"}
export DOVECOT_PWSCHEME=${DOVECOT_PWSCHEME:-"SHA512-CRYPT"}

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

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf