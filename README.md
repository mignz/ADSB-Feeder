# Docker ADS-B Feeder

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This is a [Docker](https://www.docker.com/) image providing the required applications to share [ADS-B](https://en.wikipedia.org/wiki/Automatic_dependent_surveillance_%E2%80%93_broadcast) data to [Flightradar24](https://www.flightradar24.com/), [Plane Finder](https://planefinder.net/) and [FlightAware](https://flightaware.com/) using [dump1090](https://github.com/flightaware/dump1090) and an [RTL-SDR DVB-T USB](https://shop.jetvision.de/epages/64807909.sf/en_GB/?ObjectPath=/Shops/64807909/Products/53200) dongle.

Inside:

- **fr24feed** w/ FR24 Feeder Status (Web, port 8754)
- **pfclient** w/ Web Viewer (Web, port 30053)
- **piaware**
- **dump1090-fa** w/ PiAware Viewer (Web, port 8080)

_**Note:** This image assumes you already have a Flightradar24 and FlightAware data sharing key. If not, instructions on how to get them are on their website._

## Usage

```shell
docker run -dit \
    --restart unless-stopped \
    --name ADSB-Feeder \
    -e FR24KEY=YOUR_FLIGHTRADAR24_KEY_HERE \
    -e PFLATITUDE=YOUR_PLANEFINDER_LATITUDE_HERE \
    -e PFLONGITUDE=YOUR_PLANEFINDER_LONGITUDE_HERE \
    -e PFSHARECODE=YOUR_PLANEFINDER_SHARE_CODE_HERE \
    -e PIAWAREUSER=YOUR_FLIGHTAWARE_USER_HERE \
    -e PIAWAREPASS=YOUR_FLIGHTAWARE_PASS_HERE \
    -e PIAWAREKEY=YOUR_FLIGHTAWARE_KEY_HERE \
    -e MAPLAT=YOUR_MAP_DEFAULT_LATITUDE_HERE \
    -e MAPLON=-YOUR_MAP_DEFAULT_LONGITUDE_HERE \
    -e MAPZOOM=YOUR_MAP_DEFAULT_ZOOM_LEVEL_HERE \
    -p 8080:8080 -p 8754:8754 -p 30053:30053 \
    --device=/dev/bus/usb:/dev/bus/usb \
    mnunes/adsb-feeder:latest
```

_**Note:** Latitude and longitude values in decimal format._

Open [http://docker-ip:8080](http://docker-ip:8080), [http://docker-ip:8754](http://docker-ip:8754) and [http://docker-ip:30053](http://docker-ip:30053) in your browser.

## Environment Variables

| **Variable** | **Description**                                                                          | **Default** | **Required** | **Example**                          |
|--------------|------------------------------------------------------------------------------------------|-------------|--------------|--------------------------------------|
| FR24KEY      | Flightradar24 sharing key                                                                | n/a         | **Yes**      | 0123456709abcdef                     |
| PFLATITUDE   | Plane Finder - antenna latitude                                                          | n/a         | **Yes**      | 38.12345                             |
| PFLONGITUDE  | Plane Finder - antenna longitude                                                         | n/a         | **Yes**      | -9.135259                            |
| PFSHARECODE  | Plane Finder share code                                                                  | n/a         | **Yes**      | 1a2bc3d4ef567                        |
| PIAWAREUSER  | FlightAware user name                                                                    | n/a         | **Yes**      | myuser                               |
| PIAWAREPASS  | FlightAware password                                                                     | n/a         | **Yes**      | mypass                               |
| PIAWAREKEY   | FlightAware sharing key                                                                  | n/a         | **Yes**      | e9ff318d-4e4f-42ff-9a15-bde6ec92610d |
| MAPLAT       | Default PiAware Viewer map latitude                                                      | 45.0        | No           | 38.12345                             |
| MAPLON       | Default PiAware Viewer map longitude                                                     | 9.0         | No           | -9.135259                            |
| MAPZOOM      | Default PiAware Viewer map [zoom level](https://wiki.openstreetmap.org/wiki/Zoom_levels) | 7           | No           | 8                                    |

## Build

```shell
git clone git@github.com:mignz/ADSB-Feeder.git
cd ADSB-Feeder && docker build -t adsb-feeder .
```

## Changes

### 1.1.0

- Added Plane Finder
