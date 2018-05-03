#!/bin/bash

db_username="product-app";
db_password="Cf3C3fl58ff96^06";
db_hostname="aurora-mysql-post-dedup-a.cluster-cxm9prevocey.ap-northeast-2.rds.amazonaws.com";
db_schema="postdedup";

product_db_username="product-app";
product_db_password="Cf3C3fl58ff96^06";
product_db_hostname="read.product.dbms.coupang.net";
product_db_schema="product";

db_47_username="root";
db_47_password="123456789";
db_47_hostname="10.211.2.176";
db_47_schema="postdedup_matching_47";

db_176_username="root";
db_176_password="123456789";
db_176_hostname="10.211.2.176";
db_176_schema="postdedup_matching";

trainingModelName="";
trainingModelId=$1;
training_categoryId=$2;
new_triggerid=$3;
leaf_categoryIds=$4;
previous_triggerids=$5;

# leaf_categoryIds=`curl https://product.coupang.com/api/v1/meta/category/leaf/categoryId/$training_categoryId | jq '.[].categoryId' | tr "\n" "," | sed 's/,$//g' | sed 's/,2296//g'`;

export TZ=Asia/Shanghai;
dateOfToday=`date "+%Y%m%d%H%M%S"`;
filePath=/home/matching_analysis/result;
scriptsFilePath=/db_temp/sql_scripts;
tmpFile=$filePath/$new_triggerid"_tmp_"$dateOfToday".csv";
insertSqlFile=$scriptsFilePath/"insert_"$dateOfToday".sql";
result_ouputfile=$filePath/$new_triggerid"_inspect_analysis_"$dateOfToday".csv";

NUMBER_RESULT_FLAG="RETURN_NUMBER";
STRING_RESULT_FLAG="RETURN_STRING";


function execSql {
   execCmd=$1;
   sql=$2;
   returnType=$3;
   outputFile=$4;

   # echo $sql;

   if [[ ! -n "$outputFile" ]] ; then
       if [[ "$returnType" == "$NUMBER_RESULT_FLAG" ]] ; then
           sql_numeric_result=`$execCmd "$sql"`;
       else
           sql_string_result=`$execCmd "$sql"`;
       fi
   else
       
       $execCmd "$sql" >> $outputFile;
       echo -e "\n\n" >> $outputFile;
   fi
}

function execSqlOn47DB {
   execCmdOn47DB="mysql -u$db_47_username -p$db_47_password -D$db_47_schema -h$db_47_hostname -N -e "
   execSql "$execCmdOn47DB" "$1" "$2" "$3";
}

function execSqlOn176DB {
   execCmdOn176DB="mysql -u$db_176_username -p$db_176_password -D$db_176_schema -h$db_176_hostname -N -e "
   execSql "$execCmdOn176DB" "$1" "$2" "$3";
}

function execSqlOnPostDedupDB {
   execCmdOnPostDedupDB="mysql -u$db_username -p$db_password -D$db_schema -h$db_hostname -N -e ";
   execSql "$execCmdOnPostDedupDB" "$1" "$2" "$3"; 
}

function execSqlOnProductDB {
   execCmdOnProductDB="mysql -u$product_db_username -p$product_db_password -D$product_db_schema -h$product_db_hostname -N -e ";
   execSql "$execCmdOnProductDB" "$1" "$2" "$3"; 
}

function execSqlOn47DBWithTitle {
   execCmdOn47DB="mysql -u$db_47_username -p$db_47_password -D$db_47_schema -h$db_47_hostname -e "
   execSql "$execCmdOn47DB" "$1" "$2" "$3";
}

function execSqlOnPostDedupDBWithTitle {
   execCmdOnPostDedupDB="mysql -u$db_username -p$db_password -D$db_schema -h$db_hostname -e ";
   execSql "$execCmdOnPostDedupDB" "$1" "$2" "$3"; 
}

function setModelName {
   sql_get_model_name="select trainingModelName from training_models where trainingModelId in ($1);";
   execSqlOn176DB "$sql_get_model_name" $STRING_RESULT_FLAG;

   trainingModelName=$sql_string_result;
   echo "trainingModelName=$trainingModelName";
}

function getBadSimulateItemids {
   sql_get_itemids="SELECT b.itemid requestItemId, a.itemid duplicateItemId FROM post_dedup_matching_item_candidates a JOIN post_dedup_matching_items b ON a.postDedupMatchingItemId = b.postDedupMatchingItemId AND b.postDedupJobHistoryId IN ("$new_triggerid") and strict=1 and a.verifyResult='BAD'";
   execSqlOnPostDedupDB "$sql_get_itemids" $STRING_RESULT_FLAG;
}

