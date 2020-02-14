FROM rocker/shiny-verse

#Install linux software
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
   openjdk-8-jdk \
   liblzma-dev \
   libbz2-dev \
   libicu-dev \
   libssl-dev \
   ssh \
   curl \
   python \
   git \
   nano

#Prepare Java Path for rJava install for RJDBC
ENV LD_LIBRARY_PATH=/usr/lib/jvm/jre/lib/amd64:/usr/lib/jvm/jre/lib/amd64/default

#Prepair rJava install
RUN R CMD javareconf

#Install packages
RUN R -e "install.packages('RCurl')"
#RUN R -e "install.packages('learnr')"
RUN R -e "devtools::install_github('zoews/learnr')"
RUN R -e "install.packages('RJDBC')"
RUN R -e "install.packages('pwr')"
RUN R -e "install.packages('shinyjqui')"
RUN R -e "install.packages('coin')"
RUN R -e "install.packages('FSA')"
RUN R -e "install.packages('rcompanion')"

#Remove default example apps
RUN cd /srv/shiny-server/
RUN rm -rf /srv/shiny-server/*
RUN chown shiny:shiny /srv/shiny-server/

#Finish setup as shiny user
USER shiny

#Add github.com known hosts
RUN mkdir ~/.ssh/
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN git config --global user.email "a-mess-bot@a-mess.org"
RUN git config --global user.name "a-mess-bot"

#Import SSH private key
ADD --chown=shiny:shiny id_rsa /home/shiny/.ssh/id_rsa

#Set permissions
RUN chmod 700 /home/shiny/.ssh/id_rsa

#Clone Lesson and ModuleTable repos
RUN cd /srv/shiny-server/
RUN git clone git@github.com:arcus/ALEx-Lessons.git /srv/shiny-server/Lessons/
#Symbolically link apps into top level directory for service
RUN ln -s /srv/shiny-server/Lessons/* /srv/shiny-server
RUN git clone git@github.com:ianmcampbell/ModuleTable.git /srv/shiny-server/ModuleTable/

#Download other apps directly from repo
RUN curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/Personalized-Learning-Plan
RUN curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/Lesson-Generator
RUN curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/list
RUN curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/TableUpdater
RUN curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/PackageManagement
RUN curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/Catalog
RUN curl https://codeload.github.com/ianmcampbell/Curricula/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Curricula-master/CurriculaTable.csv

#Import curricula
RUN mkdir /srv/shiny-server/Personalized-Learning-Plan/curricula/
RUN curl https://codeload.github.com/ianmcampbell/Curricula/tar.gz/master | tar -C /srv/shiny-server/Personalized-Learning-Plan/curricula/ -xz --strip=1 Curricula-master/

#Set up Final Symlinks
RUN ln -s /srv/shiny-server/CurriculaTable.csv /srv/shiny-server/Personalized-Learning-Plan/CurriculaTable.csv
RUN ln -s /srv/shiny-server/CurriculaTable.csv /srv/shiny-server/Lesson-Generator/CurriculaTable.csv
RUN ln -s /srv/shiny-server/CurriculaTable.csv /srv/shiny-server/list/CurriculaTable.csv
RUN ln -s /srv/shiny-server/ModuleTable/ModuleTable.csv /srv/shiny-server/Personalized-Learning-Plan/ModuleTable.csv
RUN ln -s /srv/shiny-server/ModuleTable/ModuleTable.csv /srv/shiny-server/Lesson-Generator/ModuleTable.csv
RUN ln -s /srv/shiny-server/ModuleTable/ModuleTable.csv /srv/shiny-server/list/ModuleTable.csv

#Expose default shiny-server port
EXPOSE 3838

#Set entry for container as shiny-server binary
CMD ["/usr/bin/shiny-server.sh"]

#Use this command to run
#docker save <image> | bzip2 > rocker-verse-amess.tar.bz2
#bzip2 -d rocker-verse-amess.tar.gz
#docker load -i rocker-verse-amess.tar
#docker images
#docker run -d -p 3838:3838 <image>
