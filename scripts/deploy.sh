#!/bin/bash

# Function to display usage message
usage() {
  echo "Usage: $0 -n <namespace> -d <deploy_path>"
  echo "  -n <namespace>  Specify the namespace"
  echo "  -d <deploy_path>  Specify the deploy path"
  echo "  -h  Show this help message"
  exit 1
}

# Initialize variables
NAMESPACE=""
DEPLOY_PATH=""

# Parse command-line options
while getopts "n:d:h" opt; do
  case ${opt} in
    n )
      NAMESPACE=$OPTARG
      ;;
    d )
      DEPLOY_PATH="${OPTARG%/}"
      ;;
    h )
      usage
      ;;
    \? )
      usage
      ;;
  esac
done

# Check if both required options are provided
if [ -z "$NAMESPACE" ] || [ -z "$DEPLOY_PATH" ]; then
  echo "Error: Both -n and -d options are required."
  usage
fi

if [ ! -f "$DEPLOY_PATH/TARGETS" ]; then
  echo "TARGETS not found in the deploy path. Please make sure a TARGETS exists in the deploy path."
  exit 1
fi

# read a list of targets from the TARGETS file, each line is a target
while IFS= read -r target
do
  kubectl --context $target create namespace "$NAMESPACE" 2>/dev/null || true
  kubectl --context $target -n $NAMESPACE create configmap cluster-metadata --from-literal="CLUSTER_NAME=$target"
  krane deploy $NAMESPACE $target -f $DEPLOY_PATH
done < $DEPLOY_PATH/TARGETS
