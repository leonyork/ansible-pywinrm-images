#!/usr/bin/env sh
#######################################################################
# Build, test and push an image
# First argument is the version of leonyork/ansible to use
# Second argument is the pywinrm version to use
# Third argument is the image tag
#######################################################################

if [ -z "$1" ]
then
    echo "You must specify the version of the dockerhub image of ansible to use"
    exit 1
fi

if [ -z "$2" ]
then
    echo "You must specify the version of pywinrm to use"
    exit 1
fi

if [ -z "$3" ]
then
    echo "You must specify the image tag to use"
    exit 1
fi

set -eux
export ANSIBLE_DOCKERHUB_VERSION=$1;
export PYWINRM_VERSION=$2;
export IMAGE_TAG=$3;
# Don't log this as there is so too much logging
docker-compose build > /dev/null

# Test that it's working by making sure we can get the version
docker-compose run ansible --version

# Push to the docker registry
docker-compose push

# Remove any images left around
docker-compose down --rmi all 2> /dev/null