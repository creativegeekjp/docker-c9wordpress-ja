Cloud9 v3 Dockerfile
=============

This repository contains Dockerfile of Cloud9 IDE for Docker's automated build published to the public Docker Hub Registry.

# Installation

## Install Docker.

Download automated build from public Docker Hub Registry: docker pull creativegeekjp/docker-c9wordpress-ja

(alternatively, you can build an image from Dockerfile: docker build -t="creativegeekjp/docker-c9wordpress-ja" github.com/creativegeekjp/docker-c9wordpress-ja)

## Usage

    docker run -it -d -p 80:80 creativegeekjp/docker-c9wordpress-ja
    
You can add a workspace as a volume directory with the argument *-v /your-path/workspace/:/workspace/* like this :

    docker run -it -d -p 80:80 -v /your-path/workspace/:/workspace/ creativegeekjp/docker-c9wordpress-ja
    
## Build and run with custom config directory

Get the latest version from github

    git clone https://github.com/creativegeekjp/docker-c9wordpress-ja
    cd cloud9-docker/

Build it

    sudo docker build --force-rm=true --tag="$USER/cloud9-docker:latest" .
    
And run

    sudo docker run -d -p 80:80 -v /your-path/workspace/:/workspace/ $USER/cloud9-docker:latest
    
Enjoy !!    
