FROM ubuntu:16.04


RUN dpkg --add-architecture i386
RUN apt-get update \
    && apt-get install -y libc6:i386 libstdc++6:i386 libuuid1:i386 libxtst6:i386 libpulse0:i386 libglib2.0-0:i386 libx11-xcb1:i386 libxi6:i386 libexpat1:i386 libfontconfig1:i386 libfreetype6:i386 libpng12-0:i386 libsm6:i386 libxfixes3:i386 libxss1:i386 \
    && apt-get install -y xauth libxau6:i386 libxdmcp6:i386 libxcb1:i386 libx11-6:i386 libxext6:i386 libxmuu1:i386 \
    && apt-get install -y pulseaudio libpulse0:i386 \
    && echo

    #&& rm -rf /var/lib/apt/lists/*

########################################
# Install hpmyroom:
COPY hpmyroom_v10.4.0.0174_i386.deb /srv/hpmyroom.deb
RUN dpkg -i /srv/hpmyroom.deb

########################################
# Install Sky ("Skype for Business" for linux):
COPY sky_2.1.6428-1ubuntu+xenial_amd64.deb /srv/sky.deb
RUN apt-get install -y libavcodec-ffmpeg56 libavformat-ffmpeg56 libavutil-ffmpeg54 libcurl3 \
      libjpeg8 libqt5core5a libqt5gui5 libqt5network5 libqt5widgets5 libswscale-ffmpeg3 libv4l-0 \
      libxcursor1 libxinerama1 libxkbfile1 libxv1 libxss1
RUN dpkg -i /srv/sky.deb

########################################
# Config
RUN adduser --disabled-password --gecos "" user

COPY run-myroom.sh /home/user
RUN chmod 777 /home/user/run-myroom.sh

USER user
ENV HOME /home/user
ENV PULSE_COOKIE /home/user/pcookie
CMD /home/user/run-myroom.sh

