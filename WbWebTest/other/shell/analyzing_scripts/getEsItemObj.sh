#!/bin/bash

itemId=$1;
itemObj=`curl -XGET 10.211.7.96:9200/product-spark/_search?q=itemId:$itemId | jq '.hits.hits[0]._source'`;



db_176_username="root";
db_176_password="123456789";
db_176_hostname="10.211.2.176";
db_176_schema="postdedup_matching";

get_db_item_sql="SELECT
       CONCAT('{\"categoryId\":', categoryId, ',\"brand\":\"', brandName, '\",\"manufacturer\":\"', manufacturer, '\",\"productName\":\"', productName, '\",\"items\":[{\"barcode\":\"', barcode, '\",\"salePrice\":', averageSalePrice, ',\"modelNo\":\"', modelName, '\",\"itemName\":\"', itemName, '\",\"itemImageUrl\":\"', itemImageUrl, '\",\"itemId\":', a.itemId, ',\"attributes\":[', b.attributes, ']}]}')
FROM postdedup_matching.tagged_items a
JOIN
    (SELECT GROUP_CONCAT('{\"attributeValueName\":\"', value, '\", \"attributeTypeName\":\"', TYPE, '\"}') AS attributes,
            itemid
     FROM postdedup_matching.tagged_item_attributes
     WHERE itemid IN ($itemId)
     GROUP BY itemid) AS b ON a.itemid = b.itemid;";

dbItemObj=`mysql -u$db_176_username -p$db_176_password -D$db_176_schema -h $db_176_hostname -N -e "$get_db_item_sql"`;


# echo $dbItemObj | jq '.items[0]' | jq 'keys';

# echo $itemObj;
 
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

esItemObj=`echo -e '{
  "categoryId": '$categoryId',
  "brand": '$brand',
  "manufacturer": '$manufacturer',
  "productName": '$productName',
  "items": [
    {
      "barcode": '$barcode',
      "salePrice": '$salePrice',
      "modelNo": '$modelNo',
      "itemName": '$itemName',
      "itemImageUrl": '$itemImageUrl',
      "itemId": '$itemId',
      "attributes": '$attributes'
    }
  ]
}'`;

echo "     From ES -- " > esItemObj.txt;
echo $esItemObj | jq '.' >> esItemObj.txt;
echo "     From DB -- " > dbItemObj.txt;
echo $dbItemObj | jq '.' >> dbItemObj.txt;


echo -e "\n\033[31mesItemObj -- \033[0m\n";
echo $esItemObj | jq '.';

echo -e "\n\033[31mdbItemObj -- \033[0m\n";
echo $dbItemObj | jq '.';

# comm -3 dbItemObj.txt esItemObj.txt;
# grep -vf esItemObj.txt dbItemObj.txt;

echo -e "\n\n\033[31m1.Diff summary -- \033[0m\n";

diff -y -b -B --suppress-common-lines esItemObj.txt dbItemObj.txt;

echo -e "\n\n\033[31m2.Diff Details -- \033[0m\n";

diff -c -b -B --suppress-common-lines esItemObj.txt dbItemObj.txt;
# diff -y --suppress-common-lines $dbItemObj $esItemObj;

