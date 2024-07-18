# Resource https://hub.docker.com/_/httpd?tab=description
FROM httpd:2.4.56
LABEL author="Arnaud Deman"

ARG OVERLAY_DIR
ENV APACHE_OVERLAY_DIR=$OVERLAY_DIR
RUN apt-get update && apt-get install -y ssl-cert

COPY $APACHE_OVERLAY_DIR/conf/extra/avenirs.conf.no-git /usr/local/apache2/conf/extra/avenirs.conf
COPY $APACHE_OVERLAY_DIR/etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/private/ssl-cert-snakeoil.key 
COPY $APACHE_OVERLAY_DIR/etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/certs/ssl-cert-snakeoil.pem 
COPY $APACHE_OVERLAY_DIR/conf/extra/httpd-ssl.conf /usr/local/apache2/conf/extra/
COPY $APACHE_OVERLAY_DIR/conf/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY $APACHE_OVERLAY_DIR/htdocs/index.html /usr/local/apache2/htdocs/index.html
COPY $APACHE_OVERLAY_DIR/htdocs/examples /usr/local/apache2/htdocs/examples/
COPY $APACHE_OVERLAY_DIR/htdocs/assets /usr/local/apache2/htdocs/assets
COPY $APACHE_OVERLAY_DIR/usr/local/apache2/bin/envvars /usr/local/apache2/bin/envvars