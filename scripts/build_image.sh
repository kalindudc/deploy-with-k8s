#!/bin/bash

help() {
  echo "Usage: ./build_image.sh BUIL_PATH"
  echo "Example:"
  echo "  ./build_image.sh applications/python-echo-server/"
}

arg="${1%/}"

if [ "$arg" == "-h" ] || [ "$arg" == "--help" ]; then
  help
  exit 0
fi

if [ -z "$arg" ]; then
  echo "Please provide a build path"
  echo ""
  help
  exit 1
fi

# Check if the build path exists
if [ ! -d "$arg" ]; then
  echo "Build path does not exist"
  echo ""
  help
  exit 1
fi

# Check if there is a Dockerfile in the build path
if [ ! -f "$arg/Dockerfile" ]; then
  echo "Dockerfile not found in the build path. Please make sure a Dockerfile exists in the build path."
  exit 1
fi

# check if there is a VERSION file in the build path
if [ ! -f "$arg/VERSION" ]; then
  echo "VERSION file not found in the build path. Please make sure a VERSION file exists in the build path."
  exit 1
fi

# read the version number from the VERSION file
version=$(cat $arg/VERSION)
app_name=$(basename $arg)

# build the docker image
docker build -t $app_name:$version -t $app_name:latest $arg

echo " "
echo "Docker image $app_name:$version and $app_name:latest built successfully"

echo "Loading the image into minikube, :$version"
minikube image load $app_name:$version

echo "Loading the image into minikube, :latest"
minikube image load $app_name:latest

echo "Image loaded successfully"
