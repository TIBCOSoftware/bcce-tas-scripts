######################################################################
# Copyright © 2021. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash

BCCE_GS_BUILD_NUM=069

source setenv.sh
if [ ! -f $intercomp_props ]; then
		echo "##############################################################################"
		echo "The file ${intercomp_props} doesn't exist."
		echo "The BCCE Gateway Server won't be installed!"
		echo "##############################################################################"
		echo
		exit 1
else
	# Check whether the files exist or not. 
	if [ "${host_key}" == "" ] || [ ! -f "${host_key}" ]; then
		echo "##############################################################################"
		echo "The file ${host_key} doesn't exist!"
		echo "##############################################################################"
		exit 1
	fi

	if [ "${peer_cert}" == "" ] || [ ! -f "${peer_cert}" ]; then
		echo "##############################################################################"
		echo "The file ${peer_cert} doesn't exist!"
		echo "##############################################################################"
		exit 1
	fi

	# Read in all the properties from the property file.
	while IFS="=" read name val
	do
		if [ "$name" = "gs.intercomp.installation.prefix" ]; then
			gs_intercomp_installation_prefix=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.installation.name" ]; then
			gs_intercomp_installation_name=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.jndi.url" ]; then
			gs_intercomp_jms_jndi_url=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.jndi.cf" ]; then
			gs_intercomp_jms_jndi_cf=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.jndi.user" ]; then
			gs_intercomp_jms_jndi_user=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.jndi.password" ]; then
			gs_intercomp_jms_jndi_password=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.qcf" ]; then
			gs_intercomp_jms_qcf=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.tcf" ]; then
			gs_intercomp_jms_tcf=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.user" ]; then
			gs_intercomp_jms_user=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.password" ]; then
			gs_intercomp_jms_password=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.reconnect.duration" ]; then
			gs_intercomp_jms_reconnect_duration=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.secure" ]; then
			gs_intercomp_jms_secure=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.verify.host" ]; then
			gs_intercomp_jms_verify_host=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.expected.host.name" ]; then
			gs_intercomp_jms_expected_host_name=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.strong.cipher.only" ]; then
			gs_intercomp_jms_strong_cipher_only=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.use.trace" ]; then
			gs_intercomp_jms_use_trace=$val
			continue;
		fi
	done < $intercomp_props
	
	if [[ "$OSTYPE" =~ "linux" ]]; then
		sed -i "s/_GS_BINDING_MGMTPORT_/${gs_binding_mgmtport}/g" docker.env
		sed -i "s/_GS_BINDING_DDTPORT_/${gs_binding_ddtpport}/g" docker.env
		sed -i "s/_GS_SERVICES_/${gs_services}/g" docker.env
		sed -i "s/_BCCE_INSTALLATION_PREFIX_/${bcce_installation_prefix}/g" docker.env
		sed -i "s/_BCCE_INSTALLATION_PREFIX_/${bcce_installation_prefix}/g" docker.env
		sed -i "s/_BCCE_INSTALLATION_NAME_/${bcce_installation_name}/g" docker.env
		sed -i "s/_GS_INTERCOMP_JMS_USER_/${gs_intercomp_jms_user}/g" docker.env
		sed -i "s/_GS_INTERCOMP_JMS_QCF_/${gs_intercomp_jms_qcf}/g" docker.env
		sed -i "s/_GS_INTERCOMP_JMS_JNDI_PASSWORD_/${gs_intercomp_jms_jndi_password}/g" docker.env
		sed -i "s/_GS_INTERCOMP_JMS_USE_TRACE_/${gs_intercomp_jms_use_trace}/g" docker.env
		sed -i "s/_GS_INTERCOMP_INSTALLATION_PREFIX_/${gs_intercomp_installation_prefix}/g" docker.env
		sed -i "s/_GS_INTERCOMP_JMS_VERIFY_HOST_/${gs_intercomp_jms_verify_host}/g" docker.env
		sed -i "s/_GS_INTERCOMP_JMS_STRONG_CIPHER_ONLY_/${gs_intercomp_jms_strong_cipher_only}/g" docker.env
		sed -i "s/_GS_INTERCOMP_JMS_PASSWORD_/${gs_intercomp_jms_password}/g" docker.env
		sed -i "s/_GS_INTERCOMP_JMS_RECONNECT_DURATION_/${gs_intercomp_jms_reconnect_duration}/g" docker.env
		sed -i "s/_GS_INTERCOMP_JMS_TCF_/${gs_intercomp_jms_tcf}/g" docker.env
		sed -i "s/_GS_INTERCOMP_JMS_SECURE_/${gs_intercomp_jms_secure}/g" docker.env
		sed -i "s#_GS_INTERCOMP_JMS_JNDI_URL_#${gs_intercomp_jms_jndi_url}#g" docker.env
		sed -i "s/_GS_INTERCOMP_JMS_JNDI_USER_/${gs_intercomp_jms_jndi_user}/g" docker.env
		sed -i "s/_GS_INTERCOMP_JMS_JNDI_CF_/${gs_intercomp_jms_jndi_cf}/g" docker.env
		sed -i "s/_GS_INTERCOMP_INSTALLATION_NAME_/${gs_intercomp_installation_name}/g" docker.env
		sed -i "s/_GS_INTERCOMP_JMS_EXPECTED_HOST_NAME_/${gs_intercomp_jms_expected_host_name}/g" docker.env
	elif [[ "$OSTYPE" =~ "darwin" ]]; then
	# MAC OS
		sed -i "" "s/_GS_BINDING_MGMTPORT_/${gs_binding_mgmtport}/g" docker.env
		sed -i "" "s/_GS_BINDING_DDTPORT_/${gs_binding_ddtpport}/g" docker.env
		sed -i "" "s/_GS_SERVICES_/${gs_services}/g" docker.env
		sed -i "" "s/_BCCE_INSTALLATION_PREFIX_/${bcce_installation_prefix}/g" docker.env
		sed -i "" "s/_BCCE_INSTALLATION_PREFIX_/${bcce_installation_prefix}/g" docker.env
		sed -i "" "s/_BCCE_INSTALLATION_NAME_/${bcce_installation_name}/g" docker.env
		sed -i "" "s/_GS_INTERCOMP_JMS_USER_/${gs_intercomp_jms_user}/g" docker.env
		sed -i "" "s/_GS_INTERCOMP_JMS_QCF_/${gs_intercomp_jms_qcf}/g" docker.env
		sed -i "" "s/_GS_INTERCOMP_JMS_JNDI_PASSWORD_/${gs_intercomp_jms_jndi_password}/g" docker.env
		sed -i "" "s/_GS_INTERCOMP_JMS_USE_TRACE_/${gs_intercomp_jms_use_trace}/g" docker.env
		sed -i "" "s/_GS_INTERCOMP_INSTALLATION_PREFIX_/${gs_intercomp_installation_prefix}/g" docker.env
		sed -i "" "s/_GS_INTERCOMP_JMS_VERIFY_HOST_/${gs_intercomp_jms_verify_host}/g" docker.env
		sed -i "" "s/_GS_INTERCOMP_JMS_STRONG_CIPHER_ONLY_/${gs_intercomp_jms_strong_cipher_only}/g" docker.env
		sed -i "" "s/_GS_INTERCOMP_JMS_PASSWORD_/${gs_intercomp_jms_password}/g" docker.env
		sed -i "" "s/_GS_INTERCOMP_JMS_RECONNECT_DURATION_/${gs_intercomp_jms_reconnect_duration}/g" docker.env
		sed -i "" "s/_GS_INTERCOMP_JMS_TCF_/${gs_intercomp_jms_tcf}/g" docker.env
		sed -i "" "s/_GS_INTERCOMP_JMS_SECURE_/${gs_intercomp_jms_secure}/g" docker.env
		sed -i "" "s#_GS_INTERCOMP_JMS_JNDI_URL_#${gs_intercomp_jms_jndi_url}#g" docker.env
		sed -i "" "s/_GS_INTERCOMP_JMS_JNDI_USER_/${gs_intercomp_jms_jndi_user}/g" docker.env
		sed -i "" "s/_GS_INTERCOMP_JMS_JNDI_CF_/${gs_intercomp_jms_jndi_cf}/g" docker.env
		sed -i "" "s/_GS_INTERCOMP_INSTALLATION_NAME_/${gs_intercomp_installation_name}/g" docker.env
		sed -i "" "s/_GS_INTERCOMP_JMS_EXPECTED_HOST_NAME_/${gs_intercomp_jms_expected_host_name}/g" docker.env
	fi	
