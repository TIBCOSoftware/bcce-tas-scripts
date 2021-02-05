######################################################################
# Copyright © 2021. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash

BCCE_AUS_BUILD_NUM=069

source setenv.sh
if [ "${DOCKER_REGISTRY}" = "" ]; then
	docker run --name bcce-aus --env-file=docker.env \
		-e log4j2.configurationFile=/usr/bcce-aus/secrets/log4j2.xml \
		-v ${LOG4J_FILE_PATH}:/usr/bcce-aus/secrets/log4j2.xml \
		-d -p ${BCCE_AUS_PORT}:5050 bcce-aus:${BCCE_AUS_BUILD_NUM}
else
	docker run --name bcce-aus --env-file=docker.env \
		-e log4j2.configurationFile=/usr/bcce-aus/secrets/log4j2.xml \
		-v ${LOG4J_FILE_PATH}:/usr/bcce-aus/secrets/log4j2.xml \
		-d -p ${BCCE_AUS_PORT}:5050 ${DOCKER_REGISTRY}/bcce-aus:${BCCE_AUS_BUILD_NUM}
fi

echo "######################################################################"
echo "Started the docker container of Auth Server."
echo "######################################################################"
