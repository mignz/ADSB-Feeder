#!/bin/bash

# DO NOT RUN THIS SCRIPT UNLESS YOU KNOW WHAT YOU'RE DOING!!!

docker.exe stop ADSB-Feeder
docker.exe rm ADSB-Feeder
docker.exe image rm adsb-feeder
#docker.exe system prune -a

docker.exe build -t adsb-feeder .
docker.exe run -dit \
    --restart unless-stopped \
    --name ADSB-Feeder \
    -p 8080:8080 -p 8754:8754 \
    -e FR24KEY=YOUR_FLIGHTRADAR24_KEY_HERE \
    -e PIAWAREUSER="YOUR_FLIGHTAWARE_USER_HERE" \
    -e PIAWAREPASS="YOUR_FLIGHTAWARE_PASS_HERE" \
    -e PIAWAREKEY="YOUR_FLIGHTAWARE_KEY_HERE" \
    -e MAPLAT="41.2403" \
    -e MAPLON=-"8.6770" \
    -e MAPZOOM=8 \
    adsb-feeder

docker.exe exec -it ADSB-Feeder bash