function getBadMergeItemids {
   sql_get_itemids="SELECT c.itemid,a.itemid FROM post_dedup_merge_request_items a JOIN post_dedup_merge_request_items c ON a.postDedupMergeRequestResultId = c.postDedupMergeRequestResultId AND a.isTarget = 0 AND c.isTarget = 1 JOIN post_dedup_merge_request_results b ON a.postDedupMergeRequestResultId = b.postDedupMergeRequestResultId AND b.postDedupJobHistoryId IN ("$1") AND a.verifyResult = 'BAD';";
   execSqlOnPostDedupDB "$sql_get_itemids" $STRING_RESULT_FLAG;
}

function getItemCategoryInsertSqls {
   sql_build_item_category_insert_sql="select concat('insert into tmp_item_category_info values(', a.itemid, ',\'',REPLACE(d.name,'\'',''),'\',', b.categoryid,',\'',REPLACE(c.name,'\'',''),'\');') from items a join products b on a.productid=b.productid join categories c on b.categoryid=c.categoryid join item_locales d on a.itemid=d.itemid where a.itemid in ("$1");";
   execSqlOnProductDB "$sql_build_item_category_insert_sql" $STRING_RESULT_FLAG;
}

function getSimulateErrorDetailInsertSqls {
   plot_results_separately_insert_sql_simulate="select concat('insert into matching_error_details values(', b.itemid, ',', a.itemid, ',\'', a.comments,'\',\'', a.comments, '\',\'', IFNULL(a.verifier,'COPIED'), '\',NULL,NULL,NULL,NULL,NULL,NULL,NULL,\'',a.score,'\',NULL,NULL,NULL);') FROM post_dedup_matching_item_candidates a JOIN post_dedup_matching_items b ON a.postDedupMatchingItemId = b.postDedupMatchingItemId AND b.postDedupJobHistoryId IN ("$1") and strict=1 and a.verifyResult='BAD' group by b.itemid,a.itemid, a.comments, a.verifier order by b.itemid, a.verifier, count(1);";
   execSqlOnPostDedupDB "$plot_results_separately_insert_sql_simulate" $STRING_RESULT_FLAG;
}

function getMergeErrorDetailInsertSqls {
   plot_results_separately_insert_sql_real_merge="select concat('insert into matching_error_details values(', c.itemid, ',', a.itemid, ',\'', a.comments,'\',\'', a.comments, '\',\'', IFNULL(a.verifier, 'NULL'), '\',NULL,NULL,NULL,NULL,NULL,NULL,NULL,\'',a.score,'\',NULL,NULL,NULL);') FROM post_dedup_merge_request_items a JOIN post_dedup_merge_request_items c ON a.postDedupMergeRequestResultId=c.postDedupMergeRequestResultId and a.isTarget =0 and c.isTarget=1 JOIN post_dedup_merge_request_results b ON a.postDedupMergeRequestResultId = b.postDedupMergeRequestResultId AND b.postDedupJobHistoryId IN ("$1") and a.verifyResult='BAD' group by c.itemid, a.itemid, a.comments, a.verifier order by requestItemId, a.verifier, count(1);";
   execSqlOnPostDedupDB "$plot_results_separately_insert_sql_real_merge" $STRING_RESULT_FLAG;
}

function getErrorItemPairs {
   execSqlOn47DB "$sql_truncate_error_pair_item_table" $STRING_RESULT_FLAG;

   sql_get_error_item_pairs="select GROUP_CONCAT(concat('(b.qItemId=',requestItemId,' and b.citemId=',duplicateItemId, ')') separator ' or ') from matching_error_details;";
   execSqlOn47DB "$sql_get_error_item_pairs" $STRING_RESULT_FLAG;

   sql_get_insert_training_error_pair_items_sqls="SELECT distinct CONCAT('insert into training_error_pair_items values(', a.pairItemId, ',', b.qItemId, ',', b.citemId,',', c.score, ');')FROM training_samples a JOIN training_predict_results c on a.pairItemId = c.pairItemId and c.trainingModelId="$1" join pair_items b ON a.pairItemId = b.pairItemId and a.trainingModelId="$1" and ("$sql_string_result");";

   execSqlOn176DB "$sql_get_insert_training_error_pair_items_sqls" $STRING_RESULT_FLAG;

   execSqlOn47DB "$sql_string_result" $STRING_RESULT_FLAG;
}

