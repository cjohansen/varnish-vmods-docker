FROM debian:stretch-slim

RUN apt-get update
RUN apt install -y autotools-dev
RUN apt install -y automake
RUN apt install -y libtool
RUN apt install -y autoconf
RUN apt install -y libncurses-dev
RUN apt install -y xsltproc
RUN apt install -y groff-base
RUN apt install -y libpcre3-dev
RUN apt install -y pkg-config
RUN apt install -y python3-docutils
RUN apt install -y python3-sphinx
RUN apt install -y libreadline-dev
RUN apt install -y build-essential
RUN apt install -y wget
RUN apt install -y git

WORKDIR /tmp
RUN wget -O /tmp/varnish-6.2.0.tgz https://varnish-cache.org/_downloads/varnish-6.2.0.tgz
RUN tar xvzf varnish-6.2.0.tgz
WORKDIR /tmp/varnish-6.2.0
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

WORKDIR /tmp
RUN git clone https://github.com/varnish/varnish-modules.git
WORKDIR /tmp/varnish-modules
RUN git checkout 6.2
RUN ./bootstrap
RUN ./configure
RUN make
RUN make install

FROM varnish:6.2.0-1

COPY --from=0 /usr/local/lib/libvarnishapi.so.2.0.0 /usr/lib/x86_64-linux-gnu/libvarnishapi.so
COPY --from=0 /usr/local/lib/varnish/vmods /usr/local/lib/varnish/vmods
COPY LICENSE /LICENSE
