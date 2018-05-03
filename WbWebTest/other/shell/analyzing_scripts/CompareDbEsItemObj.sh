#!/bin/bash

tmpPath="/Users/huangwenbo/Documents/MachineLearning/auto_training/analyzing_scripts/ItemObjTmp/";
qitemid=$1;
citemid=$2;

qitemidEsItemOutputFileName=$tmpPath$qitemid"_esItemObj.txt";
qitemidDbItemOutputFileName=$tmpPath$qitemid"_dbItemObj.txt";

citemidEsItemOutputFileName=$tmpPath$citemid"_esItemObj.txt";
citemidDbItemOutputFileName=$tmpPath$citemid"_dbItemObj.txt";

/Users/huangwenbo/Documents/MachineLearning/auto_training/analyzing_scripts/getDbEsItemObj.sh $qitemid;
/Users/huangwenbo/Documents/MachineLearning/auto_training/analyzing_scripts/getDbEsItemObj.sh $citemid;


# echo -e "\n\033[31mesItemObj -- \033[0m\n";
# echo $esItemObj | jq '.';

# echo -e "\n\033[31mdbItemObj -- \033[0m\n";
# echo $dbItemObj | jq '.';

echo -e "\n\n\033[31m1.ES -- \033[0m\n";
echo -e "\n\n\033[31m1.1.Diff summary -- \033[0m\n";
diff -y -b -B --suppress-common-lines $qitemidEsItemOutputFileName $citemidEsItemOutputFileName;
echo -e "\n\n\033[31m1.2.Diff Details -- \033[0m\n";
diff -c -b -B --suppress-common-lines $qitemidEsItemOutputFileName $citemidEsItemOutputFileName;


echo -e "\n\n\033[31m2.DB -- \033[0m\n";
echo -e "\n\n\033[31m2.1.Diff summary -- \033[0m\n";
diff -y -b -B --suppress-common-lines $qitemidDbItemOutputFileName $citemidDbItemOutputFileName;
echo -e "\n\n\033[31m2.2.Diff Details -- \033[0m\n";
diff -c -b -B --suppress-common-lines $qitemidDbItemOutputFileName $citemidDbItemOutputFileName;