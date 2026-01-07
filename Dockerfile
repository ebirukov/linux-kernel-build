FROM ubuntu:24:04

RUN apt update &&
      apt install -y \
        build-essential \
        libncurses-dev \
        libssl-dev \
        libelf-dev \
        bc \
        flex \
        bison \
        dwarves
