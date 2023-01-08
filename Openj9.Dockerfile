ARG READER_TAG=2.7.3

FROM hectorqin/reader:openj9-${READER_TAG} AS CHOOSE

FROM ibm-semeru-runtimes:open-8u332-b09-jre

RUN apt-get update -y && apt-get install ca-certificates tini tzdata gosu bash -y; \
    update-ca-certificates; \
    rm -rf /var/lib/apt/lists/*

COPY --chmod=755 --from=CHOOSE /app/bin/reader.jar /app/bin/reader.jar
COPY --chmod=755 entrypoint.sh /entrypoint.sh

ENV PS1="\[\e[32m\][\[\e[m\]\[\e[36m\]\u \[\e[m\]\[\e[37m\]@ \[\e[m\]\[\e[34m\]\h\[\e[m\]\[\e[32m\]]\[\e[m\] \[\e[37;35m\]in\[\e[m\] \[\e[33m\]\w\[\e[m\] \[\e[32m\][\[\e[m\]\[\e[37m\]\d\[\e[m\] \[\e[m\]\[\e[37m\]\t\[\e[m\]\[\e[32m\]]\[\e[m\] \n\[\e[1;31m\]$ \[\e[0m\]" \
    TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=1000 \
    UMASK=022

ENV READER_JAVA_VERSION=openj9

ENTRYPOINT ["/usr/bin/tini", "/entrypoint.sh"]

EXPOSE 8080

VOLUME [ "/storage" ]
VOLUME [ "/logs" ]