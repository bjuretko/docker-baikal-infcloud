#!/bin/sh
set -e

# get uid of the shared volume which is the uid from the host directory
UID=${UID:-$(stat -c '%u' ${BAIKAL_DATA})}

if [ "$(id -u nobody)" -ne "${UID}" -a "${UID}" -ge "0" ]; then
  # we will install usermod here to change the uid of the user "nobody"
  # see https://github.com/chrootLogin/docker-nextcloud/issues/3
  echo "Modding uid of user nobody to ${UID}"
  apk --no-cache add shadow
  usermod -u ${UID} nobody || true
  chown -R nobody:nobody ${BAIKAL_DATA}
  apk del -rf --purge shadow
fi

# print uid/gid of "nobody" for verification
su-exec nobody:nobody id
# run CMD from Dockerfile or from a `docker run` as user "nobody" (non-root)
exec su-exec nobody:nobody "$@"