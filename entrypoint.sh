#!/bin/bash

echo -e "$(date +"%Y-%m-%d %T") Reader Java Version = ${READER_JAVA_VERSION}\n$(date +"%Y-%m-%d %T") TZ = ${TZ}\n$(date +"%Y-%m-%d %T") PUID = ${PUID}\n$(date +"%Y-%m-%d %T") PGID = ${PGID}\n$(date +"%Y-%m-%d %T") Umask = ${UMASK}"

chown -R ${PUID}:${PGID} \
    /logs \
    /storage \
    /app/bin/reader.jar

umask ${UMASK}

if [ "${READER_JAVA_VERSION}" = "openj9" ]; then
    exec gosu     ${PUID}:${PGID} java -jar /app/bin/reader.jar
else
    if [ "${READER_JAVA_VERSION}" = "openjdk-8" ]; then
        exec su-exec  ${PUID}:${PGID} java -jar /app/bin/reader.jar
    else
        $(date +"%Y-%m-%d %T") Reader failed to start
    fi
fi
