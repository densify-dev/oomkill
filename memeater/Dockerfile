FROM alpine:3.19

RUN addgroup -g 3000 densify && adduser -h /home/densify -s /bin/sh -u 3000 -G densify -g "" -D densify && chmod 755 /home/densify

WORKDIR /home/densify
COPY --chown=densify:densify --chmod=755 ./*.sh bin/
USER 3000
CMD ["/home/densify/bin/eatmem.sh"]