function setTriggerTime {
    sql_get_trigger_start_time="select date_format(CONVERT_TZ(createdAt,'+09:00','+00:00'),'%Y-%m-%dT%H:%i:%s') from post_dedup_job_histories where postDedupJobHistoryId='"$new_triggerid"'";
    sql_get_trigger_end_time="select date_format(CONVERT_TZ(modifiedAt,'+09:00','+00:00'),'%Y-%m-%dT%H:%i:%s') from post_dedup_job_histories where postDedupJobHistoryId='"$new_triggerid"'";

    execSqlOnPostDedupDB "$sql_get_trigger_start_time" $STRING_RESULT_FLAG;
    trigger_start_time=`echo $sql_string_result | sed 's/:/%3A/g'`;

    execSqlOnPostDedupDB "$sql_get_trigger_end_time" $STRING_RESULT_FLAG;
    trigger_end_time=`echo $sql_string_result | sed 's/:/%3A/g'`;
}

function updateErrorDetailCategoryInfo {
    # update_error_detail_category_info="update matching_error_details a join tmp_item_category_info b on a.requestItemId=b.itemId join tmp_item_category_info c on a.duplicateItemId=c.itemId left JOIN training_error_pair_items d on a.requestItemId=d.qitemid and a.duplicateItemId=d.citemid set a.cagtegoryIdDetail= concat(b.categoryId,' ',b.categoryName,' -- ',c.categoryId,' ',c.categoryName,', ', case when b.categoryId in ("$leaf_categoryIds") then 1 else 0 end, case when c.categoryId in ("$leaf_categoryIds") then 1 else 0 end), a.requestItemDetail=concat('=HYPERLINK(\"https://catalog-tools.coupang.net/quality/items/',a.requestItemId,'/detail\", \"click\")'),a.duplicateItemDetail=concat('=HYPERLINK(\"https://catalog-tools.coupang.net/quality/items/',a.duplicateItemId,'/detail\", \"click\")'),a.tagDetail=concat('=HYPERLINK(\"http://post-dedup.coupang.net/match/analyze/initialize?qItemId=',a.requestItemId,'&cItemId=',a.duplicateItemId,'\", \"click\")'),a.grayLogDetail=concat('=HYPERLINK(\"https://log-viewer.coupang.net/streams/000000000000000000000001/search?rangetype=absolute&from="$trigger_start_time".000Z&to="$trigger_end_time".000Z&q=role%3Apost_dedup_matching+AND+%22',a.requestItemId,'%22+AND+%22',a.duplicateItemId,'%22+AND+%modelName%3A%20"$trainingModelName"%22%20AND%20%22FScores%22\", \"click\")'),a.trainingFeatureDetail=concat('=HYPERLINK(\"http://post-dedup-matching.coupang.net/learning/model/',"$trainingModelId",'/analyze/',d.pairItemId,'\", \"click\")');";
    # update_error_detail_category_info="update matching_error_details a join tmp_item_category_info b on a.requestItemId=b.itemId join tmp_item_category_info c on a.duplicateItemId=c.itemId left JOIN training_error_pair_items d on a.requestItemId=d.qitemid and a.duplicateItemId=d.citemid set a.cagtegoryIdDetail= concat(b.categoryId,' ',b.categoryName,' -- ',c.categoryId,' ',c.categoryName,', ', case when b.categoryId in ("$leaf_categoryIds") then 1 else 0 end, case when c.categoryId in ("$leaf_categoryIds") then 1 else 0 end), a.score = CONCAT(a.score, '|', IFNULL(d.score,'NA')), a.requestItemDetail=concat('=HYPERLINK(\"https://catalog-tools.coupang.net/quality/items/',a.requestItemId,'/detail\", \"click\")'),a.duplicateItemDetail=concat('=HYPERLINK(\"https://catalog-tools.coupang.net/quality/items/',a.duplicateItemId,'/detail\", \"click\")'),a.tagDetail=concat('=HYPERLINK(\"http://post-dedup.coupang.net/match/analyze/initialize?qItemId=',a.requestItemId,'&cItemId=',a.duplicateItemId,'\", \"click\")'),a.grayLogDetail=concat('=HYPERLINK(\"https://log-viewer.coupang.net/streams/000000000000000000000001/search?rangetype=absolute&from="$trigger_start_time".000Z&to="$trigger_end_time".000Z&q=role%3Apost_dedup_matching+AND+%22',a.requestItemId,'%22+AND+%22',a.duplicateItemId,'%22+AND+%22modelName%22\", \"click\")'),a.grayLogFscoreUrl=concat('https://log-viewer.coupang.net/api/search/universal/absolute?query=role%3Apost_dedup_matching%20AND%20%22',a.requestItemId,'%22%20AND%20%22',a.duplicateItemId,'%22%20AND%20%22modelName%3A%20"$trainingModelName"%22%20AND%20%22FScores%22&from="$trigger_start_time".000Z&to="$trigger_end_time".000Z&filter=streams%3A000000000000000000000001&limit=150&sort=timestamp%3Adesc'),a.trainingFeatureDetail=concat('=HYPERLINK(\"http://post-dedup-matching.coupang.net/learning/model/',"$trainingModelId",'/analyze/',d.pairItemId,'\", \"click\")');";
    update_error_detail_category_info="update matching_error_details a join tmp_item_category_info b on a.requestItemId=b.itemId join tmp_item_category_info c on a.duplicateItemId=c.itemId left JOIN training_error_pair_items d on a.requestItemId=d.qitemid and a.duplicateItemId=d.citemid set a.cagtegoryIdDetail= concat(b.categoryId,' ',b.categoryName,' -- ',c.categoryId,' ',c.categoryName,', ', case when b.categoryId in ("$leaf_categoryIds") then 1 else 0 end, case when c.categoryId in ("$leaf_categoryIds") then 1 else 0 end), a.score = CONCAT(a.score, '|', IFNULL(d.score,'NA')), a.requestItemDetail=concat('=HYPERLINK(\"https://catalog-tools.coupang.net/quality/items/',a.requestItemId,'/detail\", \"click\")'),a.duplicateItemDetail=concat('=HYPERLINK(\"https://catalog-tools.coupang.net/quality/items/',a.duplicateItemId,'/detail\", \"click\")'),a.tagDetail=concat('=HYPERLINK(\"http://post-dedup.coupang.net/match/analyze/initialize?qItemId=',a.requestItemId,'&cItemId=',a.duplicateItemId,'\", \"click\")'),a.grayLogDetail=concat('=HYPERLINK(\"https://log-viewer.coupang.net/streams/000000000000000000000001/search?rangetype=absolute&from="$trigger_start_time".000Z&to="$trigger_end_time".000Z&q=role%3Apost_dedup_matching+AND+%22',a.requestItemId,'%22+AND+%22',a.duplicateItemId,'%22+AND+%22boosterScores%22\", \"click\")'),a.grayLogFscoreUrl=concat('https://log-viewer.coupang.net/api/search/universal/absolute?query=role%3Apost_dedup_matching%20AND%20%22',a.requestItemId,'%22%20AND%20%22',a.duplicateItemId,'%22%20AND%20%22modelName%3A%20"$trainingModelName"%22%20AND%20%22FScores%22&from="$trigger_start_time".000Z&to="$trigger_end_time".000Z&filter=streams%3A000000000000000000000001&limit=150&sort=timestamp%3Adesc'),a.trainingFeatureDetail=concat('=HYPERLINK(\"http://post-dedup-matching.coupang.net/learning/model/',"$trainingModelId",'/analyze/',d.pairItemId,'\", \"click\")'),a.liveTrainingFeatureDetail=CONCAT('=HYPERLINK(\"http://post-dedup-matching.coupang.net/learning/analyze?modelId=','$trainingModelId','&qItemId=',a.requestItemId,'&cItemId=',a.duplicateItemId,'\", \"click\")');";
    # update_error_detail_category_info="update matching_error_details a join tmp_item_category_info b on a.requestItemId=b.itemId join tmp_item_category_info c on a.duplicateItemId=c.itemId left JOIN training_error_pair_items d on a.requestItemId=d.qitemid and a.duplicateItemId=d.citemid set a.score = CONCAT(a.score, '|', IFNULL(d.score,'NA')), a.requestItemDetail=concat('=HYPERLINK(\"https://catalog-tools.coupang.net/quality/items/',a.requestItemId,'/detail\", \"click\")'),a.duplicateItemDetail=concat('=HYPERLINK(\"https://catalog-tools.coupang.net/quality/items/',a.duplicateItemId,'/detail\", \"click\")'),a.tagDetail=concat('=HYPERLINK(\"http://post-dedup.coupang.net/match/analyze/initialize?qItemId=',a.requestItemId,'&cItemId=',a.duplicateItemId,'\", \"click\")'),a.grayLogDetail=concat('=HYPERLINK(\"https://log-viewer.coupang.net/streams/000000000000000000000001/search?rangetype=absolute&from="$trigger_start_time".000Z&to="$trigger_end_time".000Z&q=role%3Apost_dedup_matching+AND+%22',a.requestItemId,'%22+AND+%22',a.duplicateItemId,'%22+AND+%22boosterScores%22\", \"click\")'),a.grayLogFscoreUrl=concat('https://log-viewer.coupang.net/api/search/universal/absolute?query=role%3Apost_dedup_matching%20AND%20%22',a.requestItemId,'%22%20AND%20%22',a.duplicateItemId,'%22%20AND%20%22modelName%3A%20"$trainingModelName"%22%20AND%20%22FScores%22&from="$trigger_start_time".000Z&to="$trigger_end_time".000Z&filter=streams%3A000000000000000000000001&limit=150&sort=timestamp%3Adesc'),a.trainingFeatureDetail=concat('=HYPERLINK(\"http://post-dedup-matching.coupang.net/learning/model/',"$trainingModelId",'/analyze/',d.pairItemId,'\", \"click\")'),a.liveTrainingFeatureDetail=CONCAT('=HYPERLINK(\"http://post-dedup-matching.coupang.net/learning/analyze?modelId=','$trainingModelId','&qItemId=',a.requestItemId,'&cItemId=',a.duplicateItemId,'\", \"click\")');";

    execSqlOn47DB "$update_error_detail_category_info" $STRING_RESULT_FLAG;
}

