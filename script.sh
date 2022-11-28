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
#export REPO_NAME=${{ github.event.repository.name }}

if  uses "${VALOR_PRO_VERSION}"; then
    echo "usando image tag informada $VALOR_PRO_VERSION"
else
    export VALOR_PRO_VERSION=$(git log --format="%h" -n 1)
    echo "usando image tag gerada $VALOR_PRO_VERSION"
fi
        
export IMAGE_NAME=$IMAGE_BASE_PATH/$REPO_NAME:$VALOR_PRO_VERSION 

docker login -u $USERNAME -p $PASSWORD $HOST
docker build . -t $IMAGE_NAME
docker push $IMAGE_NAME