#!/bin/bash

for each in $(docker container ls -a|grep auditsafe-|awk '{print $1}');
do
	docker container rm -f $each
done
