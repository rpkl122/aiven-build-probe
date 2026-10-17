FROM alpine:3.20
RUN mkdir -p /www
COPY entry.sh /entry.sh
COPY index.html /www/index.html
RUN chmod +x /entry.sh
EXPOSE 8080
ENTRYPOINT ["/entry.sh"]
