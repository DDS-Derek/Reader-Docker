#!/bin/bash

chown -R ${PUID}:${PGID} \
    /logs \
    /storage \
    /app/bin/reader.jar

umask ${UMASK}

exec gosu ${PUID}:${PGID} java -jar /app/bin/reader.jar
