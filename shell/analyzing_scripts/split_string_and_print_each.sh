#!/bin/bash

param=$1

        OLD_IFS="$IFS";
        IFS=",";
        arr=($param);
        IFS="$OLD_IFS";


for x in ${arr[@]}; do
  echo $x
done