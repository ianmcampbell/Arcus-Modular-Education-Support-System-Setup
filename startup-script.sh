sudo yum -y install update
#sudo yum -y install svn
sudo yum -y install git
sudo yum -y install epel-release
sudo yum -y install R
sudo yum -y install wget
sudo yum -y install curl-devel
sudo R -e "install.packages(c('shiny', 'rmarkdown', 'devtools', 'RJDBC','learnr', 'dplyr', 'data.table','RCurl','htmlwidgets', 'pwr', 'rcompanion', 'FSA','shinyjqui'), dependencies = TRUE, repos='http://cran.rstudio.com/')"
wget https://download3.rstudio.org/centos6.3/x86_64/shiny-server-1.5.9.923-x86_64.rpm
sudo yum -y install --nogpgcheck shiny-server-1.5.9.923-x86_64.rpm
sudo systemctl start shiny-server
sudo systemctl enable shiny-server
sudo firewall-cmd --permanent --zone=public --add-port=3838/tcp
sudo firewall-cmd --reload
cd /srv/shiny-server/
#sudo svn checkout https://github.research.chop.edu/braunsb/Arcus-Education-Learning-Plans-and-Modules/tree/master/Personalized-Learning-Plan
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -xz --strip=1 Arcus-Modular-Education-Support-System-master/Personalized-Learning-Plan

#sudo svn checkout https://github.research.chop.edu/braunsb/Arcus-Education-Learning-Plans-and-Modules/tree/master/Lesson-Generator
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -xz --strip=1 Arcus-Modular-Education-Support-System-master/Lesson-Generator

sudo svn checkout https://github.research.chop.edu/braunsb/Arcus-Education-Learning-Plans-and-Modules/tree/master/Lessons
cd Lessons
for file in *.R* ; do { sudo mv "$file" "$file".tmp ; sudo mkdir /srv/shiny-server/"${file%%.*}" ; sudo mv "$file".tmp /srv/shiny-server/"${file%%.*}"/"$file"; } ; done
ln -s /srv/shiny-server/Personalized-Learning-Plan/CurriculaTable.txt /srv/shiny-server/Lesson-Generator/
ln -s /srv/shiny-server/Personalized-Learning-Plan/ModuleTable.txt /srv/shiny-server/Lesson-Generator/
sudo chown -R shiny:shiny /srv/shiny-server/