function updateFeatureScoreContrast {

    while true
    do
        get_feature_score_url="SELECT CONCAT('update matching_error_details set fscoreDiff= ,isTrainingScoreConsistent= where requestItemId=',requestItemId,' and duplicateItemId=',duplicateItemId,'^',grayLogFscoreUrl,'^',replace(replace(liveTrainingFeatureDetail,'=HYPERLINK(\"',''),'\", \"click\")',''),'^',IFNULL(replace(replace(trainingFeatureDetail,'=HYPERLINK(\"',''),'\", \"click\")',''),'')) FROM matching_error_details a WHERE fscoreDiff IS NULL LIMIT 1;";
        execSqlOn47DB "$get_feature_score_url" $STRING_RESULT_FLAG;

        if [ ! -n "$sql_string_result" ] ;then
            echo "updateFeatureScoreContrast finished!";
            return;
        fi

        OLD_IFS="$IFS";
        IFS="^";
        arr=($sql_string_result);
        IFS="$OLD_IFS";

        update_sql=${arr[0]};
        grayLogFscoreUrl=${arr[1]};
        liveTrainingFscoreUrl=${arr[2]};
        trainingFscoreUrl=${arr[3]};
            
        cnt=5;
        liveFscore=`curl --user whuang:Tmac~62517632 $grayLogFscoreUrl | jq '.messages[0].message.message' | grep -Eo 'FScores: \[.*\]' | sed 's/FScores: \[//g' | sed 's/]//g'`;
        while [[ ! -n "$liveFscore" && $cnt -ge 0 ]]
        do
            liveFscore=`curl --user whuang:Tmac~62517632 $grayLogFscoreUrl | jq '.messages[0].message.message' | grep -Eo 'FScores: \[.*\]' | sed 's/FScores: \[//g' | sed 's/]//g'`;
            cnt=$[cnt-1];
        done

        cnt=5;
        liveTrainingFscore=`curl --user whuang:Tmac~62517632 $liveTrainingFscoreUrl | grep '<pre>' | sed 's/<pre>//g' | sed 's/<\/pre>//g' | sed 's/,,/,-100,/g'`;
        while [[ ! -n "$liveTrainingFscore"  && $cnt -ge 0 ]]
        do
            liveTrainingFscore=`curl --user whuang:Tmac~62517632 $liveTrainingFscoreUrl | grep '<pre>' | sed 's/<pre>//g' | sed 's/<\/pre>//g' | sed 's/,,/,-100,/g'`;
            cnt=$[cnt-1];
        done


        isTrainingScoreConsistent="'NA'";
        # if [ ! -z "$trainingFscoreUrl" ] ;then
        #     # echo "trainingFscoreUrl:$trainingFscoreUrl";

        #     trainingFscore=`curl --user whuang:Tmac~62517632 $trainingFscoreUrl | grep '<pre>' | sed 's/<pre>//g' | sed 's/<\/pre>//g'`;
        #     if [ ! -n "$trainingFscore" ] ;then
        #         trainingFscore=`curl --user whuang:Tmac~62517632 $trainingFscoreUrl | grep '<pre>' | sed 's/<pre>//g' | sed 's/<\/pre>//g'`;
        #     fi

        #     if [ "$liveTrainingFscore" = "$trainingFscore" ] ;then
        #         isTrainingScoreConsistent="'IDENTICAL'";
        #     else 
        #         get_fscore_contrast_sql="call compareFeatureScores($trainingModelId,'$trainingFscore','$liveTrainingFscore');";
        #         execSqlOn176DB "$get_fscore_contrast_sql" $STRING_RESULT_FLAG;

        #         if [ ! -n "$sql_string_result" ] ;then
        #             isTrainingScoreConsistent="'NA'";
        #         else 
        #             isTrainingScoreConsistent="'"$sql_string_result"'";
        #         fi
        #     fi
        # fi

        get_fscore_contrast_sql="call compareFeatureScores($trainingModelId,'$liveFscore','$liveTrainingFscore');";
        execSqlOn176DB "$get_fscore_contrast_sql" $STRING_RESULT_FLAG;

        if [ ! -n "$sql_string_result" ] ;then
            fscore_contrast_result="'NA'";
        else 
            fscore_contrast_result="'"$sql_string_result"'";
        fi

        update_sql=${update_sql/isTrainingScoreConsistent=/isTrainingScoreConsistent=$isTrainingScoreConsistent};
        update_sql=${update_sql/fscoreDiff=/fscoreDiff=$fscore_contrast_result};
        
        execSqlOn47DB "$update_sql" $STRING_RESULT_FLAG;
    done
}

