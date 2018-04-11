#!/bin/bash

db_username="root"
db_password="123456789"
db_hostname="10.211.2.176"
db_schema="postdedup_matching"

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
tmpFile=$filePath/"sqls_updating_categories"$dateOfToday".txt"
result_ouputfile=$filePath/$new_triggerid"_inspect_analysis_"$dateOfToday".csv"

# sql_string_result=""
declare -i start_qitemid=0

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
        mysql -u$product_db_username -p$product_db_password -D$product_db_schema -h $product_db_hostname --show-warnings=false -N -e "$1" >> $tmpFile;
        # sql_string_result=`mysql -u$product_db_username -p$product_db_password -D$product_db_schema -h $product_db_hostname --show-warnings=false -N -e "$1"`;
        # echo -e "str_sql: $1 -- \n $sql_string_result" >> $tmpFile;
    fi
}


function printCountToUpdate {
    execSqlOnPostDedupDB "select count(1) from pair_items_27 a where a.qitemid in ("$1");" $NUMBER_RESULT_FLAG;
}


function getQitemids {
    sql_get_itemids="SELECT GROUP_CONCAT(qItemId) FROM (SELECT distinct qItemId FROM pair_items_27 WHERE qitemid > $1 order by qitemid Limit 1000) a;";
    execSqlOnPostDedupDB "$sql_get_itemids" $STRING_RESULT_FLAG;
}


function getUpdateSqls {
    execSqlOnProductDB "select concat('update pair_items_27 set categoryId=',b.categoryid,' where qitemid=',a.itemid,';') from items a join products b on a.productid=b.productid where a.itemid in ("$1");";
}


declare -i returned_qitem_count=0

while [ true ]
do

    getQitemids $start_qitemid;
    qitemids=$sql_string_result;
    # echo "itemids --"$qitemids;

    if [ "$qitemids" =  "" -o "$qitemids" =  "NULL" ] ;then
        echo "no itemids returned, exit!"
        break;
    fi 

    # printCountToUpdate $qitemids;
    # updateCount=$sql_numeric_result;
    # echo "update count --"$updateCount;

    getUpdateSqls $qitemids;
    # updateSqls=$sql_string_result;
    # echo $updateSqls >> $tmpFile;

    # execSqlOnPostDedupDB "$updateSqls";

    returned_qitem_count=`echo $qitemids |tr -cd , |wc -c`+1;
    start_qitemid=`echo $qitemids | cut -d , -f $returned_qitem_count`;
    echo $start_qitemid;

    # getCategoryNullCount;
    # totalCountAfter=$sql_numeric_result;
    # echo "total count after --"$totalCountAfter;

done