#!/bin/bash

itemId=$1;
cnt=$2;

while [[ $cnt -ge 0 ]]
do
    itemObj=`curl -XGET 10.211.7.96:9200/product-spark/_search?q=itemId:$itemId | jq '.hits.hits[0]._source'`;
    categoryId=`echo $itemObj | jq '.categoryId'`;
    brand=`echo $itemObj | jq '.brandName'`;
    manufacturer=`echo $itemObj | jq '.manufacturer'`;
    productName=`echo $itemObj | jq '.productName'`;
    barcode=`echo $itemObj | jq '.barcode'`;
    salePrice=`echo $itemObj | jq '.averageSalePrice'`;
    modelNo=`echo $itemObj | jq '.modelName'`;
    itemName=`echo $itemObj | jq '.itemName'`;
    itemImageUrl=`echo $itemObj | jq '.itemImageUrl'`;
    attributes=`echo $itemObj | jq '.attributes' | sed 's/value/attributeValueName/g' | sed 's/key/attributeTypeName/g'`;

    echo $attributes >> ${itemId}".txt";

    cnt=$[cnt-1];
done