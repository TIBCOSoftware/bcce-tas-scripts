######################################################################
# Copyright © 2021. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash

while IFS="=" read name val
do	
	if [ "$name" = "host_ip" ]; then \
		host_ip=$val
		continue;
	fi
	if [ "$name" = "auditsafe_ds_host" ]; then \
		auditsafe_ds_host=$val
		continue;
	fi
	if [ "$name" = "docker_repository" ]; then \
		docker_repository=$val
		continue;
	fi
	if [ "$name" = "docker_username" ]; then \
		docker_username=$val
		continue;
	fi
	if [ "$name" = "auditsafe_ds_port" ]; then \
		auditsafe_ds_port=$val
		continue;
	fi
done < ../../config/deployment.properties

###################### Export for docker run ######################
# HOST can be set to hostname or machine ip (can't be set to localhost)
AUDITSAFE_DS_HOST=${auditsafe_ds_host//%host_ip%/$host_ip}
BCCE_HOST=$host_ip

if [ "$docker_repository" = "" ]; then
	echo "##############################################################################"
	echo "The docker_repository in deployment.properties must be set. Exit now!"
	echo "##############################################################################"
	echo
	exit 1
else
	export DOCKER_REGISTRY=$docker_repository
fi

###################### Replace the properties in docker.env ######################
cp docker.env.template docker.env
if [[ "$OSTYPE" =~ "linux" ]]; then
	sed -i "s/_AUDITSAFE_DS_HOST_/${AUDITSAFE_DS_HOST}/g" docker.env
	sed -i "s/_AUDITSAFE_DS_PORT_/${auditsafe_ds_port}/g" docker.env
	sed -i "s/_BCCE_HOST_/${BCCE_HOST}/g" docker.env
elif [[ "$OSTYPE" =~ "darwin" ]]; then
# MAC OS
	sed -i "" "s/_AUDITSAFE_DS_HOST_/${AUDITSAFE_DS_HOST}/g" docker.env
	sed -i "" "s/_AUDITSAFE_DS_PORT_/${auditsafe_ds_port}/g" docker.env
	sed -i "" "s/_BCCE_HOST_/${BCCE_HOST}/g" docker.env
fi


