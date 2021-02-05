######################################################################
# Copyright © 2021. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash

for each in $(docker container ls -a|grep auditsafe-|awk '{print $1}');
do
	docker container rm -f $each
done

found_aus=`docker ps --format "{{.Names}}"|grep bcce-aus`
if [ ! "$found_aus" = "" ]; then
	while true; do
		echo "Do you want to undeploy TIBCO Auth Server service?"
		read -p "(y/n) " yn
		case $yn in
			[Yy]* ) remove_aus=yes; break;;
			[Nn]* ) break;;
			* ) echo "Please answer yes or no.";;
		esac
	done

	if [ "$remove_aus" = "yes" ]; then
		docker container rm -f bcce-aus
	fi
fi
