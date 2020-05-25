#!/bin/bash
app="myflaskapp"
docker container rm -f ${app}
docker build -t ${app} .
docker run -d -p 8010:80 \
  -p 54321:80 \
  --name=${app} \
  -v $PWD:/app ${app}
