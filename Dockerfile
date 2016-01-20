FROM centos:6.6

COPY ./repos /root/repos
WORKDIR /root/repos
RUN rpm -Uvh remi-release-6.rpm epel-release-latest-6.noarch.rpm pgdg-centos94-9.4-1.noarch.rpm

RUN yum install -y php70 \
                   php70-php-fpm \
                   postgresql94-devel \
                   mbstring \
                   libmcrypt-devel \
                   php70-php-mbstring \
                   php70-php-mcrypt

RUN ln -s /usr/bin/php70 /usr/bin/php
RUN ln -s /opt/remi/php70/root/usr/sbin/php-fpm /usr/bin/php-fpm

RUN php -r "readfile('https://getcomposer.org/installer');" | php
RUN mv composer.phar /usr/bin/composer

WORKDIR /var/www/html

EXPOSE 9000

CMD php-fpm -F
