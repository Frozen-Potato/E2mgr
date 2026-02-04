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
git clone https://github.com/o-ran-sc/ric-plt-lib-rmr.git
cd ric-plt-lib-rmr/mdclog
make && make install

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
