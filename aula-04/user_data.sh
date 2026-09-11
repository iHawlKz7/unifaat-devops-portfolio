#!/bin/bash

set -eux

exec > >(tee /var/log/technova-user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

dnf update -y
dnf install -y git

curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
dnf install -y nodejs

rm -rf /opt/technova-src

git clone \
  --branch "${repository_branch}" \
  --single-branch \
  "${repository_url}" \
  /opt/technova-src

cd /opt/technova-src/aula-04/technova-api

npm install

nohup npm start > /var/log/technova-api.log 2>&1 &
