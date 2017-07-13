FROM registry.access.redhat.com/rhel7/rhel
MAINTAINER Antonio Ojea <aojea@midokura.com>

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="midokura/midonet" \
      vendor="Midokura" \
      version="5.4" \
      release="1" \
      Summary="Midolman is an SDN agent used to connect the VMs and Containers to teh Virtual Overlay Networks"

ADD help.1 /help.1
ADD license /license
ADD midokura.repo /etc/yum.repos.d/midokura.repo
ADD midolman-run.sh /usr/bin/

RUN INSTALL_PKGS="which java-1.8.0-openjdk midolman" && \
    yum -y install --setopt=tsflags=nodocs ${INSTALL_PKGS} && \
    yum clean all && \
    systemctl enable midolman

CMD ["/usr/bin/midolman-run.sh"]