fi

if [ "${DOCKER_REGISTRY}" = "" ]; then
	docker run --name bcce-gs --env-file=docker.env \
		-e log4j2.configurationFile=/usr/bcce-gs/secrets/log4j2.xml \
		-v ${LOG4J_FILE_PATH}:/usr/bcce-gs/secrets/log4j2.xml \
		-v ${GS_TOKEN_PATH}:/usr/bcce-gs/gsconfig \
		-d -p ${BCCE_GS_PORT}:6700 \
		-p ${BCCE_GS_SECURE_PORT}:6705 -p ${BCCE_GS_SECURE_CA_PORT}:6707 \
		bcce-gs:${BCCE_GS_BUILD_NUM}
else
	docker run --name bcce-gs --env-file=docker.env \
		-e log4j2.configurationFile=/usr/bcce-gs/secrets/log4j2.xml \
		-v ${LOG4J_FILE_PATH}:/usr/bcce-gs/secrets/log4j2.xml \
		-v ${GS_TOKEN_PATH}:/usr/bcce-gs/gsconfig \
		-d -p ${BCCE_GS_PORT}:6700 \
		-p ${BCCE_GS_SECURE_PORT}:6705 -p ${BCCE_GS_SECURE_CA_PORT}:6707 \
		${DOCKER_REGISTRY}/bcce-gs:${BCCE_GS_BUILD_NUM}
fi

echo "######################################################################"
echo "Started the docker container of BCCE Gateway Server."
echo "######################################################################"

exit	


