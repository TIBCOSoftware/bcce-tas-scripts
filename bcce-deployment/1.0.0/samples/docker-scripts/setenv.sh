#!/bin/bash
while IFS="=" read name val
do	
	if [ "$name" = "host_ip" ]; then \
		host_ip=$val
		continue;
	fi
	if [ "$name" = "auditsafe_host" ]; then \
		auditsafe_host=$val
		continue;
	fi
	if [ "$name" = "docker_repository" ]; then \
		docker_repository=$val
		continue;
	fi
	if [ "$name" = "mount_path" ]; then \
		mount_path=$val
		continue;
	fi
	if [ "$name" = "docker_username" ]; then \
		docker_username=$val
		continue;
	fi
	if [ "$name" = "gstoken_unzip" ]; then \
		gstoken_unzip=$val
		continue;
	fi
	if [ "$name" = "database_url" ]; then \
		database_url=$val
		continue;
	fi
	if [ "$name" = "database_driver" ]; then \
		database_driver=$val
		continue;
	fi
	if [ "$name" = "database_username" ]; then \
		database_username=$val
		continue;
	fi
	if [ "$name" = "database_password" ]; then \
		database_password=$val
		continue;
	fi
	if [ "$name" = "cms_show_sql" ]; then \
		cms_show_sql=$val
		continue;
	fi
	if [ "$name" = "cms_hikari_pool_size" ]; then \
		cms_hikari_pool_size=$val
		continue;
	fi
	if [ "$name" = "bcce_installation_prefix" ]; then \
		bcce_installation_prefix=$val
		continue;
	fi
	if [ "$name" = "bcce_installation_name" ]; then \
		bcce_installation_name=$val
		continue;
	fi
	if [ "$name" = "log4j2_file" ]; then \
		log4j2_file=$val
		continue;
	fi
	if [ "$name" = "host_key" ]; then \
		host_key=$val
		continue;
	fi
	if [ "$name" = "peer_cert" ]; then \
		peer_cert=$val
		continue;
	fi
	if [ "$name" = "gs_binding_mgmtport" ]; then \
		gs_binding_mgmtport=$val
		continue;
	fi
	if [ "$name" = "gs_binding_ddtpport" ]; then \
		gs_binding_ddtpport=$val
		continue;
	fi
	if [ "$name" = "gs_services" ]; then \
		gs_services=$val
		continue;
	fi
	if [ "$name" = "intercomp_props" ]; then \
		intercomp_props=$val
		continue;
	fi
	if [ "$name" = "as_port" ]; then \
		as_port=$val
		continue;
	fi
	if [ "$name" = "cms_port" ]; then \
		cms_port=$val
		continue;
	fi
	if [ "$name" = "is_port" ]; then \
		is_port=$val
		continue;
	fi
	if [ "$name" = "gs_port" ]; then \
		gs_port=$val
		continue;
	fi
	if [ "$name" = "gs_secure_port" ]; then \
		gs_secure_port=$val
		continue;
	fi
	if [ "$name" = "gs_secure_ca_port" ]; then \
		gs_secure_ca_port=$val
		continue;
	fi
	if [ "$name" = "auditsafe_ws_port" ]; then \
		auditsafe_ws_port=$val
		continue;
	fi
	if [ "$name" = "auditsafe_ds_port" ]; then \
		auditsafe_ds_port=$val
		continue;
	fi
	if [ "$name" = "as_replicas" ]; then \
		as_replicas=$val
		continue;
	fi
	if [ "$name" = "cms_replicas" ]; then \
		cms_replicas=$val
		continue;
	fi
	if [ "$name" = "ps_replicas" ]; then \
		ps_replicas=$val
		continue;
	fi
	if [ "$name" = "gs_replicas" ]; then \
		gs_replicas=$val
		continue;
	fi
	if [ "$name" = "is_replicas" ]; then \
		is_replicas=$val
		continue;
	fi
done < ../../config/deployment.properties

