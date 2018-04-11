#!/bin/bash

triggerid=$1

rm -rf /home/matching_analysis/result/*

docker exec b3365a58d7ce bash /db_temp/get_merge_pair_items.sh $triggerid
docker cp b3365a58d7ce:/db_temp/inspection_analysis/ /home/matching_analysis/result


# /home/matching_analysis/get_merge_pair_items.sh