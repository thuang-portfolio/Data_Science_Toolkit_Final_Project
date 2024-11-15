# use ubuntu
FROM rocker/r-ubuntu 

# install updates
RUN apt-get update 
RUN apt-get install -y pandoc 
RUN apt-get install -y vim
RUN apt-get install -y libcurl4-openssl-dev 
RUN apt-get install -y libssl-dev 
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libfontconfig1-dev 
RUN apt-get install -y libharfbuzz-dev libfribidi-dev
RUN apt-get install -y libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev

# create folder called project
RUN mkdir /project
WORKDIR /project 

# create folder called renv and copy renv files
RUN mkdir -p renv
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R
COPY renv/settings.json renv/settings.json

# change default location of renv cache to be in project directory
RUN mkdir renv/.cache
ENV RENV_PATHS_CACHE renv/.cache

# restore package library
RUN Rscript -e "renv::restore(prompt = FALSE)"

# copy files to project directory
COPY Makefile /project/
COPY report.Rmd /project/
COPY README.md /project/

# create new folders in project directory
RUN mkdir code/
RUN mkdir outputs/
RUN mkdir cleaned_data/
RUN mkdir raw_data/
RUN mkdir report/

# copy data into raw_data
COPY raw_data/Bullying_2018.csv raw_data/
COPY cleaned_data/physical_attack_data.rds cleaned_data/

# copy code files into code folder
COPY code code

# add entry point for making the report
CMD make && mv report.html report

