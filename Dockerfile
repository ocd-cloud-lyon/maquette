# use a base image
FROM php:7.3-apache
COPY src/ /var/www/html/

#mise à jour des paquets
RUN apt-get update -y

# set maintainer
LABEL maintainer "ocd-cloud-lyon"

# set a health check
HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:80|| exit 1

# tell docker what port to expose
EXPOSE 80
