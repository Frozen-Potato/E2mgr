FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# =========================
# Base tools
# =========================
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    git \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

# =========================
# Protobuf + gRPC (APT)
# =========================
RUN apt-get update && apt-get install -y \
    protobuf-compiler \
    libprotobuf-dev \
    libgrpc-dev \
    libgrpc++-dev \
    grpc-proto \
    && rm -rf /var/lib/apt/lists/*

# =========================
# nats.c (APT)
# =========================
RUN apt-get update && apt-get install -y \
    libnats-dev \
    && rm -rf /var/lib/apt/lists/*

# =========================
# mdclog
# =========================
RUN apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    automake \
    libtool \
    autoconf-archive \
    pkg-config \
    gawk \
    libjsoncpp-dev \
    git \
    && rm -rf /var/lib/apt/lists/*


RUN git clone https://github.com/o-ran-sc/com-log.git \
    && cd com-log \
    && ./autogen.sh \
    && ./configure --prefix=/usr \
    && make -j$(nproc) \
    && make install \
    && ldconfig \
    && cd / && rm -rf com-log

# =========================
# HARD SAFETY: ensure protoc is from /usr/bin
# =========================
RUN which protoc && \
    protoc --version && \
    ls -l /usr/bin/protoc && \
    ! test -e /usr/local/bin/protoc

# =========================
# Optional: force PATH order
# =========================
ENV PATH=/usr/bin:$PATH

WORKDIR /workspace
