#!/bin/bash

USERNAME=$1
EXPIRED_AT=$2

usermod -e "${EXPIRED_AT}" "${USERNAME}" &> /dev/null