function getSimulateErrorDetails {
    getBadSimulateItemids $new_triggerid;
    itemids=`echo $sql_string_result | tr " " "," | tr "\t" "," | sed 's/,$//g'`;

    if [ ! -n "$itemids" ] ;then
        echo "no records for simulating";
        return;
    fi

    getItemCategoryInsertSqls "$itemids";
    sql_insert_tmp_item_category_info=$sql_string_result;
    execSqlOn47DB "$sql_truncate_tmp_table" $STRING_RESULT_FLAG;
    execSqlOn47DB "$sql_insert_tmp_item_category_info" $STRING_RESULT_FLAG;

    getSimulateErrorDetailInsertSqls $new_triggerid;
    sql_insert_matching_error_details=$sql_string_result;
    execSqlOn47DB "$sql_truncate_error_detail_table" $STRING_RESULT_FLAG;
    execSqlOn47DB "$sql_insert_matching_error_details" $STRING_RESULT_FLAG;

    getErrorItemPairs $trainingModelId;
    setTriggerTime;
    updateErrorDetailCategoryInfo;
    updateFeatureScoreContrast;

    execSqlOn47DBWithTitle "$get_matching_error_details" $STRING_RESULT_FLAG $1;
}

function getMergeErrorDetails {
    getBadMergeItemids $new_triggerid;
    itemids=`echo $sql_string_result | tr " " "," | tr "\t" "," | sed 's/,$//g'`;

    if [ ! -n "$itemids" ] ;then
        echo "no records for merging";
        return;
    fi

    getItemCategoryInsertSqls "$itemids";
    sql_insert_tmp_item_category_info=$sql_string_result;
    execSqlOn47DB "$sql_truncate_tmp_table" $STRING_RESULT_FLAG;
    execSqlOn47DB "$sql_insert_tmp_item_category_info" $STRING_RESULT_FLAG;

    getMergeErrorDetailInsertSqls $new_triggerid;
    sql_insert_matching_error_details=$sql_string_result;
    execSqlOn47DB "$sql_truncate_error_detail_table" $STRING_RESULT_FLAG;
    execSqlOn47DB "$sql_insert_matching_error_details" $STRING_RESULT_FLAG;

    getErrorItemPairs $trainingModelId;
    setTriggerTime;
    updateErrorDetailCategoryInfo;
    updateFeatureScoreContrast;

    execSqlOn47DBWithTitle "$get_matching_error_details" $STRING_RESULT_FLAG $1;
}


