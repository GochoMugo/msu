FROM ubuntu:16.04

ARG WORKDIR=/opt/gochomugo/msu

WORKDIR ${WORKDIR}
VOLUME ${WORKDIR}/dist/

RUN apt-get -y update && \
    apt-get -y install asciidoc cabal-install git make sudo wget

RUN cabal update --verbose=0 && \
    cabal install shellcheck

ENV BATS_VERSION v0.4.0
RUN mkdir ${WORKDIR}/deps && \
    git clone --depth=1 --branch=${BATS_VERSION} https://github.com/sstephenson/bats.git ${WORKDIR}/deps/bats

ADD . ${WORKDIR}/

CMD ["make", "test.bare"]
