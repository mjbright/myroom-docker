FROM ubuntu:16.04


RUN dpkg --add-architecture i386
RUN apt-get update \
    && apt-get install -y libc6:i386 libstdc++6:i386 libuuid1:i386 libxtst6:i386 libpulse0:i386 libglib2.0-0:i386 libx11-xcb1:i386 libxi6:i386 libexpat1:i386 libfontconfig1:i386 libfreetype6:i386 libpng12-0:i386 libsm6:i386 libxfixes3:i386 libxss1:i386 \
    && apt-get install -y xauth libxau6:i386 libxdmcp6:i386 libxcb1:i386 libx11-6:i386 libxext6:i386 libxmuu1:i386 \
    && apt-get install -y pulseaudio libpulse0:i386 \
    && rm -rf /var/lib/apt/lists/*

COPY hpmyroom_v10.4.0.0174_i386.deb /srv
RUN dpkg -i /srv/hpmyroom_v10.4.0.0174_i386.deb

RUN adduser --disabled-password --gecos "" user

COPY run-myroom.sh /home/user
RUN chmod 777 /home/user/run-myroom.sh

USER user
ENV HOME /home/user
ENV PULSE_COOKIE /home/user/pcookie
CMD /home/user/run-myroom.sh
