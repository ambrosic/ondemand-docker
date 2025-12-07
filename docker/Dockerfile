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
  systemd

RUN echo "installing ondemand"
RUN wget -O /tmp/ondemand-release-web_4.0.0-noble_all.deb https://apt.osc.edu/ondemand/4.0/ondemand-release-web_4.0.0-noble_all.deb
RUN apt install -y /tmp/ondemand-release-web_4.0.0-noble_all.deb
RUN rm /tmp/ondemand-release-web_4.0.0-noble_all.deb
RUN apt update
RUN apt upgrade -y
RUN apt install ondemand -y

#RUN apt clean && rm -rf /var/lib/apt/lists/*

#RUN echo "starting apache2" \
#  && systemctl enable apache2
#
#RUN find /usr/lib/systemd/system/sysinit.target.wants -name "systemd-tmpfiles-setup.service" -delete \
#  && find /usr/lib/systemd/system/local-fs.target.wants -name "systemd-remount-fs.service" -delete \
#  && find /usr/lib/systemd/system/multi-user.target.wants -name "getty.target" -delete \
#  && find /usr/lib/systemd/system/multi-user.target.wants -name "systemd-logind.service" -delete
#
#ENV container docker
#
#ENTRYPOINT ["/lib/systemd/systemd"]

# Start command is adapted from /usr/lib/systemd/system/apache2.service
#ENTRYPOINT ["/usr/sbin/apachectl", "start"]
RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY entrypoint.sh /
COPY ood_portal.yml /etc/ood/config/
COPY kubes.yml /etc/ood/config/clusters.d/
#RUN rm /etc/ood/config/ood_portal.sha256sum

# propagate the changes in ood_portal.yml to apache
# -f flag forces, even if /etc/ood/config/ood_portal.sha256sum doesn't match current config
RUN /opt/ood/ood-portal-generator/sbin/update_ood_portal -f

# EXPOSE is basically just documentation, doesn't have a direct effect
EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
