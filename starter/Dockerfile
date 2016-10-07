FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

RUN set -x \
    && yum clean all \
    && yum-config-manager --disable \* \
    && yum-config-manager --enable rhel-7-server-rpms \
    && yum -y install --setopt=tsflags=nodocs deltarpm \
    && yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical --setopt=tsflags=nodocs \
    && yum -y install --setopt=tsflags=nodocs iputils \
    && yum clean all
