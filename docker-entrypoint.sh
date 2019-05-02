#!/bin/sh
set -e

# This entrypoint script just sets the correct permissions on the
# shared volume and executes CMD with the less-privileged user "nobody"
# See https://github.com/moby/moby/issues/22258 for more information
# on the issue with permissions on shared volume.

# get uid of the shared volume which is the uid from the host directory
UID=${UID:-$(stat -c '%u' ${BAIKAL_DATA})}

# if UID is already remapped or we are root (like on macOS) do nothing
# if not set uid of "nobody" to the host's uid of the shared volume
if [ "$(id -u nobody)" -ne "${UID}" -a "${UID}" -ge "0" ]; then
  mkdir -p ${BAIKAL_DATA}/db
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