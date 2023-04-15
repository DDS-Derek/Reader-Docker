#!/bin/bash

echo -e "$(date +"%Y-%m-%d %T") Reader Java Version = ${READER_JAVA_VERSION}\n$(date +"%Y-%m-%d %T") TZ = ${TZ}\n$(date +"%Y-%m-%d %T") PUID = ${PUID}\n$(date +"%Y-%m-%d %T") PGID = ${PGID}\n$(date +"%Y-%m-%d %T") Umask = ${UMASK}"

chown -R ${PUID}:${PGID} \
    /logs \
    /storage \
    /app/bin/reader.jar

umask ${UMASK}

exec su-exec ${PUID}:${PGID} dumb-init $*
