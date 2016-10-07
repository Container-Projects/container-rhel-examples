# docker build --rm -t rhel7.2/java:jre8 .
FROM registry.access.redhat.com/rhel7
MAINTAINER Red Hat Systems Engineering <refarch-feedback@redhat.com>

# Default to UTF-8 file.encoding
ENV LANG en_US.utf8

# Install necessary packages
RUN yum -y update && yum -y install java-1.8.0-openjdk && yum clean all

# Set the JAVA_HOME variable to make it clear where Java is located
ENV JAVA_HOME /usr/lib/jvm/jre
