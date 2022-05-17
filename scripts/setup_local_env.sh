#!/bin/bash

set -eu

PATH_REPO=${PWD}

PATH_WORKSTATION="${PATH_REPO}/workstation.env"
PATH_WORKSTATION_EXAMPLE="${PATH_REPO}/workstation.env.example"

if [ -f "${PATH_WORKSTATION}" ]; then
    echo "Workstation configuration exists. NOT overriding it"
else
    echo "Workstation configuration doesn't exist. copying from workstation.env.example"
    cp  $PATH_WORKSTATION_EXAMPLE $PATH_WORKSTATION
    echo "${PATH_WORKSTATION} copied. Change you env variables"
fi
