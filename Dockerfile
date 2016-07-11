FROM node:4.3

# Install Nginx
ENV NGINX_VERSION 1.11.1-1~jessie

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y ca-certificates nginx=${NGINX_VERSION} gettext-base \
	&& rm -rf /var/lib/apt/lists/*

# Install supervisor
RUN apt-get update && apt-get install -y supervisor

# Configure nginx
RUN rm /etc/nginx/conf.d/default.conf
COPY config/nginx.conf /etc/nginx/conf.d/nginx.conf
# SSL
COPY config/cert.crt /etc/ssl/private/certificate.crt
COPY config/cert.key /etc/ssl/private/certificate.key
COPY config/dh.pem /etc/ssl/private/dh.pem

# Configure supervisor
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create workdir
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Add application
COPY package.json /usr/src/app/
RUN npm install
COPY . /usr/src/app

EXPOSE 80 443
CMD ["/usr/bin/supervisord"]
