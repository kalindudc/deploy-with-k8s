#!/bin/bash

help() {
  echo "Usage: ./deploy.sh DEPLOY_PATH"
  echo "Example:"
  echo "  ./deploy.sh applications/python-echo-server/deploy/"
}

arg=$1

if [ "$cluster" == "-h" ] || [ "$cluster" == "--help" ]; then
  help
  exit 0
fi

if [ ! -d "$arg" ]; then
  echo "Deploy path does not exist"
  echo ""
  help
  exit 1
fi

if [ ! -f "$arg/TARGETS" ]; then
  echo "TARGETS not found in the build path. Please make sure a TARGETS exists in the deploy path."
  exit 1
fi

# read a list of targets from the TARGETS file, each line is a target
while IFS= read -r target
do
  kubectl --context $target apply -f $arg
done < $arg/TARGETS
