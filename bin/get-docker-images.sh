#!/bin/bash
# This script pulls docker images from the Dockerhub hyperledger repositories

# set the default Docker namespace and tag
DOCKER_NS=hyperledger
ARCH=x86_64
VERSION=1.1.0
VERSION_PREVIEW=1.1.0-preview
BASE_DOCKER_TAG=x86_64-0.4.7

# set of Hyperledger Fabric images
FABRIC_IMAGES=(fabric-peer fabric-orderer fabric-ccenv fabric-javaenv fabric-tools)
FABRIC_PREVIEW_IMAGES=(fabric-kafka fabric-zookeeper fabric-couchdb)

for image in ${FABRIC_IMAGES[@]}; do
  echo "Pulling ${DOCKER_NS}/$image:${ARCH}-${VERSION}"
  docker pull ${DOCKER_NS}/$image:${ARCH}-${VERSION}
done

for image in ${FABRIC_PREVIEW_IMAGES[@]}; do
  echo "Pulling ${DOCKER_NS}/$image:${ARCH}-${VERSION_PREVIEW}"
  docker pull ${DOCKER_NS}/$image:${ARCH}-${VERSION_PREVIEW}
done

echo "Pulling ${DOCKER_NS}/fabric-baseos:${BASE_DOCKER_TAG}"
docker pull ${DOCKER_NS}/fabric-baseos:${BASE_DOCKER_TAG}
