FROM python:3.10-alpine

RUN apk add --no-cache socat
WORKDIR /app

ENV PORT 1337
ENV FILE_NAEM main.py

COPY $FILE_NAEM .
COPY flag.txt .
EXPOSE $PORT

CMD socat TCP-LISTEN:$PORT,reuseaddr,fork EXEC:"python3 $FILE_NAEM"