FROM ubuntu:latest

RUN apt update && apt install haproxy

COPY haproxy.cfg /

EXPOSE 80
ENTRYPOINT ["/usr/bin/haproxy -f /haproxy.cfg -W"]
