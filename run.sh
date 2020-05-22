#!/bin/bash
app="myflaskapp"
docker build -t ${app} .
docker run -d -p 54321:80 \
  --name=${app} \
  -v $PWD:/app ${app}