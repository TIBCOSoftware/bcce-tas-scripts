######################################################################
# Copyright © 2021. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash

BCCE_AS_BUILD_NUM=069

source setenv.sh
if [ "${DOCKER_REGISTRY}" = "" ]; then
	docker run --name bcce-as --env-file=docker.env \
		-e log4j2_configurationFile=/usr/bcce-as/secrets/log4j2.json \
		-v ${LOG4J_FILE_PATH2}:/usr/bcce-as/secrets/log4j2.json \
		-d -p ${BCCE_AS_PORT}:${BCCE_AS_PORT} bcce-as:${BCCE_AS_BUILD_NUM}
else
	docker run --name bcce-as --env-file=docker.env \
		-e log4j2_configurationFile=/usr/bcce-as/secrets/log4j2.json \
		-v ${LOG4J_FILE_PATH2}:/usr/bcce-as/secrets/log4j2.json \
		-d -p ${BCCE_AS_PORT}:${BCCE_AS_PORT} ${DOCKER_REGISTRY}/bcce-as:${BCCE_AS_BUILD_NUM}
fi


echo "###########################################################"
echo "Started the docker container of BCCE AdminServer."
echo "###########################################################"
