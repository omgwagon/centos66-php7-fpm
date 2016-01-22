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
                   nginx \
                   php70-php-mcrypt

RUN ln -s /usr/bin/php70 /usr/bin/php
COPY ./conf/php-fpm.conf /etc/opt/remi/php70/php-fpm.d/www.conf

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

RUN php -r "readfile('https://getcomposer.org/installer');" | php
RUN mv composer.phar /usr/bin/composer

WORKDIR /var/www/html
COPY ./app /var/www/html

EXPOSE 9000 80

CMD /opt/remi/php70/root/usr/sbin/php-fpm ; nginx -g 'daemon off;'
