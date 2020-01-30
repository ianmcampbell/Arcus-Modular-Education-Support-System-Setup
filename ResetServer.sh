sudo rm -r /srv/shiny-server/*
sudo su shiny
git clone git@github.com:arcus/ALEx-Lessons.git /srv/shiny-server/Lessons/
ln -s /srv/shiny-server/Lessons/* /srv/shiny-server
git clone git@github.com:ianmcampbell/ModuleTable.git /srv/shiny-server/ModuleTable/
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/Personalized-Learning-Plan
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/Lesson-Generator
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/list
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/TableUpdater
curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/PackageManagement
curl https://codeload.github.com/ianmcampbell/Curricula/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Curricula-master/CurriculaTable.csv
mkdir /srv/shiny-server/Personalized-Learning-Plan/curricula/
curl https://codeload.github.com/ianmcampbell/Curricula/tar.gz/master | tar -C /srv/shiny-server/Personalized-Learning-Plan/curricula/ -xz --strip=1 Curricula-master/
ln -s /srv/shiny-server/CurriculaTable.csv /srv/shiny-server/Personalized-Learning-Plan/CurriculaTable.csv
ln -s /srv/shiny-server/CurriculaTable.csv /srv/shiny-server/Lesson-Generator/CurriculaTable.csv
ln -s /srv/shiny-server/CurriculaTable.csv /srv/shiny-server/list/CurriculaTable.csv
ln -s /srv/shiny-server/ModuleTable/ModuleTable.csv /srv/shiny-server/Personalized-Learning-Plan/ModuleTable.csv
ln -s /srv/shiny-server/ModuleTable/ModuleTable.csv /srv/shiny-server/Lesson-Generator/ModuleTable.csv
ln -s /srv/shiny-server/ModuleTable/ModuleTable.csv /srv/shiny-server/list/ModuleTable.csv
