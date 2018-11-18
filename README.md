# docker-postfix-mta

[![Docker Automated build](https://img.shields.io/docker/automated/jlyheden/postfix-mta.svg)](https://hub.docker.com/r/jlyheden/postfix-mta/builds/)

A docker image which bundles postfix and the dovecot lda forming a solution that can send and receive email.
MySQL used as the virtual account and email routing data store.

Mostly based on this linode guide: https://linode.com/docs/email/postfix/email-with-postfix-dovecot-and-mysql/