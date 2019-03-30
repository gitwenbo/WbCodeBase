#!/bin/bash

db_176_username="root";
db_176_password="123456789";
db_176_hostname="10.211.2.176";
db_176_schema="postdedup_matching";

datasource=$1;

# leaf_categoryIds=`curl https://product.coupang.com/api/v1/meta/category/leaf/categoryId/$training_categoryId | jq '.[].categoryId' | tr "\n" "," | sed 's/,$//g' | sed 's/,2296//g'`;

export TZ=Asia/Shanghai;
dateOfToday=`date "+%Y%m%d%H%M%S"`;
filePath=/home/matching_analysis/result;
scriptsFilePath=/db_temp/sql_scripts;
result_ouputfile=$filePath/$datasource"_score_comparison_"$dateOfToday".csv";

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


function execSqlOn176DB {
   execCmdOn176DB="mysql -u$db_176_username -p$db_176_password -D$db_176_schema -h$db_176_hostname -N -e "
   execSql "$execCmdOn176DB" "$1" "$2" "$3";
}

function getPairItemScores {
    sql="select pairItemId,CItemId,QItemId,score,dlSimilarityScore from pair_items where datasource=$1 limit 1000"
    execSqlOn176DB "$sql" $STRING_RESULT_FLAG;
}

function updateFeatureScoreContrast {
    liveTrainingFscoreUrl = "http://post-dedup-matching.coupang.net/learning/analyze?modelId=675&qItemId=$1&cItemId=$2"

    while true
    do
        cnt=5;
        liveTrainingFscore=`curl --user whuang:Tmac~62517632 $liveTrainingFscoreUrl | grep "<b>score:</b>" -A 1 | grep "text-left" | sed 's/<div class="col-sm-3 text-left\">//g' | sed 's/<\/div>//g'`;
        while [[ ! -n "$liveTrainingFscore"  && $cnt -ge 0 ]]
        do
            liveTrainingFscore=`curl --user whuang:Tmac~62517632 $liveTrainingFscoreUrl | grep "<b>score:</b>" -A 1 | grep "text-left" | sed 's/<div class="col-sm-3 text-left\">//g' | sed 's/<\/div>//g'`;
            cnt=$[cnt-1];
        done
    done
}

function printComparisonResult {
#    mysql -e "select * from tbl" | while read line ; do echo "$line" ; done


    getPairItemScores "$1";
    pairItem=$sql_string_result;


}