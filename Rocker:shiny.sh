FROM rocker/shiny-verse

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
   
ENV LD_LIBRARY_PATH=/usr/lib/jvm/jre/lib/amd64:/usr/lib/jvm/jre/lib/amd64/default

RUN R CMD javareconf

RUN R -e "install.packages('RCurl')"
RUN R -e "install.packages('learnr')"
RUN R -e "install.packages('RJDBC')"
RUN R -e "install.packages('pwr')"
RUN R -e "install.packages('shinyjqui')"
RUN R -e "install.packages('coin')"
RUN R -e "install.packages('FSA')"
RUN R -e "install.packages('rcompanion')"

RUN cd /srv/shiny-server/
RUN rm -rf /srv/shiny-server/*
RUN chown shiny:shiny /srv/shiny-server/

USER shiny

RUN mkdir ~/.ssh/
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN git clone git@github.com:braunsb/Lessons.git
RUN ln -s /srv/shiny-server/Lessons/* /srv/shiny-server
RUN git clone git@github.com:ianmcampbell/ModuleTable.git

RUN curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/Personalized-Learning-Plan
RUN curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/Lesson-Generator
RUN curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/list
RUN curl https://codeload.github.com/ianmcampbell/Arcus-Modular-Education-Support-System/tar.gz/master | tar -C /srv/shiny-server/ -xz --strip=1 Arcus-Modular-Education-Support-System-master/TableUpdater

RUN mkdir /srv/shiny-server/Personalized-Learning-Plan/curricula/

RUN curl https://codeload.github.com/ianmcampbell/Curricula/tar.gz/master | tar -C /srv/shiny-server/Personalized-Learning-Plan/curricula/ -xz --strip=1 Curricula-master/

EXPOSE 3838

CMD ["/usr/bin/shiny-server.sh"]

#FROM rocker/shiny-verse/a-mess
#EXPOSE 3838
#CMD ["/usr/bin/shiny-server.sh"]

#docker run -d -p 3839:3838

