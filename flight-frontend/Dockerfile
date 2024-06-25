# base image
FROM node:18.20.3
LABEL author="David Guerra"

# set working directory
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

# add .bin to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install package.json (o sea las dependencies)
COPY package-lock.json /usr/src/app/
COPY package.json /usr/src/app/
RUN npm install

RUN npm install -g @angular/cli

# add app
COPY . /usr/src/app

# start app
CMD ng serve --host 0.0.0.0 --poll=2000
