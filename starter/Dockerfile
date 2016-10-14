### docker build --pull -t acme/starter -t acme/starter:v3.2 .
FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>
### uncomment "ENV container docker" if using systemd in container
# ENV container docker

### Atomic Labels
### The UNINSTALL label by DEFAULT will attempt to delete a container (rm) and image (rmi) if the container NAME is the same as the actual IMAGE
### NAME is set via -n flag to ALL atomic commands (install,run,stop,uninstall)
### https://github.com/projectatomic/ContainerApplicationGenericLabels
### https://github.com/projectatomic/ContainerApplicationGenericLabels/blob/master/vendor/redhat/labels.md
LABEL Name="acme/starter" \
      Vendor="Acme Corp" \
      Version="3.2" \
      Release="7" \
      build-date="2016-10-12T14:12:54.553894Z" \
      url="https://www.acme.io" \
      summary="Acme Corp's Starter App" \
      description="Starter App will do ....." \
      RUN='docker run -tdi --name ${NAME} \
      -p 443:443 \
      ${IMAGE}' \
      STOP='docker stop ${NAME}'

### OpenShift labels
LABEL io.k8s.description="Starter App will do ....." \
      io.k8s.display-name="Starter App" \
      io.openshift.expose-services="443:https" \
      io.openshift.tags="Acme,starter,starterapp"

### Atomic Help File
### Write in Markdown, it will be converted to man format at build time.
### https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc
COPY help.md /

RUN set -x \
    && yum clean all \
    && yum-config-manager --disable \* \
    && yum-config-manager --enable rhel-7-server-rpms \
    && yum-config-manager --enable rhel-7-server-optional-rpms \
### Add additional RedHat repos
#    && yum-config-manager --enable rhel-7-server-extras-rpms \
#    && yum-config-manager --enable rhel-server-rhscl-7-rpms \
#    && yum-config-manager --enable rhel-7-server-ose-3.3-rpms \
    && yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical --setopt=tsflags=nodocs \
### Add your package needs to this installation line... 
    && yum -y install --setopt=tsflags=nodocs golang-github-cpuguy83-go-md2man \
### EPEL packages can be installed if necessary but, install non-epel packages before
### adding the EPEL repo so that supported bits are used wherever possible.
#    && curl -o epel-release-latest-7.noarch.rpm -SL https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm --retry 999 --retry-max-time 0 -C - \
#    && rpm -ivh epel-release-latest-7.noarch.rpm && rm epel-release-latest-7.noarch.rpm \
#    && yum -y install --setopt=tsflags=nodocs jq \
#    && yum-config-manager --disable epel \
    && go-md2man -in help.md -out help.1 \
### leave go-md2man installed until after the help file conversion is complete.
    && yum -y remove golang-github-cpuguy83-go-md2man \
    && rm -f help.md \
    && yum clean all

ENV APP_ROOT=/opt/app-root \
    USER_NAME=default \
    USER_UID=1001
ENV HOME=${APP_ROOT}/src
ENV PATH=${HOME}/bin:${APP_ROOT}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
### Setup the user that is used for the build execution and for the
### application runtime execution by default.
RUN mkdir -p ${HOME}/bin ${APP_ROOT}/bin && \
    useradd -u ${USER_UID} -r -g 0 -d ${HOME} -s /sbin/nologin \
            -c "${USER_NAME} Application User" ${USER_NAME} && \
    chown -R ${USER_UID}:0 /opt/app-root

##### Add app-specific needs below. #####
COPY run.sh ${HOME}/bin/
RUN chmod ug+x ${HOME}/bin/run.sh \
    && chown ${USER_UID}:0 ${HOME}/bin/run.sh

### Red Hat compliant containers should NOT run as root
USER ${USER_UID}
WORKDIR ${HOME}

EXPOSE 443

CMD run.sh