sql_create_tmp_table="CREATE TABLE tmp_item_category_info ( itemId INT NOT NULL, categoryId INT NULL, categoryName VARCHAR(45) NULL, PRIMARY KEY (itemId));";
sql_truncate_tmp_table="truncate TABLE tmp_item_category_info;";
sql_create_error_detail_table="CREATE TABLE matching_error_details ( requestItemId INT NOT NULL, duplicateItemId INT NULL, comments VARCHAR(450) NULL, comments_translated VARCHAR(450) NULL, verifier VARCHAR(45) NULL, cagtegoryIdDetail VARCHAR(450) NULL, grayLogDetail VARCHAR(4500) NULL, tagDetail VARCHAR(4500) NULL, requestItemDetail VARCHAR(4500) NULL, duplicateItemDetail VARCHAR(4500) NULL, PRIMARY KEY (requestItemId));";
sql_truncate_error_detail_table="truncate TABLE matching_error_details;";
sql_create_error_pair_item_table="CREATE TABLE training_error_pair_items ( pairItemId INT NOT NULL, qitemid INT NULL, citemid INT NULL, PRIMARY KEY (pairItemId));";
sql_truncate_error_pair_item_table="truncate TABLE training_error_pair_items;";


# 1.copy previous results to current trigger
sql_copy_inspection_result="UPDATE post_dedup_matching_item_candidates mic3, (SELECT b.postDedupMatchingItemCandidateId, a.verifyResult, a.comments FROM (SELECT mi1.itemId qItemId, mic1.itemId cItemId, mic1.verifyResult, mic1.comments FROM post_dedup_matching_items mi1 JOIN post_dedup_matching_item_candidates mic1 ON mi1.postDedupMatchingItemId = mic1.postDedupMatchingItemId WHERE mi1.postDedupJobHistoryId in ("$previous_triggerids") and mic1.verifyResult in ('GOOD','BAD')) a, (SELECT mic2.postDedupMatchingItemCandidateId, mi2.itemId qItemId, mic2.itemId cItemId FROM post_dedup_matching_items mi2 JOIN post_dedup_matching_item_candidates mic2 ON mi2.postDedupMatchingItemId = mic2.postDedupMatchingItemId WHERE mi2.postDedupJobHistoryId = "$new_triggerid") b WHERE a.qItemId = b.qItemId AND a.cItemId = b.cItemId) c SET mic3.verifyResult = c.verifyResult, mic3.comments = c.comments WHERE mic3.postDedupMatchingItemCandidateId = c.postDedupMatchingItemCandidateId;";
sql_copy_negative_inspection_result="UPDATE post_dedup_matching_item_candidates mic3, (SELECT b.postDedupMatchingItemCandidateId, a.verifyResult, a.comments FROM (SELECT mi1.itemId qItemId, mic1.itemId cItemId, mic1.verifyResult, mic1.comments FROM post_dedup_matching_items mi1 JOIN post_dedup_matching_item_candidates mic1 ON mi1.postDedupMatchingItemId = mic1.postDedupMatchingItemId WHERE mi1.postDedupJobHistoryId in ("$previous_triggerids") and mic1.verifyResult in ('BAD')) a, (SELECT mic2.postDedupMatchingItemCandidateId, mi2.itemId qItemId, mic2.itemId cItemId FROM post_dedup_matching_items mi2 JOIN post_dedup_matching_item_candidates mic2 ON mi2.postDedupMatchingItemId = mic2.postDedupMatchingItemId WHERE mi2.postDedupJobHistoryId = "$new_triggerid") b WHERE a.qItemId = b.qItemId AND a.cItemId = b.cItemId) c SET mic3.verifyResult = c.verifyResult, mic3.comments = c.comments WHERE mic3.postDedupMatchingItemCandidateId = c.postDedupMatchingItemCandidateId;";

