#!/bin/bash 

gitlocation=$1

defIFS=$IFS
IFS='/'
echo $IFS
echo $defIFS
read -ra VALS <<< "$gitlocation"
IFS=$defIFS
echo $IFS
gituser="${VALS[0]}"
gitrepo="${VALS[1]}"
gitbranch="${VALS[2]}"

echo $gituser
echo $gitrepo
echo $gitbranch

bash -c "echo git@github.com:$gituser/$gitrepo /home/$gitrepo"

bash -c 'echo git@github.com:'$gituser'/'$gitrepo' /home/'$gitrepo

