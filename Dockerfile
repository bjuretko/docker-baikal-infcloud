# Originally baikal was developed for php5 which needed a an
# alpine image of 3.4
# Latest alpines only support php7 which is why we are using a
# fork of Baikal from ByteHamster
FROM alpine:latest

# See http://label-schema.org/rc1/ and https://microbadger.com/labels
LABEL org.label-schema.name="baikal+infcloud - CalDAV/CardDAV web stack" \
  org.label-schema.description="CalDAV/CardDAV web client and server implementation based on Alpine Linux"

# Fork of 0.4.6 with fixed php7.2 each() deprecation and updates sabredav
# see PR https://github.com/sabre-io/Baikal/pull/768
# https://github.com/ByteHamster/Baikal/archive/upgrade-sabredav.zip
# this need to be build before
# Original 0.4.6 release: https://github.com/fruux/Baikal/releases/download/0.4.6/baikal-0.4.6.zip
ENV URL_BAIKAL=https://github.com/ByteHamster/Baikal/archive/upgrade-sabredav.zip
ENV URL_INFCLOUD=https://www.inf-it.com/InfCloud_0.13.1.zip
ENV WEBROOT=/var/www

WORKDIR $WEBROOT

# need zip / unzip for build process to support symlinks in archives.
# We need store to files before as with newer zip/unzip pipelining is not possible
RUN apk --no-cache update && apk --no-cache upgrade \
  && apk --no-cache add wget lighttpd sqlite php7-cgi php7-sqlite3 php7-dom \
  php7-openssl php7-pdo php7-pdo_sqlite \
  php7-pdo_mysql php7-mysqli php7-ctype \
  php7-session php7-mbstring \
  && apk add  php7-simplexml php7-tokenizer php7-xmlwriter php7-xmlreader composer make rsync unzip zip \
  && wget -O infcloud.zip -q ${URL_INFCLOUD} && unzip infcloud.zip -d $WEBROOT/ && rm infcloud.zip \
  && wget -O baikal.zip -q ${URL_BAIKAL} && unzip baikal.zip -d $WEBROOT/ && rm baikal.zip \
  && cd Baikal-upgrade-sabredav && make build-assets && make dist && mv build/baikal .. && cd .. && rm -rf Baikal-upgrade-sabredav \ 
  && apk del -rf --purge unzip zip wget ca-certificates php7-simplexml php7-tokenizer php7-xmlwriter php7-xmlreader composer make rsync

COPY lighttpd.conf /etc/lighttpd/lighttpd.conf

# TODO: use "USER" directive to change owner end cveexec rights

# Put sqlite database and configuration on a volume to preserve for updates
VOLUME ["${WEBROOT}/baikal/Specific"]

EXPOSE 80

CMD [ "lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf" ]