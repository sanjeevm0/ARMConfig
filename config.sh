#!/bin/bash 

apt-get update 
apt-get install -y --no-install-recommends apt-utils openssh-client git

gitlocation=$1
gitkey=$2
script=$3
basedst=$4
shift 4

echo "$@" > $basedst/configargs0

defIFS=$IFS
IFS='/'
read -ra VALS <<< "$gitlocation"
IFS=$defIFS
gituser="${VALS[0]}"
gitrepo="${VALS[1]}"
gitbranch="${VALS[2]}"

mkdir -p $basedst
printf -- "$gitkey" > $basedst/gitkey
chmod 400 $basedst/gitkey

ssh-agent bash -c "ssh-add $basedst/gitkey; \
   git clone git@github.com:$gituser/$gitrepo $basedst/$gitrepo; \
   cd $basedst/$gitrepo; \
   git fetch --all; \
   git checkout $gitbranch; \
   git pull"

echo bash $basedst/$gitrepo/$script "$@" > $basedst/configargs1

bash $basedst/$gitrepo/$script "$@"

