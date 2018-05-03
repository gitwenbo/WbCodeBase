#!/bin/bash

logDate=`date "+%Y-%m-%d"`
logFile=/pang/logs/post_dedup_batch/matching_api.log
totalRequestCount=0
totalResponseCount=0

if [ $1 ] ;then
    logDate=$1
    logFile=$logFile.${1//-/}
fi

echo "date -- "$logDate
echo -e "target file -- "$logFile"\n"

for i in {0..23}
do
   hour=$i
   hourOfTheDay=$logDate" "$i
   if (($i < 10)) ;then
        hour=0$i
        hourOfTheDay=$logDate" 0"$i
   fi

   requestCount=`grep -c $logDate" "$hour":.* times" $logFile`
   responseCount=`grep -c $logDate" "$hour":.* milliseconds" $logFile`

   responseSpeed=`grep $logDate" "$hour":.* milliseconds" $logFile | grep  -P "in .* milliseconds" -o | grep -P "[0-9]*" -o | awk 'BEGIN{sum=0;num=0}{sum+=$1;num+=1}END{printf "latency(avg):%.2fms\n",num==0?0:sum/num}'`

   totalRequestCount=$[totalRequestCount+requestCount]
   totalResponseCount=$[totalResponseCount+responseCount]

   echo $hourOfTheDay": "$requestCount"(request), "$responseCount"(response), "$responseSpeed
done

echo -e "\ntotal Count: "$totalRequestCount"(request), "$totalResponseCount"(response)"
