FROM registry.access.redhat.com/rhel7

LABEL name="JenkinsCIDocker" \
      vendor="No Vendor" \
      version="2.32.2" \
      release="rhel" \
      summary="" \
      description="....." \
### Required labels above - recommended below
      url="" \
      run='docker run -tdi --name ${NAME} ${IMAGE}' \
      io.k8s.description="" \
      io.k8s.display-name="" \
      io.openshift.expose-services="" \
      io.openshift.tags=""


COPY help.1 /
RUN mkdir -p /licenses
COPY licenses /licenses

#Adding EPEL Repo for software - pure-ftpd
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

#Add necessary RHEL repos JRE and Jenkins
RUN yum repolist --disablerepo=* && \
    yum-config-manager --disable \* > /dev/null && \
yum-config-manager --enable rhel-7-server-rpms > /dev/null && \
yum-config-manager --enable rhel-7-server-extras-rpms > /dev/null && \
yum-config-manager --enable rhel-7-server-ose-3.5-rpms > /dev/null && \
yum -y install docker && yum -y install jre && yum -y install jenkins && yum -y install git && yum install -y atomic-openshift-clients-3.5.5.31-1.git.0.b6f55a2.el7.x86_64

### Add necessary Red Hat repos here
#RUN REPOLIST=rhel-7-server-rpms,rhel-7-server-optional-rpms,rhel-7-server-ose-3.2-rpms && \
### Add your package needs here
RUN   yum -y update-minimal --setopt=tsflags=nodocs \
--security --sec-severity=Important --sec-severity=Critical && \ 
yum clean all

#Set up for no security
#RUN rm /root/.jenkins/config.xml
#COPY config.xml /root/.jenkins/config.xml
 
EXPOSE 8080

ENTRYPOINT ["/usr/bin/java","-jar","/usr/lib/jenkins/jenkins.war"]
