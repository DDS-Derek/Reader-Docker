#!/bin/bash

echo -e "$(date +"%Y-%m-%d %T") Reader Java Version = ${READER_VERSION}\n$(date +"%Y-%m-%d %T") TZ = ${TZ}\n$(date +"%Y-%m-%d %T") PUID = ${PUID}\n$(date +"%Y-%m-%d %T") PGID = ${PGID}\n$(date +"%Y-%m-%d %T") Umask = ${UMASK}"

chown -R ${PUID}:${PGID} \
    /logs \
    /storage \
    /app/bin/reader.jar

umask ${UMASK}

if [ "${READER_VERSION}" = "openj9" ]; then
    exec gosu     ${PUID}:${PGID} java -jar /app/bin/reader.jar
else
    exec su-exec  ${PUID}:${PGID} java -jar /app/bin/reader.jar
fi
