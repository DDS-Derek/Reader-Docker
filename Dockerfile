ARG READER_TAG=3.0.0

FROM hectorqin/reader:${READER_TAG} AS CHOOSE

FROM openjdk:8-jdk-alpine

RUN apk add --no-cache ca-certificates tini tzdata su-exec bash; \
    update-ca-certificates; \
    rm -rf /var/cache/apk/*;

COPY --chmod=755 --from=CHOOSE /app/bin/reader.jar /app/bin/reader.jar
COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENV PS1="\[\e[32m\][\[\e[m\]\[\e[36m\]\u \[\e[m\]\[\e[37m\]@ \[\e[m\]\[\e[34m\]\h\[\e[m\]\[\e[32m\]]\[\e[m\] \[\e[37;35m\]in\[\e[m\] \[\e[33m\]\w\[\e[m\] \[\e[32m\][\[\e[m\]\[\e[37m\]\d\[\e[m\] \[\e[m\]\[\e[37m\]\t\[\e[m\]\[\e[32m\]]\[\e[m\] \n\[\e[1;31m\]$ \[\e[0m\]" \
    READER_JAVA_VERSION=openjdk-8 \
    TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=1000 \
    UMASK=022

ENTRYPOINT ["/sbin/tini", "/entrypoint.sh"]

EXPOSE 8080

VOLUME [ "/storage" ]
VOLUME [ "/logs" ]