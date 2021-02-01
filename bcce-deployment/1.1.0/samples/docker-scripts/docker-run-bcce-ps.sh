######################################################################
# Copyright © 2020. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash

BCCE_PS_BUILD_NUM=069

source setenv.sh
if [ "${DOCKER_REGISTRY}" = "" ]; then
	docker run --name bcce-ps --env-file=docker.env \
		-e log4j2.configurationFile=/usr/bcce-ps/secrets/log4j2.xml \
		-v ${LOG4J_FILE_PATH}:/usr/bcce-ps/secrets/log4j2.xml \
		-v ${FILE_POLLER_PATH}:${FILE_POLLER_PATH} \
		-d bcce-ps:${BCCE_PS_BUILD_NUM}
else
	docker run --name bcce-ps --env-file=docker.env \
		-e log4j2.configurationFile=/usr/bcce-ps/secrets/log4j2.xml \
		-v ${LOG4J_FILE_PATH}:/usr/bcce-ps/secrets/log4j2.xml \
		-v ${FILE_POLLER_PATH}:${FILE_POLLER_PATH} \
		-d ${DOCKER_REGISTRY}/bcce-ps:${BCCE_PS_BUILD_NUM}
fi

echo "######################################################################"
echo "Started the docker container of BCCE Poller Server."
echo "######################################################################"
