FROM scratch

COPY webhook /webhook
EXPOSE 9000/tcp

ENTRYPOINT ["/webhook"]