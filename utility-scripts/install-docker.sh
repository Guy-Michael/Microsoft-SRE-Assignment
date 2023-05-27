#!/bin/bash
#Install Docker

sshIdentification=$SSH_IDENTIFICATION
pathToLocalPrivateKey="$HOME/.ssh/id_rsa"

ssh "$sshIdentification" \
    -qi "$pathToLocalPrivateKey" \
    -o StrictHostKeychecking=no \
    "curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh ./get-docker.sh"

read