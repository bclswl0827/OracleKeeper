FROM alpine:latest

ADD entrypoint.sh /
RUN apk add --no-cache bash ffmpeg youtube-dl \
    && chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
