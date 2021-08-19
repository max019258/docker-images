FROM alpine  

RUN apk add tzdata
RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN apk add python2
RUN mkdir www
RUN cd www
###RUN python -m SimpleHTTPServer 8000 

