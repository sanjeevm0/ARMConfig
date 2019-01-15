#!/bin/bash 
sudo apt-get update 
sudo apt-get install -y --no-install-recommends \
        apt-utils \
        openssh-client \
        git

username=$1
gitlocation=$2
gitkey=$3
script=$4

defIFS=$IFS
IFS='/'
read -ra VALS <<< "$gitlocation"
IFS=$defIFS
gituser = "${VALS[0]}"
gitrepo = "${VALS[1]}"
gitbranch = "${VALS[2]}"

echo $gitkey > /home/$username/gitkey

ssh-agent bash -c 'ssh-add /home/$username/gitkey; git clone git@github.com:$gituser/$gitrepo /home/$username/$gitrepo'
cd /home/$username/$gitrepo
git fetch --all
git checkout $gitbranch

bash /home/$username/$gitrepo/$script
