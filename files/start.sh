#!/bin/bash

sed -i "/fr24key/c\fr24key=\"${FR24KEY}\"" /etc/fr24feed.ini
sed -i "/flightaware-user/c\flightaware-user ${PIAWAREUSER}" /etc/piaware.conf
sed -i "/flightaware-password/c\flightaware-password ${PIAWAREPASS}" /etc/piaware.conf
sed -i "/feeder-id/c\feeder-id ${PIAWAREKEY}" /etc/piaware.conf
sed -i "/latitude/c\  \"latitude\": \"${PFLATITUDE}\"," /etc/pfclient.json
sed -i "/longitude/c\  \"longitude\": \"${PFLONGITUDE}\"," /etc/pfclient.json
sed -i "/sharecode/c\  \"sharecode\": \"${PFSHARECODE}\"" /etc/pfclient.json

[ ! -z "${MAPLAT}" ] && sed -i "/DefaultCenterLat/c\DefaultCenterLat = ${MAPLAT};" /usr/lib/fr24/public_html/config.js
[ ! -z "${MAPLON}" ] && sed -i "/DefaultCenterLon/c\DefaultCenterLon = ${MAPLON};" /usr/lib/fr24/public_html/config.js
[ ! -z "${MAPZOOM}" ] && sed -i "/DefaultZoomLvl/c\DefaultZoomLvl = ${MAPZOOM};" /usr/lib/fr24/public_html/config.js

/usr/bin/s6-svscan /etc/s6
