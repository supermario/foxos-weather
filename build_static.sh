#!/bin/sh
# Starts thin client and recursively wgets whole site into static folder

bundle exec thin -d start
sleep 2
wget \
  --recursive \
  --page-requisites \
  --html-extension \
  --convert-links \
  --no-parent \
  --no-host-directories \
  -P static \
    http://localhost:3000
bundle exec thin stop

cp -rp fonts static
cp -rp icons static
cp manifest.webapp static
