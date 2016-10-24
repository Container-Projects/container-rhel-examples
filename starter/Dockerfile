### docker build --pull -t acme/starter -t acme/starter:v3.2 .
FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

### Atomic Labels
### The UNINSTALL label by DEFAULT will attempt to delete a container (rm) and image (rmi) if the container NAME
### is the same as the actual IMAGE. NAME is set via -n flag to ALL atomic commands (install,run,stop,uninstall).
### https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL Name="acme/starter" \
      Vendor="Acme Corp" \
      Version="3.2" \
      Release="7" \
      build-date="2016-10-12T14:12:54.553894Z" \
      url="https://www.acme.io" \
      summary="Acme Corp's Starter App" \
      description="Starter App will do ....." \
      RUN='docker run -tdi --name ${NAME} \
      -p 8080:8080 \
      -p 8443:8443 \
      ${IMAGE}' \
      STOP='docker stop ${NAME}'

### OpenShift labels
LABEL io.k8s.description="Starter App will do ....." \
      io.k8s.display-name="Starter App" \
      io.openshift.expose-services="8080:8080,8443:8443" \
      io.openshift.tags="Acme,starter,starterapp"

### Atomic Help File
### Write in Markdown, it will be converted to man format at build time.
### https://github.com/projectatomic/container-best-practices/blob/master/creating/help.adoc
COPY help.md /

RUN yum clean all && \
    yum-config-manager --disable \* && \
    yum-config-manager --enable rhel-7-server-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
### Add additional Red Hat repos
#    yum-config-manager --enable rhel-7-server-extras-rpms && \
#    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
#    yum-config-manager --enable rhel-7-server-thirdparty-oracle-java-rpms && \
#    yum-config-manager --enable rhel-7-server-ose-3.3-rpms && \
    yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical --setopt=tsflags=nodocs && \
    yum -y install --setopt=tsflags=nodocs golang-github-cpuguy83-go-md2man && \
### Add your package needs to this installation line... 
    yum -y install --setopt=tsflags=nodocs httpd mod_ssl && \
### EPEL packages can be installed if necessary but, install non-epel packages before
### adding the EPEL repo so that supported bits are used wherever possible.
#    curl -o epel-release-latest-7.noarch.rpm -SL https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
#            --retry 999 --retry-max-time 0 -C - && \
#    rpm -ivh epel-release-latest-7.noarch.rpm && rm epel-release-latest-7.noarch.rpm && \
#    yum -y install --setopt=tsflags=nodocs jq && \
#    yum-config-manager --disable epel && \
    go-md2man -in help.md -out help.1 && \
### leave go-md2man installed until after the help file conversion is complete.
    yum -y remove golang-github-cpuguy83-go-md2man && \
    rm -f help.md && \
    yum clean all

### Setup the user that is used for the build execution and
### for the application runtime execution by default.
ENV APP_ROOT=/opt/app-root \
    USER_NAME=default \
    USER_UID=1000160001
ENV HOME=${APP_ROOT}/src \
    PATH=$PATH:${APP_ROOT}/bin
RUN mkdir -p ${HOME} ${APP_ROOT}/bin && \
    useradd -l -u ${USER_UID} -r -g 0 -d ${HOME} -s /sbin/nologin \
            -c "${USER_NAME} application user" ${USER_NAME} && \
    chown -R ${USER_UID}:0 /opt/app-root

####### Add app-specific needs below. #######
### if COPYing files that require permission mods, do so before leaving root USER
# COPY run.sh ${APP_ROOT}/bin/
# RUN chmod ug+x ${APP_ROOT}/bin/run.sh && \
#     chown ${USER_UID}:0 ${APP_ROOT}/bin/run.sh
RUN chown -R ${USER_UID}:0 /run/httpd /etc/httpd && \
    chgrp -R 0 /run/httpd && \
    chmod g+r /etc/pki/tls/certs/localhost.crt /etc/pki/tls/private/localhost.key && \
    chmod -R 770 /var/log/httpd /run/httpd

### Containers should NOT run as root as a best practice
USER ${USER_UID}
WORKDIR ${HOME}

RUN sed -i "s/80/8080/g" /etc/httpd/conf/httpd.conf && \
    sed -i "s/443/8443/g" /etc/httpd/conf.d/ssl.conf && \
    sed -i "s@\/var\/www\/html@${HOME}@g" /etc/httpd/conf/httpd.conf && \
    sed -i "s@\/var\/www\/html@${HOME}@g" /etc/httpd/conf.d/ssl.conf && \
    sed -i "s/#DocumentRoot/DocumentRoot/g" /etc/httpd/conf.d/ssl.conf && \
    sed -i "s@User apache@User ${USER_NAME}@g" /etc/httpd/conf/httpd.conf && \
    sed -i "s/Group apache/Group root/g" /etc/httpd/conf/httpd.conf && \
#    echo "Hello World!" > ${HOME}/index.html && \
    echo $'#!/bin/sh\n\
rm -f /run/httpd/httpd.pid\n\
exec httpd -DFOREGROUND' > ${APP_ROOT}/bin/run.sh && \
    chmod ug+x ${APP_ROOT}/bin/run.sh

EXPOSE 8080 8443
CMD run.sh