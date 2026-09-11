#!/bin/bash

set -eux

exec > >(tee /var/log/technova-user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

dnf install -y git wget tar xz

NODE_VERSION="v18.20.8"

cd /tmp

wget -q "https://nodejs.org/dist/$${NODE_VERSION}/node-$${NODE_VERSION}-linux-x64.tar.xz"

mkdir -p /usr/local/lib/nodejs

tar -xJf "node-$${NODE_VERSION}-linux-x64.tar.xz" \
  -C /usr/local/lib/nodejs

ln -sf "/usr/local/lib/nodejs/node-$${NODE_VERSION}-linux-x64/bin/node" /usr/local/bin/node
ln -sf "/usr/local/lib/nodejs/node-$${NODE_VERSION}-linux-x64/bin/npm" /usr/local/bin/npm
ln -sf "/usr/local/lib/nodejs/node-$${NODE_VERSION}-linux-x64/bin/npx" /usr/local/bin/npx

node --version
npm --version
git --version

rm -rf /opt/technova-src

git clone \
  --branch "${repository_branch}" \
  --single-branch \
  "${repository_url}" \
  /opt/technova-src

cd /opt/technova-src/aula-04/technova-api

npm install

nohup npm start > /var/log/technova-api.log 2>&1 &

sleep 5

curl http://localhost:3000
