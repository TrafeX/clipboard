FROM node:7.5-alpine

# Install packages
RUN apk --no-cache add nginx supervisor

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

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
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
