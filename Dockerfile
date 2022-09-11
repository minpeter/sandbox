FROM python:3.10-alpine

RUN apk add socat

WORKDIR /app

ENV PORT 1337
ENV FILE_NAEM main.py

COPY $FILE_NAEM .
COPY flag.txt .

CMD ["socat" , "-T60" , "-dd" , "-v" , "-v" , "TCP-LISTEN:"+$PORT+",reuseaddr,fork" , "EXEC:python3 "+$FILE_NAEM+",pty,stderr,setsid,sigint,sane"]