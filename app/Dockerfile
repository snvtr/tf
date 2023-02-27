FROM ubuntu:latest

RUN apt update && apt install -y python3-flask

COPY templates templates
COPY app.py boot.sh ./

RUN chmod +x boot.sh

EXPOSE 5000
ENTRYPOINT ["/usr/bin/python3 /app.py"]
