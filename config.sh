#!/bin/bash

username=$1
basedst=/home/$username

printf "bash config.sh" > $basedst/runconfig.sh
for var in "$@"
do
    printf " '" >> $basedst/runconfig.sh
    echo -n $var >> $basedst/runconfig.sh
    printf "'" >> $basedst/runconfig.sh
done

gitlocation=$2
gitkey=$(base64 --decode <<< $3)
script=$4

shift 4

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

# Using here document would work, but ARM template extension manager wishes to switch to some other 
# directory in middle of script causing failure - 
# Could not change back to '/var/lib/waagent/custom-script/download/22'
#sudo -H -u $username bash << ENDBLOCK

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils openssh-client git

mkdir -p $basedst
printf -- "$gitkey" > $basedst/gitkey
chmod 600 $basedst/gitkey

mkdir -p ~/.ssh
printf -- "Host *\n    StrictHostKeyChecking no\n    UserKnownHostsFile /dev/null\n" > ~/.ssh/config
mkdir -p /home/$username/.ssh
printf -- "Host *\n    StrictHostKeyChecking no\n    UserKnownHostsFile /dev/null\n" > /home/$username/.ssh/config

ssh-agent bash -c "ssh-add $basedst/gitkey; \
   git clone git@github.com:$gituser/$gitrepo $basedst/$gitrepo; \
   cd $basedst/$gitrepo; \
   git fetch --all; \
   git checkout $gitbranch; \
   git pull"

#echo bash $basedst/$gitrepo/$script "$@" > $basedst/configargs1
printf "bash $basedst/$gitrepo/$script" > $basedst/runconfig1.sh
for var in "$@"
do
    printf " '" >> $basedst/runconfig1.sh
    echo -n $var >> $basedst/runconfig1.sh
    printf "'" >> $basedst/runconfig1.sh
done

sudo chown -R $username $basedst

sudo -H -u $username bash $basedst/$gitrepo/$script "$@"

#ENDBLOCK
