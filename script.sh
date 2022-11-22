#!/usr/bin/env bash

function log() {
    S=$1
    echo $S | sed 's/./& /g'
}
uses() {
    [ ! -z "${1}" ]
}

if  [ -f .env ]; then
    export $(grep -v '^#' .env  | xargs)
fi
set -x 
IMAGE_BASE_PATH=harbor.devops.valorpro.com.br/valor
export REPO_NAME=${{ github.event.repository.name }}

if  uses "${IMAGE_TAG}"; then
    echo "usando image tag informada $IMAGE_TAG"
else
    export IMAGE_TAG=$(git log --format="%h" -n 1)
    echo "usando image tag gerada $IMAGE_TAG"
fi
        
export IMAGE_NAME=$IMAGE_BASE_PATH/$REPO_NAME:$IMAGE_TAG 

docker login -u $USERNAME -p $PASSWORD $HOST
docker build . -t $IMAGE_NAME
docker push $IMAGE_NAME