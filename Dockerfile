FROM adoptopenjdk:11-jdk-hotspot-bionic

ARG EMSDK_VERSION=2.0.1

RUN set -ex;                                                \
  # build libs
  apt-get update;                                           \
  apt-get install --no-install-recommends -y                \
    build-essential                                         \
    ca-certificates                                         \
    cmake                                                   \
    git-core                                                \
    python3                                                 \
    wget                                                    \
    xz-utils                                                \
  ;                                                         \
  # emsdk
  git clone https://github.com/juj/emsdk.git;               \
  cd /emsdk;                                                \
  ./emsdk update-tags;                                      \
  ./emsdk install sdk-${EMSDK_VERSION}-64bit;               \
  # clean
  rm -rf ./zips ./emscripten/*/tests /var/lib/apt/lists/*;  \
  find . -name '*.[ao]' -exec rm {} +;

WORKDIR /emsdk
RUN ./emsdk activate sdk-${EMSDK_VERSION}-64bit

COPY docker-entrypoint.sh .
ENTRYPOINT [ "./docker-entrypoint.sh" ]
