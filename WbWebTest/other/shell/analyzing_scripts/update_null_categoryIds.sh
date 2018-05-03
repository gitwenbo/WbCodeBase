#!/bin/bash

db_username="root"
db_password="123456789"
db_hostname="10.211.2.211"
db_schema="postdedup_matching_47"

product_db_username="product-app"
product_db_password="Cf3C3fl58ff96^06"
product_db_hostname="aurora-mysql-product-a.cluster-ro-cxm9prevocey.ap-northeast-2.rds.amazonaws.com"
product_db_schema="product"

new_triggerid=$1
previous_triggerids=$2

export TZ=Asia/Shanghai
dateOfToday=`date "+%Y%m%d%H%M%S"`
# filePath=/db_temp/inspection_analysis
filePath=.
tmpFile=$filePath/"sql_execution_result"$dateOfToday".txt"
result_ouputfile=$filePath/$new_triggerid"_inspect_analysis_"$dateOfToday".csv"

# sql_string_result=""
declare -i sql_numeric_result=-1
NUMBER_RESULT_FLAG="RETURN_NUMBER"
STRING_RESULT_FLAG="RETURN_STRING"


function execSqlOnPostDedupDB {
    # echo -e "executing on postdedup db ...";

    if [[ "$2" == "$NUMBER_RESULT_FLAG" ]] ; then
        sql_numeric_result=`mysql -u$db_username -p$db_password -D$db_schema -h $db_hostname --show-warnings=false -N -e "$1"`;
        # echo -e "num_sql: $1 -- $sql_numeric_result";
    else
        sql_string_result=`mysql -u$db_username -p$db_password -D$db_schema -h $db_hostname --show-warnings=false -N -e "$1"`;
        # echo -e "str_sql: $1 -- \n "$sql_string_result;
    fi   
}

function execSqlOnProductDB {
    # echo -e "executing on product db ...";
    # echo "2nd param: "$2;

    if [[ "$2" == "$NUMBER_RESULT_FLAG" ]] ; then
        sql_numeric_result=`mysql -u$product_db_username -p$product_db_password -D$product_db_schema -h $product_db_hostname --show-warnings=false -N -e "$1"`;
        # echo -e "num_sql: $1 -- $sql_numeric_result" >> $tmpFile;
    else
        sql_string_result=`mysql -u$product_db_username -p$product_db_password -D$product_db_schema -h $product_db_hostname --show-warnings=false -N -e "$1"`;
        # echo -e "str_sql: $1 -- \n $sql_string_result" >> $tmpFile;
    fi
}

function getCategoryNullCount {
    execSqlOnPostDedupDB "select count(1) from pair_items a where a.categoryId IS NULL;" $NUMBER_RESULT_FLAG;
}

function printCountToUpdate {
    execSqlOnPostDedupDB "select count(1) from pair_items a where a.qitemid in ("$1") and a.categoryId IS NULL;" $NUMBER_RESULT_FLAG;
}


function getNullCategoryItemids {
    execSqlOnPostDedupDB "SELECT GROUP_CONCAT(qItemId) FROM (SELECT distinct qItemId FROM pair_items WHERE categoryId IS NULL Limit 10) a;" $STRING_RESULT_FLAG;
}


function getUpdateSqls {
    execSqlOnProductDB "select concat('update pair_items set categoryId=',b.categoryid,' where qitemid=',a.itemid,';') from items a join products b on a.productid=b.productid where a.itemid in ("$1");";
}


# while [ true ]
# do

    getCategoryNullCount;
    totalCountBefore=$sql_numeric_result;
    echo "total count before --"$totalCountBefore;

    getNullCategoryItemids;
    nullCategoryItemids=$sql_string_result;
    echo "itemids --"$nullCategoryItemids;

    printCountToUpdate $nullCategoryItemids;
    updateCount=$sql_numeric_result;
    echo "update count --"$updateCount;

    getUpdateSqls $nullCategoryItemids;
    updateSqls=$sql_string_result;
    echo "updateSqls --"$updateSqls;

    execSqlOnPostDedupDB "$updateSqls";

    getCategoryNullCount;
    totalCountAfter=$sql_numeric_result;
    echo "total count after --"$totalCountAfter;


#     if [ $totalCountBefore -ne $totalCountAfter];then
#         break;
#     fi 

# done