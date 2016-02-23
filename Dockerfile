FROM node:4.3

ENV NGINX_VERSION 1.9.11-1~jessie

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y ca-certificates nginx=${NGINX_VERSION} gettext-base \
	&& rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y supervisor

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

COPY config/nginx.conf /etc/nginx/conf.d/nginx.conf
COPY config/cert.crt /etc/ssl/private/certificate.crt
COPY config/cert.key /etc/ssl/private/certificate.key
COPY config/dh.pem /etc/ssl/private/dh.pem

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY package.json /usr/src/app/
RUN npm install
COPY . /usr/src/app

EXPOSE 80 443
CMD ["/usr/bin/supervisord"]
