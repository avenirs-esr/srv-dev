# Resource https://hub.docker.com/_/httpd?tab=description
FROM httpd:2.4
LABEL author="Arnaud Deman"
RUN apt-get update && apt-get install -y ssl-cert
COPY apache-files/conf/extra/* /usr/local/apache2/conf/extra/
COPY apache-files/conf/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY apache-files/htdocs/index.html /usr/local/apache2/htdocs/index.html
