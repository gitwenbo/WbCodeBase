#!/bin/bash

db_username="product-app"
db_password="Cf3C3fl58ff96^06"
db_hostname="aurora-mysql-post-dedup-a.cluster-cxm9prevocey.ap-northeast-2.rds.amazonaws.com"

new_triggerid=$1
previous_triggerids=$2

export TZ=Asia/Shanghai
dateOfToday=`date "+%Y%m%d%H%M%S"`
filePath=/db_temp/inspection_analysis
tmpFile=$filePath/$new_triggerid"_tmp_"$dateOfToday".csv"
result_ouputfile=$filePath/$new_triggerid"_merged_list.csv"


get_results_from_real_merge="SELECT DISTINCT
    b.itemid qItemId,
    a.itemid cItemId
FROM
    post_dedup_merge_request_items a
        JOIN
    post_dedup_merge_request_items b ON a.postDedupMergeRequestResultId = b.postDedupMergeRequestResultId and a.isTarget =0 and b.isTarget=1 and a.mergedSuccess=1
		JOIN
    post_dedup_merge_request_results c ON a.postDedupMergeRequestResultId = c.postDedupMergeRequestResultId
        AND c.postDedupJobHistoryId IN ("$new_triggerid")
ORDER BY qItemId,cItemId;";

rm $filePath/*;

mysql -u$db_username -p$db_password -Dpostdedup -h $db_hostname -e "$get_results_from_real_merge" >> $tmpFile;

sed 's/,/\|/g' $tmpFile | sed 's/\t/,/g' > $result_ouputfile;
