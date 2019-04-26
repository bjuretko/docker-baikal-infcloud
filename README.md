# docker-baikal-infcloud
Dockerized lighttpd + php5 + baikal + sqlite3 + infcloud (e.g. for NAS)

# Install and setup

You need docker, docker-compose installed. The path `./baikal/db` must be writable.

```bash
docker-compose up
```

Visit http://localhost:8800/baikal/html/admin/ to configure baikal.

# Default config

- no mail support
- Cal/CardDAV URL: 
- CardDAV URL: http://localhost:8800/baikal/html/dav.php/principals/
- Infcloud: http://localhost:8800/infcloud/

# Autodiscovery

You can support easy mail-style (*username@hostname.domain*) setup by with 
configuring service discovery features as described.
[here](http://sabre.io/dav/service-discovery/).

