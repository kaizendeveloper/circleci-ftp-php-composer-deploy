FROM alpine:3.12
RUN apk update --no-cache && apk --no-cache add bash curl git make

#tag="$(git tag | grep '^[0-9]*\.[0-9]*\.[0-9]*$' | tail -1)"
#Explain: List all tag inside this repo and filter as follows number.number.number, ignore the rest, then take the lastest on the list though tail command, checkout that tag then install, delete the repo afterwards

RUN git clone https://github.com/git-ftp/git-ftp.git /opt/git-ftp && \
cd /opt/git-ftp && tag="$(git tag | grep '^[0-9]*\.[0-9]*\.[0-9]*$' | tail -1)" && \
git checkout "$tag" && make install && rm -rf /opt/git-ftp

RUN apk add php7 php7-intl php7-openssl php7-zip php7-gd php7-bz2 php7-pdo_odbc php7-pdo php7-pdo_sqlite \
php7-pdo_pgsql php7-pdo_dblib php7-intl php7-pecl-mcrypt php7-pecl-imagick php7-imap php7-xmlrpc php7-xmlreader \
php7-simplexml php7-xml php7-xmlwriter php7-soap php7-gettext php7-xsl php7-exif php7-pear php7-json php7-phar

RUN addgroup -g 3434 circleci && adduser -u 3434 -G circleci -h /home/circleci -D circleci

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
php -r "if (hash_file('sha384', 'composer-setup.php') === 'c31c1e292ad7be5f49291169c0ac8f683499edddcfd4e42232982d0fd193004208a58ff6f353fde0012d35fdd72bc394') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
php composer-setup.php && \
php -r "unlink('composer-setup.php');" && echo '/usr/bin/php /composer.phar' > /usr/bin/composer && chmod a+x /usr/bin/composer




