FROM python:3.7-alpine

LABEL maintainer="Aderemi Adesada <adesadaaderemi@gmail.com>"

USER root

RUN apk add --no-cache ffmpeg bzip2 postgresql-libs postgresql-client\
    && apk add --no-cache --virtual .build-deps make jpeg-dev zlib-dev musl-dev gcc g++ libffi-dev postgresql-dev

ARG ZOU_VERSION
# ARG EAXUM_ZOU_VERSION

RUN pip install --upgrade pip wheel setuptools \
    && pip install zou==${ZOU_VERSION}\
    # && pip install eaxum-zou==${EAXUM_ZOU_VERSION}\
    && apk del .build-deps

ENV ZOU_FOLDER /usr/local/lib/python3.7/site-packages/zou
WORKDIR ${ZOU_FOLDER}

COPY init_zou.sh ./init_zou.sh
COPY upgrade_zou.sh ./upgrade_zou.sh

RUN apk add --no-cache --virtual .build-deps git

# COPY genesys_addon /usr/local/lib/python3.7/site-packages/zou/app/services/genesys_addon

ADD https://api.github.com/repos/Aderemi-Adesada/genesys_kitsu_addon/git/refs/heads/master /usr/local/lib/python3.7/site-packages/zou/app/services/genesys_version.json

RUN git clone --single-branch --depth 1 https://github.com/Aderemi-Adesada/genesys_kitsu_addon /usr/local/lib/python3.7/site-packages/zou/app/services/genesys_addon\
    && apk --purge del .build-deps