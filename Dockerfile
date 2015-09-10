FROM debian:jessie
MAINTAINER Stéphane Busso <stephane.busso@gmail.com>

# Install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install curl php5 php5-fpm php5-gd \
    php5-sqlite php-pear php5-mysql \
    php5-mcrypt php5-curl && \
    apt-get -y -q autoclean && apt-get -y -q autoremove

# tweak php-fpm config
RUN sed -i 's/^listen.allowed_clients/;listen.allowed_clients/' /etc/php5/fpm/pool.d/www.conf && \
sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini && \
sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 20M/g" /etc/php5/fpm/php.ini && \
sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 20M/g" /etc/php5/fpm/php.ini && \
sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf && \
sed -i -e "s/;log_level\s*=\s*notice/log_level = notice/g" /etc/php5/fpm/php-fpm.conf && \
sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf && \
sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" /etc/php5/fpm/pool.d/www.conf && \
sed -i '/^listen /c listen = 0.0.0.0:9000' /etc/php5/fpm/pool.d/www.conf && \
sed -i -e "s/user\s*=\s*www-data/user = root/g" /etc/php5/fpm/pool.d/www.conf && \
sed -i -e "s/group\s*=\s*www-data/group = root/g" /etc/php5/fpm/pool.d/www.conf

EXPOSE 9000
ENTRYPOINT ["/usr/sbin/php5-fpm", "-R"]
