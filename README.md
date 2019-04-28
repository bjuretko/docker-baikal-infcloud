# docker-baikal-infcloud
Dockerized [lighttpd](https://www.lighttpd.net/) + 
php5 + [baikal](https://github.com/sabre-io/Baikal) + 
sqlite3 + [infcloud](https://www.inf-it.com/open-source/clients/infcloud/) 
based on [Alpine Linux](https://mirrordocker.com/_/alpine) (e.g. for NAS)

![Infcloud webinterface](doc/infcloud.png)

# Why?

- self-hosted on synology NAS: Synology does not provide an out-of-box solution. 
  There is the CardDAV Servr, 
  the WebDAV Server. now even a Calendar Service with integrated web frontend 
  (but without adressbook). The cons: many spreaded packages and services, with 
  rather old dependencies. You cannot set seperate user/credentials for the DAV
  access which is not soa from a security standpoint as 2fa are not possible and
  simple basic auth mechanisms may leak.
- Alternatives like owncloud/nextcloud or other colaboration suites are too much
  for this simple usecase
- Using baikal for several years without any bigger issues makes it pretty robust
  for family or internal small company/team management.
- You do not need email or other shared services
- Widely supported clients, unfortunetly not natively with Android.
- create backups of calendar and contact data
- Syncs well with Windows, MacOS, Android and iOS

> I use this setup for personal management with the family. As we used it for 
> several years, this project is supporting my migration from a DS213j to 
> DS718+ with Docker. Still not that easy to convince everybody to use cloud ☁︎ 
> services 🤷🏻‍.

# Install and setup

You need docker, docker-compose installed. The path `./baikal/db` must be writable.

```bash
docker-compose up
```

Visit http://localhost:8800/baikal/html/admin/ to configure baikal.

# Default config

- no mail support
- Cal/CardDAV URL: http://localhost:8800/baikal/html/dav.php/principals/
- Infcloud: http://localhost:8800/infcloud/

# Autodiscovery

You can support easy mail-style (*username@hostname.domain*) setup by with 
configuring service discovery features as described.
[here](http://sabre.io/dav/service-discovery/).

# HTTPs / SSL / TLS

The current setup does not support https directly and suppose an existing reverse proxy (e.g. https://traefik.io)

