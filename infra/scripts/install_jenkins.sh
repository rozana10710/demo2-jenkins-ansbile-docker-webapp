#!/bin/bash
set -e

# Change hostname to MASTER
hostnamectl set-hostname MASTER
echo "MASTER" >> /etc/hosts

# Update packages
apt-get update -y

# Install dependencies (Java 17)
apt-get install -y openjdk-17-jdk wget gnupg git curl

# Ensure Java 17 is default
update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-17-openjdk-amd64/bin/java 1
update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java

# Add Jenkins repository and key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
    | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
    > /etc/apt/sources.list.d/jenkins.list

# Install Jenkins
apt-get update -y
apt-get install -y jenkins

# Force Jenkins to use Java 17
sed -i -E "s|#?JAVA_HOME=.*|JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64|" /etc/default/jenkins

# Create Jenkins init script for admin user
mkdir -p /var/lib/jenkins/init.groovy.d
cat <<EOF > /var/lib/jenkins/init.groovy.d/basic-security.groovy
import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin123")
instance.setSecurityRealm(hudsonRealm)
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()
EOF

# Set correct permissions
chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d

# Enable and start Jenkins
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# Wait until Jenkins is ready
echo "Waiting for Jenkins to be ready..."
until curl -s http://localhost:8080/login > /dev/null; do
    sleep 10
done

# Wait a bit more for plugin manager readiness
sleep 20

# Install plugins
JENKINS_CLI_JAR=/var/cache/jenkins/war/WEB-INF/jenkins-cli.jar
JENKINS_URL=http://localhost:8080
ADMIN_USER=admin
ADMIN_PASS=admin123

install_plugin() {
    java -jar $JENKINS_CLI_JAR -s $JENKINS_URL -auth $ADMIN_USER:$ADMIN_PASS install-plugin "$1" -deploy
}

install_plugin git
install_plugin workflow-aggregator
install_plugin blueocean
install_plugin ssh-agent
install_plugin pipeline-stage-view

# Restart Jenkins after plugin installation
java -jar $JENKINS_CLI_JAR -s $JENKINS_URL -auth $ADMIN_USER:$ADMIN_PASS safe-restart
