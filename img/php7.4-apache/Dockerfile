FROM wernerdweight/php7.4-composer:latest AS base

LABEL maintainer="Werner Dweight Solutions <info@wds.blue>" \
      version="1.0" \
      description="PHP 7.4 Apache version"

# install apache
RUN apk add \
	apache2 apache2-ssl php7-apache2 curl ca-certificates openssl openssh \
	php7-pdo php7-pdo_pgsql php7-ctype php7-json php7-session php7-tokenizer \
	php7-dom php7-xml php7-xmlreader php7-xmlwriter php7-simplexml \
	php7-mbstring php7-iconv php7-mcrypt php7-curl php7-zip php7-posix \
	php7-intl php7-opcache php7-fileinfo php7-exif php7-gd php7-openssl php7-amqp

# set-up apache environment
RUN set -e && \
    sed -i \
        -e "s/User\ apache/User\ www-data/" \
        -e "s/Group\ apache/Group\ www-data/" \
        -e "s/Listen 80/Listen 8080/" \
        -e "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" \
        -e "s/#LoadModule\ session_module/LoadModule\ session_module/" \
        -e "s/#LoadModule\ session_cookie_module/LoadModule\ session_cookie_module/" \
        -e "s/#LoadModule\ session_crypto_module/LoadModule\ session_crypto_module/" \
        -e "s/#LoadModule\ deflate_module/LoadModule\ deflate_module/" \
        -e "240,270s/AllowOverride None/AllowOverride All/" \
        -e "s#Options -Indexes FollowSymLinks#Options -Indexes +FollowSymLinks#" \
        -e "s#^DocumentRoot \".*#DocumentRoot \"/var/www/html/public\"#g" \
        -e "s#/var/www/localhost/htdocs#/var/www/html/public#" \
        /etc/apache2/httpd.conf && \
    printf "\n<Directory \"/var/www/html\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf && \
    # create default web page
    mkdir /var/www/html/public && \
    echo "<!DOCTYPE html><body><?php echo '<p>Hello World</p>'; ?></body></html>" > /var/www/html/public/index.php && \
    # set permissions and ownership
    chown -R www-data:www-data /var/www/html /var/www/logs /var/www/modules /var/www/run /var/log/apache2 /usr/lib/apache2 /run/apache2 && \
    chmod -R 755 /var/www/html /var/www/logs /var/www/modules /var/www/run /var/log/apache2 /usr/lib/apache2 /run/apache2 && \
    # smoke test
    httpd -v

EXPOSE 8080 7443

CMD ["httpd", "-D", "FOREGROUND"]
