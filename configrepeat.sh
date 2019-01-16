#!/bin/bash 

#sed '0,/config.sh/{s/config.sh/configrepeat.sh/}' testrepeat.sh > testrepeat_temp.sh; mv testrepeat_temp.sh testepeat.sh
cp testrepeat.sh configold.sh

printf "bash configrepeat.sh" > testrepeat.sh
for var in "$@"
do
    printf ' "' >> $testrepeat.sh
    echo -n $var >> $testrepeat.sh
    printf '"' >> $testrepeat.sh
done
