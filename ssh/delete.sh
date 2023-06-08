#!/bin/bash

USERNAME=$1

userdel "${USERNAME}" &> /dev/null
