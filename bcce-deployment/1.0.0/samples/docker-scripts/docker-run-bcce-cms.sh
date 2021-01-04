#!/bin/bash

BCCE_CMS_BUILD_NUM=050

source setenv.sh
if [ "${DOCKER_REGISTRY}" = "" ]; then
	docker run --name bcce-cms --env-file=docker.env \
		-e log4j2.configurationFile=/usr/bcce-cms/secrets/log4j2.xml \
		-v ${LOG4J_FILE_PATH}:/usr/bcce-cms/secrets/log4j2.xml \
		-d -p ${BCCE_CMS_PORT}:6070 bcce-cms:${BCCE_CMS_BUILD_NUM}
else
	docker run --name bcce-cms --env-file=docker.env \
		-e log4j2.configurationFile=/usr/bcce-cms/secrets/log4j2.xml \
		-v ${LOG4J_FILE_PATH}:/usr/bcce-cms/secrets/log4j2.xml \
		-d -p ${BCCE_CMS_PORT}:6070 ${DOCKER_REGISTRY}/bcce-cms:${BCCE_CMS_BUILD_NUM}
fi

echo "######################################################################"
echo "Started the docker container of BCCE ConfigStore Management Server."
echo "######################################################################"
