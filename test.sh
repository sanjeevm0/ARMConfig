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