###################### Export for docker run ######################
# HOST can be set to hostname or machine ip (can't be set to localhost)
AUDITSAFE_HOST=${auditsafe_host//%host_ip%/$host_ip}
BCCE_HOST=$host_ip

if [ "$docker_repository" = "" ]; then
	echo "##############################################################################"
	echo "The docker_repository in deployment.properties must be set. Exit now!"
	echo "##############################################################################"
	echo
	exit 1
else
	export DOCKER_REGISTRY=$docker_repository
fi

# Check log4j2 file
if [[ ! $log4j2_file =~ ^/ ]]; then
    log4j2_file=../../$log4j2_file
    log4j2_file=`echo "$(cd "$(dirname "$log4j2_file")"; pwd)/$(basename "$log4j2_file")"`
fi
if [ ! -f $log4j2_file ]; then
    echo "##############################################################################"
    echo "The file $log4j2_file doesn't exist!"
    echo "##############################################################################"
    exit 1
else
	export LOG4J_FILE_PATH=$log4j2_file
fi

export FILE_POLLER_PATH=$mount_path
export BCCE_AS_PORT=$as_port
export BCCE_CMS_PORT=$cms_port
export BCCE_IS_PORT=$is_port
export BCCE_GS_PORT=$gs_port
export BCCE_GS_SECURE_PORT=$gs_secure_port
export BCCE_GS_SECURE_CA_PORT=$gs_secure_ca_port
export GS_TOKEN_PATH=$gstoken_unzip

###################### Replace the properties in docker.env ######################
cp docker.env.template docker.env
if [[ "$OSTYPE" =~ "linux" ]]; then
	sed -i "s/_AUDITSAFE_HOST_/${AUDITSAFE_HOST}/g" docker.env
	sed -i "s/_BCCE_HOST_/${BCCE_HOST}/g" docker.env
	sed -i "s/_CMS_PORT_/${cms_port}/g" docker.env
	
	#CMS properties
	sed -i "s/_DB_DRIVER_/${database_driver}/g" docker.env
	sed -i "s#_DB_URL_#${database_url}#g" docker.env
	sed -i "s/_DB_USERNAME_/${database_username}/g" docker.env
	sed -i "s/_DB_PASSWORD_/${database_password}/g" docker.env
	sed -i "s/_BCCE_INSTALLATION_PREFIX_/${bcce_installation_prefix}/g" docker.env
	sed -i "s/_BCCE_INSTALLATION_NAME_/${bcce_installation_name}/g" docker.env
	sed -i "s/_CMS_SHOW_SQL_/${cms_show_sql}/g" docker.env
	sed -i "s/_CMS_HIKARI_POOL_SIZE_/${cms_hikari_pool_size}/g" docker.env
	
	#AS properties
	sed -i "s/_AS_PORT_/${as_port}/g" docker.env
	sed -i "s/_AUDITSAFE_WS_PORT_/${auditsafe_ws_port}/g" docker.env

	#IS properties
	sed -i "s/_AUDITSAFE_DS_PORT_/${auditsafe_ds_port}/g" docker.env
	
	#PS only DB setting, already repalced
elif [[ "$OSTYPE" =~ "darwin" ]]; then
# MAC OS
	sed  -i "" "s/_AUDITSAFE_HOST_/${AUDITSAFE_HOST}/g" docker.env
	sed  -i "" "s/_BCCE_HOST_/${BCCE_HOST}/g" docker.env
	sed  -i "" "s/_CMS_PORT_/${cms_port}/g" docker.env
	
	#CMS properties
	sed  -i "" "s/_DB_DRIVER_/${database_driver}/g" docker.env
	sed  -i "" "s#_DB_URL_#${database_url}#g" docker.env
	sed  -i "" "s/_DB_USERNAME_/${database_username}/g" docker.env
	sed  -i "" "s/_DB_PASSWORD_/${database_password}/g" docker.env
	sed  -i "" "s/_BCCE_INSTALLATION_PREFIX_/${bcce_installation_prefix}/g" docker.env
	sed  -i "" "s/_BCCE_INSTALLATION_NAME_/${bcce_installation_name}/g" docker.env
	sed  -i "" "s/_CMS_SHOW_SQL_/${cms_show_sql}/g" docker.env
	sed  -i "" "s/_CMS_HIKARI_POOL_SIZE_/${cms_hikari_pool_size}/g" docker.env
	
	#AS properties
	sed  -i "" "s/_AS_PORT_/${as_port}/g" docker.env
	sed  -i "" "s/_AUDITSAFE_WS_PORT_/${auditsafe_ws_port}/g" docker.env

	#IS properties
	sed  -i "" "s/_AUDITSAFE_DS_PORT_/${auditsafe_ds_port}/g" docker.env
	
	#PS only DB setting, already repalced
fi

###################### Prepare for GS, the replacement of GS will be in docker-run-bcce-all.sh ######################
# String replacement
host_key=${host_key//%gstoken_unzip%/$gstoken_unzip}
peer_cert=${peer_cert//%gstoken_unzip%/$gstoken_unzip}
intercomp_props=${intercomp_props//%gstoken_unzip%/$gstoken_unzip}