# 2.get error details
get_matching_error_details="SELECT concat(requestItemId,' - ', duplicateItemId) item_pair,comments_translated comments,comments_translated,grayLogDetail,trainingFeatureDetail,liveTrainingFeatureDetail,requestItemDetail,duplicateItemDetail,score,fscoreDiff,cagtegoryIdDetail as cagtegoryDetail,verifier FROM matching_error_details order by verifier,comments_translated,requestItemId,duplicateItemId";

# 3.get errors group by err-message
sql_new_error_messages="SELECT b.itemid requestItemId, GROUP_CONCAT(a.itemid order by a.itemid separator '|') duplicateItemIds, a.comments, a.comments comments_translated, count(1) FROM post_dedup_matching_item_candidates a JOIN post_dedup_matching_items b ON a.postDedupMatchingItemId = b.postDedupMatchingItemId AND b.postDedupJobHistoryId IN ("$new_triggerid") and strict=1 and a.verifyResult='BAD' AND a.verifier IS NOT NULL group by requestItemId, a.comments order by requestItemId, count(1);";
sql_old_error_messages="SELECT b.itemid requestItemId, GROUP_CONCAT(a.itemid order by a.itemid separator '|') duplicateItemIds, a.comments, a.comments comments_translated, count(1) FROM post_dedup_matching_item_candidates a JOIN post_dedup_matching_items b ON a.postDedupMatchingItemId = b.postDedupMatchingItemId AND b.postDedupJobHistoryId IN ("$new_triggerid") and strict=1 and a.verifyResult='BAD' AND a.verifier IS NULL group by requestItemId, a.comments order by requestItemId, count(1);";
sql_merge_error_messages="SELECT c.itemid requestItemId, GROUP_CONCAT(a.itemid order by a.itemid separator '|') duplicateItemIds, a.comments, a.comments comments_translated, count(1) FROM post_dedup_merge_request_items a JOIN post_dedup_merge_request_items c ON a.postDedupMergeRequestResultId=c.postDedupMergeRequestResultId and a.isTarget =0 and c.isTarget=1 JOIN post_dedup_merge_request_results b ON a.postDedupMergeRequestResultId = b.postDedupMergeRequestResultId AND b.postDedupJobHistoryId IN ("$new_triggerid") and a.verifyResult='BAD' group by c.itemid, a.comments order by requestItemId, count(1);"

