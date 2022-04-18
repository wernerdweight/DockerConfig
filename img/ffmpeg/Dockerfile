FROM alpine:3

LABEL image.maintainer="Werner Dweight Solutions <info@wds.blue>"
LABEL image.description="Custom-compiled ffmpeg image."
LABEL image.version="1.0"

ENV LD_LIBRARY_PATH=/opt/intel/mediasdk/lib64:/usr/local/lib64:/usr/local/lib:/usr/lib:/lib
ENV PKG_CONFIG_PATH=/opt/intel/mediasdk/lib64/pkgconfig:/usr/local/lib64/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:/lib/pkgconfig
ENV SRC=/usr/local
ENV PREFIX=/usr/local

ARG FFMPEG_VERSION

RUN set -e; \
  \
  # required packages
  apk update; \
  apk upgrade; \
  apk add --no-cache bash; \
  \
  # clean unnecessary tmp cache
  rm -rf /var/cache/apk/*;

# install stable dependencies
RUN apk add --no-cache --update-cache build-base curl nasm tar bzip2 zlib-dev openssl-dev yasm-dev lame-dev libogg-dev \
    libvpx-dev libvorbis-dev x265-dev freetype-dev libass-dev libwebp-dev rtmpdump-dev libtheora-dev opus-dev \
    libxml2-dev cmake chromaprint-dev frei0r-plugins-dev aom-dev libbluray-dev libsndfile-dev libcaca-dev libdav1d \
    dav1d-dev libdc1394-dev flite-dev gsm-dev lame-dev openjpeg-dev pulseaudio-dev snappy-dev soxr-dev speex-dev \
    wavpack-dev openal-soft-dev sdl2-dev mpg123-dev libssh-dev xvidcore-dev mesa-dev mesa-va-gallium \
    x264 x264-dev x264-libs mesa-vdpau-gallium;

# install testing anc community dependencies
RUN echo http://dl-2.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
RUN echo http://dl-2.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN apk add --no-cache --update-cache ladspa-dev libgme-dev rubberband-dev shine vidstab-dev zimg-dev openh264-dev;

# AviSynth+ https://github.com/AviSynth/AviSynthPlus
WORKDIR /tmp/AviSynthPlus
RUN \
	curl -fsSL https://github.com/AviSynth/AviSynthPlus/archive/v3.7.2.tar.gz | tar -xz --strip-components=1 && \
	mkdir avisynth-build && \
	cd avisynth-build && \
	cmake -DCMAKE_BUILD_TYPE=Release ../ -DHEADERS_ONLY:bool=on && \
	make -j $(nproc) VersionGen install;

# bs2b http://bs2b.sourceforge.net/
WORKDIR /tmp/bs2b
RUN \
	curl -fsSL https://downloads.sourceforge.net/project/bs2b/libbs2b/3.1.0/libbs2b-3.1.0.tar.gz | tar -xz --strip-components=1 && \
	cd ./build-aux && \
	curl -fsSL 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD' -o config.guess && \
	curl -fsSL 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD' -o config.sub && \
	cd ../ && \
	./configure --prefix="${PREFIX}" --enable-static --enable-shared && \
	make -j $(nproc) && \
	make -j $(nproc) install;

# opencore-amr https://sourceforge.net/projects/opencore-amr/
WORKDIR /tmp/opencore
RUN \
	curl -fsSL https://versaweb.dl.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.5.tar.gz | tar -zx --strip-components=1 && \
	./configure --prefix="${PREFIX}" --enable-shared  && \
	make -j $(nproc) && \
	make -j $(nproc) install;

# libsrt https://github.com/Haivision/srt
WORKDIR /tmp/srt
RUN \
	curl -fsSL https://github.com/Haivision/srt/archive/v1.4.4.tar.gz | tar -xz --strip-components=1 && \
	cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${PREFIX}" . && \
	make -j $(nproc) && \
	make -j $(nproc) install;

# TwoLAME https://www.twolame.org/
WORKDIR /tmp/twolame
RUN \
	curl -fsSL https://downloads.sourceforge.net/twolame/twolame-0.4.0.tar.gz | tar -xz --strip-components=1 && \
	./configure --prefix="${PREFIX}" --enable-static --enable-shared && \
	make -j $(nproc) && \
	make -j $(nproc) install;

# libopenmpt - libportaudio http://www.portaudio.com/
WORKDIR /tmp/libportaudio
RUN \
	curl -fsSL http://www.portaudio.com/archives/pa_snapshot.tgz | tar -xz --strip-components=1 && \
	./configure --prefix="${PREFIX}" --enable-static --enable-shared && \
	make -j $(nproc) && \
	make -j $(nproc) install && \
	cd ./bindings/cpp && \
	./configure --prefix="${PREFIX}" --enable-static --enable-shared && \
	make -j $(nproc) && \
	make -j $(nproc) install;

# libopenmpt - libopenmpt https://lib.openmpt.org/libopenmpt/
WORKDIR /tmp/libopenmpt
RUN \
	curl -fsSL https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.6.2+release.autotools.tar.gz | tar -xz --strip-components=1 && \
	./configure --prefix="${PREFIX}" --enable-static --enable-shared && \
	make -j $(nproc) && \
	make -j $(nproc) install;

# check available libraries
RUN pkg-config --list-all;

# compile ffmpeg
WORKDIR /tmp/ffmpeg
RUN DIR=$(mktemp -d) && cd ${DIR} && \
    \
    curl -s http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | tar zxvf - -C . && \
    cd ffmpeg-${FFMPEG_VERSION} && \
    \
    ./configure \
     --disable-stripping --enable-avisynth --enable-chromaprint --enable-fontconfig \
     --enable-frei0r --enable-gmp --enable-gpl --enable-gray --enable-ladspa --enable-libaom --enable-libass \
     --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libdav1d --enable-libdc1394 --enable-libflite \
     --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libgsm \
     --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg \
     --enable-libopenmpt --enable-libopus --enable-libpulse --enable-librtmp --enable-libshine \
     --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libsrt --enable-libssh --enable-libtheora \
     --enable-libtwolame --enable-libvidstab --enable-libvorbis --enable-libvpx --enable-libwebp \
     --enable-libx264 --enable-libx265 --enable-libxml2 --enable-libxvid --enable-nonfree \
     --enable-openal --enable-opengl --enable-openssl --enable-postproc --enable-sdl2 --enable-shared --enable-small \
     --enable-static --enable-version3 && \
    \
    make && \
    make install && \
    make distclean && \
    \
    rm -rf ${DIR} && \
    apk del build-base tar x264 && \
    rm -rf /var/cache/apk/*;
