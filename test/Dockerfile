FROM python:3-alpine

RUN apk --no-cache add mariadb-dev build-base \
    && pip install behave mysqlclient

COPY features /features

ENTRYPOINT ["behave", "/features"]