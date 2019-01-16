#!/bin/bash

username=$1
gitlocation=$2
gitkey=$3
script=$4
basedst=/home/$username

printf "bash config.sh" > $basedst/runconfig.sh
for var in "$@"
do
    printf " '" >> $basedst/runconfig.sh
    echo -n $var >> $basedst/runconfig.sh
    printf "'" >> $basedst/runconfig.sh
done

shift 5

#echo User: $username
#echo Location: $gitlocation

defIFS=$IFS
IFS='/'
read -ra VALS <<< "$gitlocation"
IFS=$defIFS
gituser="${VALS[0]}"
gitrepo="${VALS[1]}"
gitbranch="${VALS[2]}"

#echo User: $gituser
#echo Repo: $gitrepo
#echo Branch: $gitbranch

#sudo -H -u $username bash << ENDBLOCK

sudo apt-get update
sudo apt-get install -y --no-install-recommends apt-utils openssh-client git

mkdir -p $basedst
printf -- "$gitkey" > $basedst/gitkey
chmod 600 $basedst/gitkey

mkdir -p ~/.ssh
printf -- "Host *\n    StrictHostKeyChecking no\n" > ~/.ssh/config
mkdir -p /home/$username/.ssh
printf -- "Host *\n    StrictHostKeyChecking no\n" > /home/$username/.ssh/config

ssh-agent bash -c "ssh-add $basedst/gitkey; \
   git clone git@github.com:$gituser/$gitrepo $basedst/$gitrepo; \
   cd $basedst/$gitrepo; \
   git fetch --all; \
   git checkout $gitbranch; \
   git pull"

echo bash $basedst/$gitrepo/$script "$@" > $basedst/configargs1

sudo chown -R $username $basedst

sudo -H -u $username bash $basedst/$gitrepo/$script "$@"

#ENDBLOCK
