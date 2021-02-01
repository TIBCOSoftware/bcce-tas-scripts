######################################################################
# Copyright © 2020. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash

BCCE_CMS_BUILD_NUM=069

source setenv.sh
if [ "${DOCKER_REGISTRY}" = "" ]; then
	docker run --name bcce-cms --env-file=docker.env \
		-e log4j2.configurationFile=/usr/bcce-cms/secrets/log4j2.xml \
		-e bcce.edi.config.dir=/usr/bcce-cms/config \
		-v ${LOG4J_FILE_PATH}:/usr/bcce-cms/secrets/log4j2.xml \
		-d -p 30001:6070 bcce-cms:${BCCE_CMS_BUILD_NUM}
else
	docker run --name bcce-cms --env-file=docker.env \
		-e log4j2.configurationFile=/usr/bcce-cms/secrets/log4j2.xml \
		-e bcce.edi.config.dir=/usr/bcce-cms/config \
		-v ${LOG4J_FILE_PATH}:/usr/bcce-cms/secrets/log4j2.xml \
		-d -p 30001:6070 ${DOCKER_REGISTRY}/bcce-cms:${BCCE_CMS_BUILD_NUM}
fi

echo "######################################################################"
echo "Started the docker container of BCCE ConfigStore Management Server."
echo "######################################################################"
