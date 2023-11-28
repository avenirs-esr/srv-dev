# Resource https://hub.docker.com/_/httpd?tab=description
FROM httpd:2.4
LABEL author="Arnaud Deman"
RUN apt-get update && apt-get install -y ssl-cert
COPY docker-conf/httpd-ssl.conf /usr/local/apache2/conf/extra/httpd-ssl.conf
RUN sed -i \
		-e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
		-e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
		-e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
		conf/httpd.conf
# COPY ./public-html/ /usr/local/apache2/htdocs/