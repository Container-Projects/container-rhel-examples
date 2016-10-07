FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

RUN set -x \
    && yum clean all \
    && yum-config-manager --disable \* \
    && yum-config-manager --enable rhel-7-server-rpms \
    && yum -y install --setopt=tsflags=nodocs deltarpm \
    && yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical --setopt=tsflags=nodocs \
    # install non-epel packages before adding EPEL repo to ensure supported bits used as much as possible
    && yum -y install --setopt=tsflags=nodocs iputils \
    && curl -o epel-release-latest-7.noarch.rpm -SL https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm --retry 999 --retry-max-time 0 -C - \
    && rpm -ivh epel-release-latest-7.noarch.rpm \
    && rm epel-release-latest-7.noarch.rpm \
    && yum -y install --setopt=tsflags=nodocs jq \
    && yum clean all
