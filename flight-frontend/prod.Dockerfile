########## COMPILACION ANGULAR ##########
FROM node:18.20.3 as angular
LABEL author="David Guerra"

# set working directory
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

# add .bin to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install package.json (o sea las dependencies)
COPY package.json /usr/src/app/package.json
COPY package-lock.json /usr/src/app/package-lock.json
RUN npm install
RUN npm install -g @angular/cli

# add app
COPY . /usr/src/app
RUN ng build

########## SERVIDOR DE APLICACIONES ##########

FROM httpd:2.4

COPY --from=angular /usr/src/app/dist/flight-frontend/ /usr/local/apache2/htdocs/
COPY ./.htaccess /usr/local/apache2/htdocs/
COPY ./httpd.config /usr/local/apache2/conf/httpd.conf
