#!/bin/bash

dateOfToday=`date "+%Y-%m-%d"`
logFile=/pang/logs/post_dedup_batch/matching_api.log
totalRequestCount=0
totalResponseCount=0

startHour=-1
startMin=-1

if [ $1 ] ;then
    logDate=$1
    startHour=${logDate:11:2}
    startMin=${logDate:14:2}
    logDate=${logDate:0:10}

    if [ "$dateOfToday" != "$logDate" ] ;then
      logFile=$logFile.${logDate//-/}
    fi
fi

echo "startHour -- "$startHour
echo "startMin -- "$startMin
echo "date -- "$logDate
echo -e "target file -- "$logFile"\n"

for hour in {0..23}
do

  if(($hour < $startHour)) ;then
    continue
  fi

  for min in {0..59}
  do

	  if(($min < $startMin)) ;then
	    continue
	  fi

	  if(($hour < 10)) ;then
	    time=$logDate" 0"$hour
	  else
	    time=$logDate" "$hour
	  fi

	  if(($min< 10)) ;then
	    time=$time":0"$min
	  else
	    time=$time":"$min
	  fi

	   requestCount=`grep -c "$time:.* times" $logFile`
	   responseCount=`grep -c "$time:.* milliseconds" $logFile`

	   responseSpeed=`grep "$time:.* milliseconds" $logFile | grep  -P "in .* milliseconds" -o | grep -P "[0-9]*" -o | awk 'BEGIN{sum=0;num=0}{sum+=$1;num+=1}END{printf "latency(avg):%.2fms\n",num==0?0:sum/num}'`

	   totalRequestCount=$[totalRequestCount+requestCount]
	   totalResponseCount=$[totalResponseCount+responseCount]

	   echo "$time: "$requestCount"(request), "$responseCount"(response), "$responseSpeed
  done
done

echo -e "\ntotal Count: "$totalRequestCount"(request), "$totalResponseCount"(response)"
