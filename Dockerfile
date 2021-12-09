FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
	apt-get install apache2 -y && \
	apt-get install apache2-utils -y && \
	apt-get install sudo -y && \
	apt-get install vim -y

RUN a2enmod autoindex
RUN a2enmod rewrite
RUN a2enmod ssl

COPY site1.conf /etc/apache2/sites-available
RUN sudo mkdir -p /var/www//html/site1/public_html
COPY index.html /var/www/html/site1/public_html
RUN a2ensite site1.conf

RUN mkdir -p /etc/apache2/ssl
RUN openssl req -x509 -nodes -days 365 -subj "/C=US/ST=CA/O=MySite/CN=site1.internal" -newkey rsa:2048 -keyout /etc/apache2/ssl/site1.internal.key -out /etc/apache2/ssl/site1.internal.crt

Label Maintainer: "edgar.aguilar.189@my.csun.edu"
Expose 80
Expose 443
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
