#!/bin/bash

BCCE_AS_BUILD_NUM=050

source setenv.sh
if [ "${DOCKER_REGISTRY}" = "" ]; then
	docker run --name bcce-as --env-file=docker.env \
		-e log4j2.configurationFile=/usr/bcce-as/secrets/log4j2.xml \
		-v ${LOG4J_FILE_PATH}:/usr/bcce-as/secrets/log4j2.xml \
		-d -p ${BCCE_AS_PORT}:${BCCE_AS_PORT} bcce-as:${BCCE_AS_BUILD_NUM}
else
	docker run --name bcce-as --env-file=docker.env \
		-e log4j2.configurationFile=/usr/bcce-as/secrets/log4j2.xml \
		-v ${LOG4J_FILE_PATH}:/usr/bcce-as/secrets/log4j2.xml \
		-d -p ${BCCE_AS_PORT}:${BCCE_AS_PORT} ${DOCKER_REGISTRY}/bcce-as:${BCCE_AS_BUILD_NUM}
fi


echo "###########################################################"
echo "Started the docker container of BCCE AdminServer."
echo "###########################################################"
