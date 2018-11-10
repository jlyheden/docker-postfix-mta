#FROM arm64v8/alpine:3.8
FROM alpine:3.8

RUN apk --no-cache add \
  postfix-mysql \
  postfix \
  postfix-pcre \
  dovecot-mysql \
  dovecot \
  supervisor \
  rsyslog \
  bash \
  shadow \
  curl

RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 -o /usr/local/bin/confd \
  && chmod +x /usr/local/bin/confd \
  && chown root:root /usr/local/bin/confd

EXPOSE 25
EXPOSE 465
EXPOSE 587

COPY ./files/postfix /etc/postfix
COPY ./files/dovecot /etc/dovecot
COPY ./files/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./files/entrypoint.sh /
COPY ./conf.d /etc/confd/conf.d
COPY ./templates /etc/confd/templates

ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]
