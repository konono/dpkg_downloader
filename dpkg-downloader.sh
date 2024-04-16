#!/bin/bash

# check args count
if [ $# -eq 0 ]; then
  echo "Usage : $0 <package name> or"
  echo "Usage : $0 -f <file_name>"
  exit
fi

if [ $# -ge 1 ]; then
  if [ $1 = '-f' ]; then
    if [ -z $2 ]; then
      echo "Usage : $0 -f <file_name>"
      exit 1
    fi
    cat $2 | while read pkg
    do
      mkdir -p ./packages/$pkg
      dpkg -l | grep -w $pkg 2>&1 > /dev/null
      if [ $? -ne 0 ]; then
        sudo apt-get install -y --download-only $pkg -o Dir::Cache=./packages/$pkg
      else
        sudo apt-get install -y --download-only $pkg -o Dir::Cache=./packages/$pkg --allow-unauthenticated
      fi
    done
  else
    for pkg in "$@"
    do
      mkdir -p ./packages/$pkg
      dpkg -l | grep -w $pkg 2>&1 > /dev/null
      if [ $? -ne 0 ]; then
        sudo apt-get install -y --download-only $pkg -o Dir::Cache=./packages/$pkg
      else
        sudo apt-get install -y --download-only $pkg -o Dir::Cache=./packages/$pkg --allow-unauthenticated
      fi
    done
  fi
fi
