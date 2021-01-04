#!/bin/bash

AUDITSAFE_WS_BUILD_NUM=038
AUDITSAFE_WS_PORT=${AUDITSAFE_WS_PORT:-"7070"}

if [ "${DOCKER_REGISTRY}" = "" ]; then
	docker run --name auditsafe-ws --env-file=docker.env \
		-e log4j2.configurationFile=/usr/auditsafe-ws/secrets/log4j2.xml \
		-e truststore.jksFile=/usr/auditsafe-ws/certs/truststore.jks \
		-v ${LOG4J_FILE_PATH}:/usr/auditsafe-ws/secrets/log4j2.xml \
		-v ${TRUST_STORE_PATH}:/usr/auditsafe-ws/certs/truststore.jks \
		-d -p ${AUDITSAFE_WS_PORT}:7070 auditsafe-ws:${AUDITSAFE_WS_BUILD_NUM}
else
	docker run --name auditsafe-ws --env-file=docker.env \
		-e log4j2.configurationFile=/usr/auditsafe-ws/secrets/log4j2.xml \
		-e truststore.jksFile=/usr/auditsafe-ws/certs/truststore.jks \
		-v ${LOG4J_FILE_PATH}:/usr/auditsafe-ws/secrets/log4j2.xml \
		-v ${TRUST_STORE_PATH}:/usr/auditsafe-ws/certs/truststore.jks \
		-d -p ${AUDITSAFE_WS_PORT}:7070 ${DOCKER_REGISTRY}/auditsafe-ws:${AUDITSAFE_WS_BUILD_NUM}
fi

echo "###########################################################"
echo "Started the docker container of AUDITSAFE WebServer."
echo "###########################################################"
