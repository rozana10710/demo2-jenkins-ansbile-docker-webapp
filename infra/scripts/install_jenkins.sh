#!/bin/bash
set -euxo pipefail

# Optional hostname for clarity in demos
hostnamectl set-hostname MASTER || true
echo "MASTER" >> /etc/hosts || true

export DEBIAN_FRONTEND=noninteractive

retry() {
  local attempts=$1; shift
  local delay=$1; shift
  local n=0
  until "$@"; do
    n=$((n+1))
    if [ $n -ge $attempts ]; then
      echo "Command failed after ${attempts} attempts: $*" >&2
      return 1
    fi
    sleep "$delay"
  done
}

install_on_ubuntu() {
  retry 5 10 apt-get update -y
  retry 5 10 apt-get upgrade -y || true
  retry 5 10 apt-get install -y openjdk-17-jdk wget gnupg git curl ca-certificates lsb-release

  install -d -m 0755 /usr/share/keyrings
  curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
    | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
    > /etc/apt/sources.list.d/jenkins.list

  retry 5 10 apt-get update -y
  retry 5 10 apt-get install -y jenkins

  # Force Jenkins to use Java 17
  if [ -d /usr/lib/jvm/java-17-openjdk-amd64 ]; then
    sed -i -E "s|#?JAVA_HOME=.*|JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64|" /etc/default/jenkins || true
  fi
}

install_on_ubuntu

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
chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d || true

# Enable and start Jenkins
systemctl daemon-reload || true
systemctl enable jenkins || true
systemctl start jenkins || true

# Wait until Jenkins is ready
echo "Waiting for Jenkins to be ready..."
until curl -sS http://localhost:8080/login > /dev/null; do
  sleep 10
done

# Install essential plugins via CLI if available
JENKINS_CLI_JAR=/var/cache/jenkins/war/WEB-INF/jenkins-cli.jar
if [ -f "$JENKINS_CLI_JAR" ]; then
  JENKINS_URL=http://localhost:8080
  ADMIN_USER=admin
  ADMIN_PASS=admin123
  install_plugin() {
    java -jar "$JENKINS_CLI_JAR" -s "$JENKINS_URL" -auth "$ADMIN_USER:$ADMIN_PASS" install-plugin "$1" -deploy || true
  }
  install_plugin git
  install_plugin workflow-aggregator
  install_plugin blueocean
  install_plugin ssh-agent
  install_plugin pipeline-stage-view
  java -jar "$JENKINS_CLI_JAR" -s "$JENKINS_URL" -auth "$ADMIN_USER:$ADMIN_PASS" safe-restart || true
fi

# Diagnostics
(java -version || true) 2>&1 | tee /root/userdata-master-java.txt || true
(jenkins --version || true) 2>&1 | tee /root/userdata-master-jenkins.txt || true
