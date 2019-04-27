# docker-baikal-infcloud
Dockerized lighttpd + php5 + baikal + sqlite3 + infcloud (e.g. for NAS)

# Install and setup

## With sqlite

First build the image
```bash
docker build  --tag "alpine-infcloud-baikal:3.5-0.13.1-0.4.6" --tag "alpine-infcloud-baikal:latest" .
```

Test it with
```bash
docker run \
    --publish 8800:8800 \
    --volume "$(pwd)/baikal:/var/www/baikal/Specific" \
    "alpine-infcloud-baikal"
```

And point your Browser http://localhost:8800/baikal/html/admin/ to configure baikal.

To start the container detached (background) exec

```bash
docker run \
    --publish 8800:8800 \
    --volume "$(pwd)/baikal:/var/www/baikal/Specific" \
    --name baikal-infcloud \
    --restart always \
    --detach \
    "alpine-infcloud-baikal"
```

## With mysql

To start baikal with mariadb (mysql) backend you can use the provided docker-compose file.

You need docker, docker-compose installed. The path `./baikal/db` must be writable.

```bash
docker-compose up
```

Visit `http://localhost:8800/baikal/html/admin/` to configure baikal.

# Default config

- no mail support
- CalDAV URL: 
- CardDAV URL:


# Autodiscovery

You can support easy mail-style (*username@hostname.domain*) setup by with 
configuring service discovery features as described.
[here](http://sabre.io/dav/service-discovery/).

