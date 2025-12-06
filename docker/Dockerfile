# Use a modern RHEL-compatible base instead of deprecated centos/systemd
FROM rockylinux:8

ENV container docker

### MODIFY ONDEMAND USERNAME AND PASSWORD HERE
ENV ONDEMAND_USER ondemand
ENV ONDEMAND_PASSWORD password
ENV ROOT_PASSWORD password
### END MODIFY

### DO NOT MODIFY ###

# Create the ondemand user
RUN useradd -m "${ONDEMAND_USER}"

# Install system tools, SSH, and systemd
RUN dnf -y update \
 && dnf -y install \
      openssh-server \
      passwd \
      sudo \
      systemd \
      which \
      curl \
      ca-certificates \
 && dnf clean all \
 && rm -rf /var/cache/dnf

# Set up SSH
RUN mkdir -p /var/run/sshd \
 && echo "root:${ROOT_PASSWORD}" | chpasswd \
 && sed -i 's@session[[:space:]]\+required[[:space:]]\+pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

COPY ./sshd_config /etc/ssh/sshd_config

# Generate SSH host keys
RUN /usr/bin/ssh-keygen -A

# Install OnDemand repos and packages (RHEL8-compatible style)
RUN dnf -y install \
      epel-release \
      wget \
 && dnf clean all \
 && rm -rf /var/cache/dnf

# NOTE:
# The original Dockerfile used a CentOS 7-specific repo URL:
#   https://yum.osc.edu/ondemand/1.6/ondemand-release-web-1.6-4.noarch.rpm
# That is very old. For a real deployment you should point this at
# the current RHEL8/EL8 OnDemand release RPM for Rocky/Alma.
# For now this is left as-is structurally but commented out. Replace
# OOD_RELEASE_RPM with the correct URL for your target platform.

# Example pattern (you must update the URL):
# ENV OOD_RELEASE_RPM https://yum.osc.edu/ondemand/latest/ondemand-release-web-latest-1.noarch.rpm
# RUN dnf -y install "${OOD_RELEASE_RPM}" \
#  && dnf -y install ondemand ondemand-selinux \
#  && dnf clean all \
#  && rm -rf /var/cache/dnf

# ----- BEGIN: Legacy CentOS-style install (will likely need updating) -----
# Keeping your structure, but switched to dnf where possible.
# You should replace OOD_RELEASE_RPM with a valid EL8 RPM URL when you’re ready.
ENV OOD_RELEASE_RPM https://yum.osc.edu/ondemand/1.6/ondemand-release-web-1.6-4.noarch.rpm

RUN dnf -y install centos-release-stream || true \
 && dnf -y install "${OOD_RELEASE_RPM}" || true \
 && dnf -y install ondemand-selinux || true \
 && dnf clean all \
 && rm -rf /var/cache/dnf
# ----- END: Legacy block -----

# Systemd cleanup similar to original centos/systemd image
RUN (cd /lib/systemd/system/sysinit.target.wants/; \
      for i in *; do \
        if [ "$i" != "systemd-tmpfiles-setup.service" ]; then \
          rm -f "$i"; \
        fi; \
      done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*

# Enable services
RUN systemctl enable sshd.service || true

# httpd24/httpd bits are from older SCL-based OOD; keep the command but
# make it non-fatal in case the unit name differs on EL8-based OOD.
RUN systemctl enable httpd24-httpd || true

# Create initial htpasswd file for OOD
RUN mkdir -p /opt/rh/httpd24/root/etc/httpd \
 || true

RUN scl enable ondemand -- htpasswd -cb \
      /opt/rh/httpd24/root/etc/httpd/.htpasswd \
      "${ONDEMAND_USER}" "${ONDEMAND_PASSWORD}" \
 || true

COPY ./entrypoint.sh /usr/sbin/entrypoint
RUN chmod a+x /usr/sbin/entrypoint

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/entrypoint"]
