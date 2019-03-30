#!/usr/bin/env bash

gradle_dependency=$1;
leaf_categoryIds=`echo $gradle_dependency | sed 's/group: /(/g' | sed 's/\/n/\)/g' | sed 's/name://g' | sed 's/version://g'| sed 's/'"'"/'"''/g'`;
echo $leaf_categoryIds")";
