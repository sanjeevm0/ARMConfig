#!/bin/bash 

username=$1
gitlocation=$2
gitkey=$3
script=$4
basedst=$5

echo bash config.sh "$@" > $basedst/runconfig.sh
shift 5

sudo -H -u $username << ENDBLOCK

apt-get update 
apt-get install -y --no-install-recommends apt-utils openssh-client git

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

printf -- "Host *\n    StrictHostKeyChecking no" >> ~/.ssh/config

ssh-agent bash -c "ssh-add $basedst/gitkey; \
   git clone git@github.com:$gituser/$gitrepo $basedst/$gitrepo; \
   cd $basedst/$gitrepo; \
   git fetch --all; \
   git checkout $gitbranch; \
   git pull"

echo bash $basedst/$gitrepo/$script "$@" > $basedst/configargs1
bash $basedst/$gitrepo/$script "$@"

ENDBLOCK
