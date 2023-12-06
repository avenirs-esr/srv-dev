# Resource https://hub.docker.com/_/httpd?tab=description
FROM httpd:2.4
LABEL author="Arnaud Deman"

ARG OVERLAY_DIR
ENV APACHE_OVERLAY_DIR=$OVERLAY_DIR
RUN apt-get update && apt-get install -y ssl-cert
COPY $APACHE_OVERLAY_DIRNAME/conf/extra/* /usr/local/apache2/conf/extra/
COPY $APACHE_OVERLAY_DIRNAME/conf/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY $APACHE_OVERLAY_DIRNAME/htdocs/index.html /usr/local/apache2/htdocs/index.html
