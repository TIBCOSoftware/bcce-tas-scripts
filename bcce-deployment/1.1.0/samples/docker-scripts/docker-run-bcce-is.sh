######################################################################
# Copyright © 2020. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash

BCCE_IS_BUILD_NUM=069

source setenv.sh
if [ "${DOCKER_REGISTRY}" = "" ]; then
	docker run --name bcce-is --env-file=docker.env \
		-e log4j2.configurationFile=/usr/bcce-is/secrets/log4j2.xml \
		-e bcce.edi.config.dir=/usr/bcce-is/config \
		-v ${LOG4J_FILE_PATH}:/usr/bcce-is/secrets/log4j2.xml \
		-v ${FILE_POLLER_PATH}:${FILE_POLLER_PATH} \
		-d bcce-is:${BCCE_IS_BUILD_NUM}
else
	docker run --name bcce-is --env-file=docker.env \
		-e log4j2.configurationFile=/usr/bcce-is/secrets/log4j2.xml \
		-e bcce.edi.config.dir=/usr/bcce-is/config \
		-v ${LOG4J_FILE_PATH}:/usr/bcce-is/secrets/log4j2.xml \
		-v ${FILE_POLLER_PATH}:${FILE_POLLER_PATH} \
		-d ${DOCKER_REGISTRY}/bcce-is:${BCCE_IS_BUILD_NUM}
fi

echo "######################################################################"
echo "Started the docker container of BCCE Interior Server."
echo "######################################################################"
