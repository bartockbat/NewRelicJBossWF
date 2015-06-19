# NewRelic and Wildfly Docker Container

**NOTE - this Docker container requires two things:**

1. An ISV / partner account with Red Hat as you need to run the container on a RHEL7 host
2. An account / license key from Newrelic - https://newrelic.com/signup

After getting the above, then proceed with the below

1. Install a RHEL7 host
2. Install Docker on that host
3. Do a git clone on the Docker container - `https://github.com/bartockbat/NewRelicJBossWF.git`
4. Build the container - `docker build -t wildfly/rhel7_newrelic .`
5. Once the container is built, you will need to run it and pass in some parameters:

`docker run -d -p 8080:8080 -p 9990:9990 -e JAVA_OPTS="-javaagent:/opt/jboss/wildfly/newrelic/newrelic.jar -Dnewrelic.config.license_key=xxxxxxxxxxxx -Dnewrelic.config.app_name=RunicRelic" rhel7/wildfly /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0`

6. The parameter -Dnewrelic.config.license_key=xxxxxxxxxxxx - this will be the license key string that you get from Newrelic's web site / your account.
7. The parameter  -Dnewrelic.config.app_name=RunicRelic - I chose RunicRelic - however, you can name this application a name of your choice - it is the one that will show up on Newrelic's web page in your account/monitoring space 
