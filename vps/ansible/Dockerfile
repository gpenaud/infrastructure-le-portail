FROM ubuntu:latest

RUN apt-get update && apt-get install -y ansible sshpass \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data/ansible-vm

WORKDIR /data/ansible-vm