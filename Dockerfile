FROM alpine:3.9

# See http://label-schema.org/rc1/ and https://microbadger.com/labels
LABEL org.label-schema.name="baikal+infcloud - CalDAV/CardDAV web stack" \
  org.label-schema.description="CalDAV/CardDAV web client and server implementation based on Alpine Linux"

# For php5 the original release was version 0.4.6 : https://github.com/fruux/Baikal/releases/download/0.4.6/baikal-0.4.6.zip
# latest alpine images > 3.5 do no support php5 images but php7
# The fork of 0.4.6 with fixed php7.2 each() deprecation and updates sabredav
# see PR https://github.com/sabre-io/Baikal/pull/768 was merged and released
# as Version 0.5.2 which fixed issues with php7
ENV URL_BAIKAL=https://github.com/sabre-io/Baikal/releases/download/0.5.2/baikal-0.5.2.zip
ENV URL_INFCLOUD=https://www.inf-it.com/InfCloud_0.13.1.zip
ENV WEBROOT=/var/www

ARG TIMEZONE=Europe/Berlin
ENV TIMEZONE=${TIMEZONE}

WORKDIR ${WEBROOT}

# need zip / unzip for build process to support symlinks in archives.
# We need store to files before as with newer zip/unzip pipelining is not possible
RUN apk --no-cache update && apk --no-cache upgrade \
  && apk --no-cache add wget ca-certificates unzip zip lighttpd sqlite tzdata \
  php7-cgi php7-sqlite3 php7-dom \
  php7-openssl php7-pdo php7-pdo_sqlite php7-xml php7-xmlreader php7-xmlwriter php7-json \
  php7-pdo_mysql php7-mysqli php7-ctype php7-session php7-mbstring \
  && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && echo ${TIMEZONE} > /etc/timezone && date \
  && wget -O baikal.zip -q ${URL_BAIKAL} && unzip baikal.zip -d ${WEBROOT}/ && rm baikal.zip \
  && wget -O infcloud.zip -q ${URL_INFCLOUD} && unzip infcloud.zip -d ${WEBROOT}/ && rm infcloud.zip \
  && apk del -rf --purge unzip zip wget ca-certificates tzdata \
  && sed -ie "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=1/g" /etc/php7/php.ini \
  && mkdir ${WEBROOT}/.well-known

COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY infcloud.config.js ${WEBROOT}/infcloud/config.js:ro

# limit file permissions
RUN chmod -R g-w ${WEBROOT} && chown -R lighttpd:nobody ${WEBROOT}

# Run container as user nobody, the shared volume will have 
# hosts file permissions and is therefore writable by USER
USER nobody

# Put sqlite database and configuration on a volume to preserve for updates
VOLUME ["${WEBROOT}/baikal/Specific"]

EXPOSE 8800

# using default entrypoint as we have a single purpose.
CMD [ "lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf" ]