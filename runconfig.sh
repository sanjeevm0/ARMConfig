#!/bin/bash 

$username = $1
shift

sudo -H -u $username bash -c config.sh "$@"
