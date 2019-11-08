# Allow ssh from port 4000
sudo apt update
sudo apt --assume-yes install firewalld
systemctl start firewalld.service
firewall-cmd --permanent --zone=public --add-port 4000/tcp
firewall-cmd --reload
echo \ 'Port 22' >> /etc/ssh/sshd_config
echo \ 'Port 4000' >> /etc/ssh/sshd_config
echo \ 'Port 22' >> /etc/ssh/sshd_config
systemctl restart sshd.service

# Install required CentOS packages
#sudo yum -y install git epel-release wget curl-devel openssl-devel libxml2-devel R
sudo apt --assume-yes install apt-transport-https software-properties-common
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'

sudo apt --assume-yes install r-base
sudo apt --assume-yes install libcurl4-openssl-dev
sudo apt --assume-yes install libssl-dev
sudo apt --assume-yes install libxml2-dev
sudo apt --assume-yes install default-jre
sudo apt --assume-yes install default-jdk
export LD_LIBRARY_PATH=/usr/lib/jvm/jre/lib/amd64:/usr/lib/jvm/jre/lib/amd64/default
sudo apt --assume-yes install libcairo2-dev
sudo apt --assume-yes install libmariadbclient-dev libmariadb-client-lgpl-dev
sudo apt --assume-yes install libpq-dev

# Install nginx for redirect
sudo apt --assume-yes install nginx
systemctl start nginx.service
sudo firewall-cmd --permanent --add-service=http
firewall-cmd --reload

# Download config file from Github
#cd /etc/nginx
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System-Setup/tar.gz/master | tar -C /etc/nginx/ -xz --strip=1 Arcus-Modular-Education-Support-System-Setup-master/nginx.conf
systemctl restart nginx.service

# Install required R packages
#sudo R -e "install.packages(c('shiny', 'rmarkdown', 'devtools', 'RJDBC','learnr', 'dplyr', 'data.table','RCurl','htmlwidgets', 'pwr', 'rcompanion', 'FSA','shinyjqui'), dependencies = TRUE, repos='http://cran.rstudio.com/')"
sudo R -e "install.packages(c('shiny', 'rmarkdown', 'devtools', 'RJDBC','learnr', 'dplyr', 'data.table','RCurl','htmlwidgets', 'pwr', 'rcompanion','shinyjqui'), dependencies = TRUE, repos='http://cran.rstudio.com/')"

#Download and install shiny-server
cd ~
sudo apt-get --assume-yes install gdebi-core
wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.12.933-amd64.deb
sudo gdebi --non-interactive shiny-server-1.5.12.933-amd64.deb
sudo systemctl start shiny-server
sudo systemctl enable shiny-server
sudo firewall-cmd --permanent --zone=public --add-port=3838/tcp
sudo firewall-cmd --reload

#Move to shiny server file location and remove default files
cd /srv/shiny-server/
rm -fr /srv/shiny-server/*

#Download the Personalized Lesson Plan app from Github
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/Personalized-Learning-Plan

#Download Lesson Generator from Github
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/Lesson-Generator

#Download List Inedex App from Github
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/list

#Download all Lessons and ModuleTable from Github
curl https://codeload.github.com/braunsb/Lessons/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Lessons-master/

#Download the Curricula and Module Tables from Github
#curl https://codeload.github.com/braunsb/Lessons/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Lessons-master/ModuleTable.csv
curl https://codeload.github.com/ianmcampbell/Curricula/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Curricula-master/CurriculaTable.csv

#Download the Curricula from Github
curl https://codeload.github.com/ianmcampbell/Curricula/tar.gz/master | tar -C /srv/shiny-server/Personalized-Learning-Plan/curricula/ -xz --strip=1 Curricula-master/

#Synlink the tables into the apps
ln -s /srv/shiny-server/CurriculaTable.csv /srv/shiny-server/Personalized-Learning-Plan/CurriculaTable.csv
ln -s /srv/shiny-server/ModuleTable.csv /srv/shiny-server/Personalized-Learning-Plan/ModuleTable.csv
ln -s /srv/shiny-server/CurriculaTable.csv /srv/shiny-server/Lesson-Generator/CurriculaTable.csv
ln -s /srv/shiny-server/ModuleTable.csv  /srv/shiny-server/Lesson-Generator/ModuleTable.csv
ln -s /srv/shiny-server/CurriculaTable.csv /srv/shiny-server/list/CurriculaTable.csv
ln -s /srv/shiny-server/ModuleTable.csv  /srv/shiny-server/list/ModuleTable.csv

#Finalize file permissions
sudo chown -R shiny:shiny /srv/shiny-server/

