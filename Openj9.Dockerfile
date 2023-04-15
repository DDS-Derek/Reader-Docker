ARG READER_TAG=3.0.2

FROM hectorqin/reader:openj9-${READER_TAG} AS CHOOSE

FROM ibm-semeru-runtimes:open-8u332-b09-jre

RUN apt-get update -y && apt-get install ca-certificates dumb-init tzdata gosu bash -y; \
    update-ca-certificates; \
    ln -sf /usr/sbin/gosu /usr/bin/su-exec; \
    rm -rf /var/lib/apt/lists/*

COPY --chmod=755 --from=CHOOSE /app/bin/reader.jar /app/bin/reader.jar
COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENV READER_JAVA_VERSION=openj9 \
    TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=1000 \
    UMASK=022

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["java", "-jar", "/app/bin/reader.jar" ]

EXPOSE 8080

VOLUME [ "/storage" ]
VOLUME [ "/logs" ]