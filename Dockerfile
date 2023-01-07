ARG VERSION=2.7.3

FROM hectorqin/reader:${VERSION} AS CHOOSE

FROM openjdk:8-jdk-alpine

RUN apk add --no-cache ca-certificates tini tzdata su-exec bash; \
    update-ca-certificates; \
    rm -rf /var/cache/apk/*;

COPY --chmod=755 --from=CHOOSE /app/bin/reader.jar /app/bin/reader.jar
COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENV TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=1000 \
    UMASK=022

ENV READER_VERSION=openjdk-8

ENTRYPOINT ["/sbin/tini", "/entrypoint.sh"]

EXPOSE 8080

VOLUME [ "/storage" ]
VOLUME [ "/logs" ]