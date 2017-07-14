FROM registry.access.redhat.com/rhel7/rhel
MAINTAINER Antonio Ojea <aojea@midokura.com>

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="midokura/midonet" \
      vendor="Midokura" \
      version="5.4" \
      release="1" \
      summary="Midolman is an SDN agent used to connect the VMs and Containers to teh Virtual Overlay Networks" \
      description="MidoNet is a network platform that can be used to build arbitrary network topologies on top \
of an existing IP network without having to modify it. Midolman (the MidoNet Agent) is the daemon that runs on \
all hosts where traffic enters and leaves MidoNet. It instructs the Open vSwitch kernel module on how to handle \
network traffic (what modifications to apply to packets and where to tunnel them to)."

ADD help.1 /help.1
ADD licenses /licenses
ADD midokura.repo /etc/yum.repos.d/midokura.repo
ADD midolman-run.sh /usr/bin/

RUN INSTALL_PKGS="which java-1.8.0-openjdk midolman" && \
    yum -y install --setopt=tsflags=nodocs ${INSTALL_PKGS} && \
    yum clean all && \
    systemctl enable midolman

CMD ["/usr/bin/midolman-run.sh"]
