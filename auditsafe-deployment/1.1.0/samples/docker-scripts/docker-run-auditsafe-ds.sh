######################################################################
# Copyright © 2021. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash

AUDITSAFE_DS_BUILD_NUM=060
AUDITSAFE_DS_PORT=${AUDITSAFE_DS_PORT:-"6060"}

if [ "${DOCKER_REGISTRY}" = "" ]; then
	docker run --name auditsafe-ds --env-file=docker.env \
		-e log4j2.configurationFile=/usr/auditsafe-ds/secrets/log4j2.xml \
		-e truststore.jksFile=/usr/auditsafe-ds/certs/truststore.jks \
		-v ${LOG4J_FILE_PATH}:/usr/auditsafe-ds/secrets/log4j2.xml \
		-v ${TRUST_STORE_PATH}:/usr/auditsafe-ds/certs/truststore.jks \
		-d -p ${AUDITSAFE_DS_PORT}:6060 auditsafe-ds:${AUDITSAFE_DS_BUILD_NUM}
else
	docker run --name auditsafe-ds --env-file=docker.env \
		-e log4j2.configurationFile=/usr/auditsafe-ds/secrets/log4j2.xml \
		-e truststore.jksFile=/usr/auditsafe-ds/certs/truststore.jks \
		-v ${LOG4J_FILE_PATH}:/usr/auditsafe-ds/secrets/log4j2.xml \
		-v ${TRUST_STORE_PATH}:/usr/auditsafe-ds/certs/truststore.jks \
		-d -p ${AUDITSAFE_DS_PORT}:6060 ${DOCKER_REGISTRY}/auditsafe-ds:${AUDITSAFE_DS_BUILD_NUM}
fi

echo "###########################################################"
echo "Started the docker container of AUDITSAFE DataServer."
echo "###########################################################"

