# docker build --pull -t acme/starter .
FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>
## uncomment "ENV container docker" if using systemd in container
# ENV container docker

## Atomic Labels
# The UNINSTALL label by DEFAULT will attempt to delete a container (rm) and image (rmi) if the container NAME is the same as the actual IMAGE
# NAME is set via -n flag to ALL atomic commands (install,run,stop,uninstall)
# https://github.com/projectatomic/ContainerApplicationGenericLabels
# https://github.com/projectatomic/ContainerApplicationGenericLabels/blob/master/vendor/redhat/labels.md
LABEL name="acme/starter" \
      vendor="Acme Corp" \
      version="3.2" \
      release="1.0" \
      build-date="2016-10-12" \
      url="https://www.acme.io" \
      architecture="x86_64" \
      distribution-scope="authoritative-source-only" \
      authoritative-source-url="registry.access.redhat.com" \
      summary="Acme Corp's Starter App" \
      description="Starter App will do ....." \
      RUN='docker run -di --name ${NAME} \
      -p 443:443 \
      $IMAGE' \
      STOP='docker stop ${NAME} && echo "Container ${NAME} has been stopped"'

## OpenShift labels
LABEL io.k8s.description="Starter App will do ....." \
      io.k8s.display-name="Starter App" \
      io.openshift.expose-services="443:https" \
      io.openshift.tags="Acme,starter,starterapp"

EXPOSE 443

RUN set -x \
    && yum clean all \
    && yum-config-manager --disable \* \
### Add additional RedHat repos to this line with another --enable parameter.
    && yum-config-manager --enable rhel-7-server-rpms \
#    && yum-config-manager --enable rhel-7-server-extras-rpms \
#    && yum-config-manager --enable rhel-7-server-optional-rpms \
#    && yum-config-manager --enable rhel-server-rhscl-7-rpms \
#    && yum-config-manager --enable rhel-7-server-ose-3.3-rpms \
### Add your package needs to this installation line... 
### leave tar, git, & deltarpm in place until after the help file conversion is complete.
    && yum -y install --setopt=tsflags=nodocs tar git deltarpm \
    && yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical --setopt=tsflags=nodocs \
### EPEL packages can be installed if necessary but, be sure to install non-epel packages before
### adding the EPEL repo to ensure that supported bits are used wherever possible.
#    && curl -o epel-release-latest-7.noarch.rpm -SL https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm --retry 999 --retry-max-time 0 -C - \
#    && rpm -ivh epel-release-latest-7.noarch.rpm && rm epel-release-latest-7.noarch.rpm \
#    && yum -y install --setopt=tsflags=nodocs jq \
#    && yum-config-manager --disable epel \
    && yum clean all

## Atomic Help File
# Write in Markdown, it will be converted to man at build time.
# https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc
COPY help.md /
ENV MD2MAN_VERSION=v1.0.6 \
    GO_VERSION=1.7.1 \
    GOPATH=$HOME/go \
    PATH=$PATH:/usr/local/go/bin
RUN mkdir ~/go \
    && curl -o go.linux-amd64.tar.gz -SL https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz --retry 999 --retry-max-time 0 -C - \
    && tar -C /usr/local -xzf go.linux-amd64.tar.gz \
    && go get -u github.com/cpuguy83/go-md2man \
    && cd $GOPATH/src/github.com/cpuguy83/go-md2man \
    && git checkout ${MD2MAN_VERSION} && go build \
    && ./go-md2man -in /help.md -out /help.1 \
    && rm -rf /go.linux-amd64.tar.gz /help.md ~/go /usr/local/go

##### Add app-specific needs below. #####
