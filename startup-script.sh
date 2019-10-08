# Allow ssh from port 4000
sudo yum install update
sudo yum -y install firewalld
systemctl start firewalld.service
firewall-cmd --permanent --zone=public --add-port 4000/tcp
firewall-cmd --reload
echo \ 'Port 22' >> /etc/ssh/sshd_config
echo \ 'Port 4000' >> /etc/ssh/sshd_config
echo \ 'Port 22' >> /etc/ssh/sshd_config
semanage port -a -t ssh_port_t -p tcp 4000
systemctl restart sshd.service

# Install required CentOS packages
#sudo yum -y install git epel-release wget curl-devel openssl-devel libxml2-devel R
sudo yum -y install git
sudo yum -y install epel-release
sudo yum -y install R
sudo yum -y install wget
sudo yum -y install curl-devel
sudo yum -y install openssl-devel
sudo yum -y install libxml2-devel

# Install nginx for redirect
sudo yum -y install nginx
systemctl start nginx.service
sudo firewall-cmd --permanent --add-service=http
firewall-cmd --reload

# Allow nginx network access for redirect
setsebool -P httpd_can_network_connect 1

# Download config file from Github
cd /etc/nginx
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System-Setup/tar.gz/master | tar -xz --strip=1 Arcus-Modular-Education-Support-System-Setup-master/nginx.conf

# Install required R packages
sudo R -e "install.packages(c('shiny', 'rmarkdown', 'devtools', 'RJDBC','learnr', 'dplyr', 'data.table','RCurl','htmlwidgets', 'pwr', 'rcompanion', 'FSA','shinyjqui'), dependencies = TRUE, repos='http://cran.rstudio.com/')"

#Download and install shiny-server
cd ~
wget https://download3.rstudio.org/centos6.3/x86_64/shiny-server-1.5.9.923-x86_64.rpm
sudo yum -y install --nogpgcheck shiny-server-1.5.9.923-x86_64.rpm
sudo systemctl start shiny-server
sudo systemctl enable shiny-server
sudo firewall-cmd --permanent --zone=public --add-port=3838/tcp
sudo firewall-cmd --reload

#Move to shiny server file location and remove default files
cd /srv/shiny-server/
rm -fr /srv/shiny-server/*

#Download the Personalized Lesson Plan app from Github
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -xz --strip=1 Arcus-Modular-Education-Support-System-master/Personalized-Learning-Plan

#Download Lesson Generator from Github
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -xz --strip=1 Arcus-Modular-Education-Support-System-master/Lesson-Generator

#Download all Lessons from Github
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System-Lessons/tar.gz/master | tar -xz --strip=2 Arcus-Modular-Education-Support-System-Lessons-master/Lessons

#Download the Curricula and Module Tables from Github
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System-Lessons/tar.gz/master | tar -xz --strip=1 Arcus-Modular-Education-Support-System-Lessons-master/ModuleTable.csv
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System-Lessons/tar.gz/master | tar -xz --strip=1 Arcus-Modular-Education-Support-System-Lessons-master/CurriculaTable.csv

#Synlink the tables into the apps
cd /srv/shiny-server/Personalized-Learning-Plan/
ln -s /srv/shiny-server/CurriculaTable.csv
ln -s /srv/shiny-server/ModuleTable.csv
cd /srv/shiny-server/Lesson-Generator/
ln -s /srv/shiny-server/CurriculaTable.csv
ln -s /srv/shiny-server/ModuleTable.csv

#Finalize file permissions
sudo chown -R shiny:shiny /srv/shiny-server/

