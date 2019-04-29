# Originally baikal was developed for php5 which needed a an
# alpine image of 3.5
FROM alpine:3.5

# See http://label-schema.org/rc1/ and https://microbadger.com/labels
LABEL org.label-schema.name="baikal+infcloud - CalDAV/CardDAV web stack" \
  org.label-schema.description="CalDAV/CardDAV web client and server implementation based on Alpine Linux"

ENV URL_BAIKAL=https://github.com/fruux/Baikal/releases/download/0.4.6/baikal-0.4.6.zip
ENV URL_INFCLOUD=https://www.inf-it.com/InfCloud_0.13.1.zip
ENV WEBROOT=/var/www

ARG TIMEZONE=Europe/Berlin
ENV TIMEZONE=${TIMEZONE}

WORKDIR ${WEBROOT}

# need zip / unzip for build process to support symlinks in archives.
# We need store to files before as with newer zip/unzip pipelining is not possible
RUN apk --no-cache update && apk --no-cache upgrade \
  && apk --no-cache add wget ca-certificates unzip tzdata lighttpd sqlite php5-cgi php5-sqlite3 php5-dom \
  php5-openssl php5-pdo php5-pdo_sqlite php5-xml php5-xmlreader php5-json \
  php5-pdo_mysql php5-mysqli php5-ctype \
  && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && echo ${TIMEZONE} > /etc/timezone && date \
  && wget -O baikal.zip -q ${URL_BAIKAL} && unzip baikal.zip -d ${WEBROOT}/ && rm baikal.zip \
  && wget -O infcloud.zip -q ${URL_INFCLOUD} && unzip infcloud.zip -d ${WEBROOT}/ && rm infcloud.zip \
  && apk del -rf --purge unzip wget ca-certificates tzdata \
  && sed -ie "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g" /etc/php5/php.ini \
  && mkdir ${WEBROOT}/.well-known

COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY infcloud.config.js ${WEBROOT}/infcloud/config.js:ro

# TODO: use "USER" directive to change owner end cve rights

# Put sqlite database and configuration on a volume to preserve for updates
VOLUME ["${WEBROOT}/baikal/Specific"]

EXPOSE 8800

# using default entrypoint as we have a single purpose.
CMD [ "lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf" ]