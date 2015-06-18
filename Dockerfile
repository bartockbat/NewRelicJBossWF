FROM registry.access.redhat.com/rhel7.1:latest
MAINTAINER Glen M <gmillard@redhat.com>

# Execute system update
RUN yum -y update && yum clean all

RUN yum -y install java-1.8.0-openjdk.x86_64
RUN yum -y install unzip curl tar && yum clean all

# Create a user and group used to launch processes
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
# so there is a high chance that this ID will be equal to the current user
# making it easier to use volumes (no permission issues)
RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss

# Set the working directory to jboss' user home directory
WORKDIR /opt/jboss

# Specify the user which should be used to execute all commands below
USER jboss

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 8.2.0.Final

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME && curl http://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz | tar zx && mv $HOME/wildfly-$WILDFLY_VERSION $HOME/wildfly

# Set the JBOSS_HOME env variable
ENV JBOSS_HOME /opt/jboss/wildfly

# Expose the ports we're interested in
EXPOSE 8080 9990

# install new relic java agent
#USER root
USER jboss
ADD newrelic-java-3.17.0.zip /
RUN ["unzip", "/newrelic-java-3.17.0.zip", "-d", "/opt/jboss/wildfly/"]
#RUN cp -p /opt/newrelic/newrelic.yml /opt/newrelic/newrelic.yml.original

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
USER jboss
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
