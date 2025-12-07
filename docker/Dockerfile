# Dockerfile - start from Ubuntu 24.04
FROM ubuntu:24.04


RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  build-essential \
  git \
  iputils-ping \
  apt-transport-https \
  wget \
  && rm -rf /var/lib/apt/lists/*
RUN echo "installing ondemand"
RUN wget -O /tmp/ondemand-release-web_4.0.0-noble_all.deb https://apt.osc.edu/ondemand/4.0/ondemand-release-web_4.0.0-noble_all.deb
RUN ls /tmp # debug
RUN apt install /tmp/ondemand-release-web_4.0.0-noble_all.deb -y
RUN apt update
RUN apt upgrade -y
RUN apt install ondemand -y

RUN echo "starting apache2" \
  && systemctl start apache2 \
  && systemctl enable apache2

# WORKDIR /workspace

# CMD ["/bin/bash"]