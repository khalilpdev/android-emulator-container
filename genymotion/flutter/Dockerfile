FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    adb \
    curl \
    git \
    openjdk-21-jdk \
    unzip \
    wget \
    xz-utils \
  && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/flutter/flutter.git /opt/flutter

ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

WORKDIR /workspace

RUN flutter --version

CMD ["bash"]
