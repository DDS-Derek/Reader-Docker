ARG VERSION=2.7.3

FROM hectorqin/reader:openj9-${VERSION} AS CHOOSE

FROM ibm-semeru-runtimes:open-8u332-b09-jre

RUN apt-get update -y; \
    apt-get install ca-certificates tini tzdata gosu bash -y; \
    update-ca-certificates; \
    rm -rf /var/lib/apt/lists/*

COPY --chmod=755 --from=CHOOSE /app/bin/reader.jar /app/bin/reader.jar
COPY --chmod=755 Openj9.entrypoint.sh /entrypoint.sh

ENV TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=1000 \
    UMASK=022

ENTRYPOINT ["/usr/bin/tini", "/entrypoint.sh"]

EXPOSE 8080

VOLUME [ "/storage" ]
VOLUME [ "/logs" ]