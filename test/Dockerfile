FROM ubuntu:16.04

ENV BATS_VERSION v0.4.0
ARG WORKDIR=/opt/gochomugo/msu

WORKDIR ${WORKDIR}

RUN apt-get -y update && \
    apt-get -y install asciidoc cabal-install git make sudo wget && \
    cabal update --verbose=0 && \
    cabal install shellcheck

RUN mkdir deps && \
    git clone --depth=1 --branch=${BATS_VERSION} https://github.com/sstephenson/bats.git deps/bats

ADD . ${WORKDIR}/

CMD ["make", "test.bare"]
