FROM debian:10.3-slim

LABEL maintainer="me@mnunes.com"

ENV S6_VERSION=2.7.2.2-3 \
    RTLSDR_VERSION=0.6-1 \
    DUMP1090_VERSION=v3.8.0 \
    PIAWARE_VERSION=3.8.0 \
    FR24FEED_VERSION=1.0.24-5 \
    PFCLIENT_VERSION=4.1.1

ENV MAPLAT=45.0 \
    MAPLON=9.0 \
    MAPZOOM=7

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git \
        s6=$S6_VERSION \
        lighttpd \
        sudo \
        wget \
        build-essential \
        pkg-config \
        autoconf \
        net-tools \
        debhelper \
        python3-dev python3-venv \
        libncurses5-dev \
        libbladerf-dev \
        dh-systemd \
        libc6-i386 libc6-dev-i386 \
        libz-dev \
        libboost-system-dev libboost-program-options-dev libboost-regex-dev libboost-filesystem-dev \
        rtl-sdr=$RTLSDR_VERSION librtlsdr-dev=$RTLSDR_VERSION \
        tcl8.6-dev tclx8.4 tcllib tcl-tls itcl3 && \
    echo 'blacklist dvb_usb_rtl28xxu' > /etc/modprobe.d/no-rtl.conf && \
    git clone https://github.com/flightaware/dump1090.git /dump1090 && \
    cd /dump1090 && \
    git checkout $DUMP1090_VERSION && \
    make && \
    mkdir -p /usr/lib/fr24/public_html/data && \
    cp /dump1090/dump1090 /usr/lib/fr24/ && \
    cp -r /dump1090/public_html /usr/lib/fr24 && \
    rm -rf /dump1090 && \
    cd / && git clone https://github.com/flightaware/piaware_builder.git /piaware_builder && \
    cd /piaware_builder && \
    git checkout v$PIAWARE_VERSION && \
    ./sensible-build.sh buster && \
    cd /piaware_builder/package-buster && \
    dpkg-buildpackage -b && \
    cd /piaware_builder && \
    dpkg -i piaware_${PIAWARE_VERSION}_*.deb && \
    rm -rf /piaware_builder && \
    cd / && wget https://repo-feed.flightradar24.com/linux_x86_64_binaries/fr24feed_${FR24FEED_VERSION}_amd64.tgz && \
    tar zxvf fr24feed_${FR24FEED_VERSION}_amd64.tgz && \
    rm fr24feed_${FR24FEED_VERSION}_amd64.tgz && \
    mv /fr24feed_amd64/fr24feed /usr/bin && \
    rm -rf /fr24feed_amd64 && \
    cd / && wget -O pfclient.tar.gz http://client.planefinder.net/pfclient_${PFCLIENT_VERSION}_i386.tar.gz && \
    tar zxvf pfclient.tar.gz && \
    mv pfclient /usr/bin && \
    rm -rf pfclient.tar.gz

ADD files /

RUN chmod +x /etc/s6/fr24feed/* && \
    chmod +x /etc/s6/lighttpd/* && \
    chmod +x /etc/s6/pfclient/* && \
    chmod +x /etc/s6/piaware/* && \
    chmod +x /start.sh && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

EXPOSE 8080 8754 30053

ENTRYPOINT ["/start.sh"]
