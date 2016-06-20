FROM alpine
MAINTAINER Bailey Stoner <code@monokro.me>


RUN apk update
RUN apk upgrade

RUN apk add build-base
RUN apk add nodejs
RUN apk add python
RUN apk add libzmq zeromq-dev


RUN npm install -g coffee-script


ADD . /opt/informjs/daemon
WORKDIR /opt/informjs/daemon
RUN rm -rf node_modules
RUN npm install
RUN npm link
RUN npm link inform-shared
RUN npm link inform-daemon


EXPOSE 5000


WORKDIR /opt/informjs/daemon
CMD ["bin/informd"]
