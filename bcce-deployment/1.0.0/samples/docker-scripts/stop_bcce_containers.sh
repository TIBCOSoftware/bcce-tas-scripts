#!/bin/bash

for each in $(docker container ls -a|grep bcce-|awk '{print $1}');
do
	docker container rm -f $each
done
