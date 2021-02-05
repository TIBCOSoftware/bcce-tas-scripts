######################################################################
# Copyright © 2021. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash


for each in $(docker ps --format "{{.Names}}"|grep bcce-);
do
        if [[ "$each" =~ "bcce-aus" ]]; then
		while true; do
			echo "Do you want to stop TIBCO Auth Server docker container?"
			read -p "(y/n) " yn
			case $yn in
				[Yy]* ) stop_aus=yes; break;;
				[Nn]* ) break;;
				* ) echo "Please answer yes or no.";;
			esac
		done
		if [ "$stop_aus" = "yes" ]; then
			docker container rm -f $each
		fi
        else
                docker container rm -f $each
        fi
done


