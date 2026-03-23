#!/bin/bash

while getopts ":k:r:" opt; do
  case $opt in
    k) key="$OPTARG"
    ;;
    r) repository="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

mkdir /root/.ssh/ && \
echo "${key}" > /root/.ssh/id_rsa && \
chmod 0600 /root/.ssh/id_rsa && \
eval "$(ssh-agent -s)" && \
ssh-add /root/.ssh/id_rsa && \
touch /root/.ssh/known_hosts && \
ssh-keyscan "${repository}" >> /root/.ssh/known_hosts && \
git config --global url."ssh://git@${repository}".insteadOf "https://${repository}" && \
git config --global gc.auto 0