# 4.Get newly inspected samples
sql_simulate_samples="SELECT DISTINCT b.itemid qItemId, a.itemid cItemId, CASE a.verifyResult WHEN 'BAD' THEN 0 WHEN 'GOOD' THEN 1 END AS inspectionResult, '"$training_categoryId"_SIMULATION_"$new_triggerid"' dataSource, a.comments FROM post_dedup_matching_item_candidates a JOIN post_dedup_matching_items b ON a.postDedupMatchingItemId = b.postDedupMatchingItemId AND b.postDedupJobHistoryId IN ("$new_triggerid") AND strict = 1 AND a.verifier IS NOT NULL ORDER BY inspectionResult,qItemId,cItemId;";
sql_merge_samples="SELECT DISTINCT b.itemid qItemId, a.itemid cItemId, CASE a.verifyResult WHEN 'BAD' THEN 0 WHEN 'GOOD' THEN 1 END AS inspectionResult, '"$training_categoryId"_MERGED_INSPECTION_"$new_triggerid"' dataSource, a.comments FROM post_dedup_merge_request_items a JOIN post_dedup_merge_request_items b ON a.postDedupMergeRequestResultId = b.postDedupMergeRequestResultId and a.isTarget =0 and b.isTarget=1 JOIN post_dedup_merge_request_results c ON a.postDedupMergeRequestResultId = c.postDedupMergeRequestResultId AND c.postDedupJobHistoryId IN ("$new_triggerid") AND a.verifier IS NOT NULL ORDER BY inspectionResult,qItemId,cItemId;";


setModelName $trainingModelId;

if [ $previous_triggerids ];then
	echo $sql_copy_inspection_result;
  echo -e "\n...\n"
  echo $sql_copy_negative_inspection_result;
	echo -e "\n...\n" 
	mysql -u$db_username -p$db_password -Dpostdedup -h $db_hostname -e "$sql_copy_inspection_result";
  mysql -u$db_username -p$db_password -Dpostdedup -h $db_hostname -e "$sql_copy_negative_inspection_result";
fi

echo -e "\nANAlYSIS REPORT" >> $tmpFile;
echo -e "Trigger $new_triggerid" >> $tmpFile;
echo -e "\n$trainingModelId" >> $tmpFile;
echo -e "$trainingModelName\n" >> $tmpFile;
# echo -e "\nLeaf categories -- \n$leaf_categoryIds" >> $tmpFile;

echo -e "\nSIMULATION --\n";
echo -e "\nSIMULATION --\n" >> $tmpFile;
# echo -e "1. new errors\n" >> $tmpFile;
# execSqlOnPostDedupDBWithTitle "$sql_new_error_messages" $STRING_RESULT_FLAG $tmpFile;
# echo -e "2. old errors\n" >> $tmpFile;
# execSqlOnPostDedupDBWithTitle "$sql_old_error_messages" $STRING_RESULT_FLAG $tmpFile;
echo -e "1. error details\n";
echo -e "1. error details\n" >> $tmpFile;
getSimulateErrorDetails $tmpFile;


echo -e "\nMERGE --\n";
echo -e "\nMERGE --\n" >> $tmpFile;
# echo -e "1. errors group by error message\n" ;
# echo -e "1. errors group by error message\n" >> $tmpFile;
# execSqlOnPostDedupDBWithTitle "$sql_merge_error_messages" $STRING_RESULT_FLAG $tmpFile;
echo -e "1. error details\n";
echo -e "1. error details\n" >> $tmpFile;
getMergeErrorDetails $tmpFile;

# sed 's/,/\|/g' $tmpFile > $result_ouputfile;
find $filePath -amin +480 -type f -exec rm -rf {} \;

