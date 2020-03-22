FROM node:boron
WORKDIR /usr/src/app
COPY package.json /usr/src/app
RUN npm install

FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install build-essential curl file git ruby-full locales --no-install-recommends -y && \
    rm -rf /var/lib/apt/lists/*

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN useradd -m -s /bin/bash linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers

USER linuxbrew
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

USER root
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

RUN brew tap mongodb/brew
RUN brew install mongodb-community@4.2

COPY . /usr/src/app
EXPOSE 3000
CMD ["node", "app.js"]