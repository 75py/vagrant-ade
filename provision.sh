#sudo yum -y update
sudo yum -y install wget vim

# Apache
sudo yum -y install httpd
sudo rm -rf /etc/httpd/conf.d
sudo cp -r /vagrant/conf.d /etc/httpd
sudo chkconfig httpd on
#sudo service iptables stop
#sudo chkconfig iptables off

# JDK
if [ ! -f /vagrant/jdk-8u51-linux-x64.rpm ]; then
  wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u51-b16/jdk-8u51-linux-x64.rpm" -P /vagrant
fi
sudo rpm -ivh /vagrant/jdk-8u51-linux-x64.rpm

# Tomcat
sudo useradd -s /sbin/nologin tomcat
if [ ! -f /vagrant/apache-tomcat-8.0.24.tar.gz ]; then
  wget http://ftp.meisei-u.ac.jp/mirror/apache/dist/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz -P /vagrant
fi
tar xvzf /vagrant/apache-tomcat-8.0.24.tar.gz -C /vagrant
sudo mv /vagrant/apache-tomcat-8.0.24 /usr/local
cd /usr/local
sudo chown -R tomcat:tomcat apache-tomcat-8.0.24
sudo ln -s apache-tomcat-8.0.24 tomcat

sudo cp /vagrant/init.d/tomcat /etc/init.d/
sudo chown -R tomcat:tomcat /etc/init.d/tomcat
sudo chmod 700 /etc/init.d/tomcat
sudo /sbin/chkconfig --add tomcat

# GitBucket
if [ ! -f /vagrant/gitbucket.war ]; then
  wget https://github.com/takezoe/gitbucket/releases/download/3.5/gitbucket.war -P /vagrant
fi
sudo cp /vagrant/gitbucket.war /usr/local/tomcat/webapps/
sudo chown -R tomcat:tomcat /usr/local/tomcat/webapps/gitbucket.war

# Jenkins
if [ ! -f /vagrant/jenkins.war ]; then
  wget http://mirrors.jenkins-ci.org/war/latest/jenkins.war -P /vagrant
fi
sudo cp /vagrant/jenkins.war /usr/local/tomcat/webapps/
sudo chown -R tomcat:tomcat /usr/local/tomcat/webapps/jenkins.war

# start
sudo service tomcat start
sudo service httpd start

