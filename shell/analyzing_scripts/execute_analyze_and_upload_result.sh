#!/bin/bash

trainingModelId=$1
categoryId=$2
new_triggerids=$3
previous_triggerids=$4

# rm -rf /home/matching_analysis/result/*

find /home/matching_analysis/result/ -amin +480 -type f -exec rm -rf {} \;

OLD_IFS="$IFS";
IFS=",";
arr=($new_triggerids);
IFS="$OLD_IFS";

for new_triggerid in ${arr[@]}; do
  docker exec b3365a58d7ce bash /db_temp/analyze_inspection_result2.sh $trainingModelId $categoryId $new_triggerid $previous_triggerids
done

docker cp b3365a58d7ce:/db_temp/inspection_analysis/ /home/matching_analysis/result


ftp -n 172.29.6.109 <<END_SCRIPT
user huangwenbo sleepbefore11
binary
cd /Users/huangwenbo/Documents/MachineLearning/auto_training/inspection_result_analysis
lcd /tmp/model_simulation_analyze/result/inspection_analysis
put *
quit
END_SCRIPT