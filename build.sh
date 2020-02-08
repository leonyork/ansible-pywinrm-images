#!/usr/bin/env sh
#######################################################################
# Build, test and push the images
# Creates multiple versions so that there's some choice about versions
# to use
#######################################################################
set -eux

# Number of releases to go back from the latest version
number_of_ansible_dockerhub_releases=10
number_of_pywinrm_releases=3


# Creates tags of the form {ANSIBLE_DOCKERHUB_VERSION}-pywinrm-{PYWINRM_VERSION} (e.g. 2.9.2-alpine-3.11.0-pywinrm-0.4.1)
# First gets the last $number_of_ansible_dockerhub_releases
# For each of those tags gets the last $number_of_pywinrm_releases of non-release candidate versions of pywinrm and builds an image
docker run leonyork/docker-tags leonyork/ansible \
    | grep -E '^[0-9.]+\-alpine-[0-9.]+$' \
    | tail -n $number_of_ansible_dockerhub_releases \
    | xargs -I{ANSIBLE} -n1 \
        sh -c "docker run leonyork/pypi-releases pywinrm \
        | grep -E '^[0-9.]\.[0-9.]+$' \
        | tail -n $number_of_pywinrm_releases \
        | xargs -I{PYWINRM_VERSION} -n1 sh build-image.sh {ANSIBLE} {PYWINRM_VERSION} {ANSIBLE}-pywinrm{PYWINRM_VERSION} || exit 255" || exit 255

# Don't include release candidates (i.e. look for a version with numbers and dots)
pywinrm_latest_version=`docker run leonyork/pypi-releases pywinrm | grep -E '^[0-9.]+$' | tail -n 1`
# Creates tags of the form {ANSIBLE_VERSION}-alpine-pywinrm (e.g. 2.9.2-alpine-pywinrm)
# Gets the last $number_of_ansible_dockerhub_releases of dockerhub ansible releases and uses the latest version of pywinrm
docker run leonyork/docker-tags leonyork/ansible \
        | grep -E '^[0-9.]+\-alpine$' \
        | tail -n $number_of_ansible_dockerhub_releases \
        | xargs -I{ANSIBLE} -n1 sh build-image.sh {ANSIBLE} $pywinrm_latest_version {ANSIBLE}-pywinrm || exit 255

# Build the latest pywinrm image
sh build-image.sh latest $pywinrm_latest_version pywinrm