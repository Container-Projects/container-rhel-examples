FROM registry.access.redhat.com/rhel7/rhel
MAINTAINER Antonio Ojea <aojea@midokura.com>

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="midokura/midonet" \
      vendor="Midokura" \
      version="5.4" \
      release="1" \
      Summary="Midonet Cluster is Rest API application used to manage and configure the midonet SDN networks"

ADD help.1 /help.1
ADD license /license

# 8181 for plain and 8443 for SSL Rest API
EXPOSE 8181 8443

ADD midokura.repo /etc/yum.repos.d/midokura.repo
ADD midonet-cluster-run.sh /usr/bin/

RUN INSTALL_PKGS="which java-1.8.0-openjdk midonet-cluster" && \
    yum -y install --setopt=tsflags=nodocs ${INSTALL_PKGS} && \
    yum clean all && \
    systemctl enable midonet-cluster

CMD ["/usr/bin/midonet-cluster-run.sh"]
