######################################################################
# Copyright © 2020. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash

while IFS="=" read name val
do
	if [ "$name" = "host_ip" ]; then \
		host_ip=$val
		continue;
	fi
	if [ "$name" = "docker_repository" ]; then \
		export DOCKER_REGISTRY=$val
		continue;
	fi
	if [ "$name" = "log4j2_file" ]; then \
		log4j2_file=$val
		if [[ ! $log4j2_file =~ ^/ ]]; then
		    log4j2_file=../../$log4j2_file
		    log4j2_file=`echo "$(cd "$(dirname "$log4j2_file")"; pwd)/$(basename "$log4j2_file")"`
		fi
		export LOG4J_FILE_PATH=$log4j2_file
		continue;
	fi
	if [ "$name" = "elasticsearch_keystore" ]; then \
		elasticsearch_keystore=$val
		if [[ ! $elasticsearch_keystore =~ ^/ ]]; then
		    elasticsearch_keystore=../../$elasticsearch_keystore
		    elasticsearch_keystore=`echo "$(cd "$(dirname "$elasticsearch_keystore")"; pwd)/$(basename "$elasticsearch_keystore")"`
		fi
		export TRUST_STORE_PATH=$elasticsearch_keystore
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
	
	if [ "$name" = "elasticsearch_host" ]; then \
		elasticsearch_host=$val
		continue;
	fi
	if [ "$name" = "elasticsearch_host" ]; then \
		elasticsearch_host=$val
		continue;
	fi
	if [ "$name" = "elasticsearch_port" ]; then \
		elasticsearch_port=$val
		continue;
	fi
	if [ "$name" = "elasticsearch_username" ]; then \
		elasticsearch_username=$val
		continue;
	fi
	if [ "$name" = "elasticsearch_password" ]; then \
		elasticsearch_password=$val
		continue;
	fi
	if [ "$name" = "elasticsearch_keystore_password" ]; then \
		elasticsearch_keystore_password=$val
		continue;
	fi
	if [ "$name" = "elasticsearch_type" ]; then \
		elasticsearch_type=$val
		continue;
	fi
	if [ "$name" = "elasticsearch_schema" ]; then \
		elasticsearch_schema=$val
		continue;
	fi
	if [ "$name" = "ws_port" ]; then \
		ws_port=$val
		continue;
	fi
	if [ "$name" = "ds_port" ]; then \
		ds_port=$val
		continue;
	fi
	if [ "$name" = "ds_host" ]; then \
		ds_host=$val
		continue;
	fi
	if [ "$name" = "aus_host" ]; then \
		aus_host=$val
		continue;
	fi
	if [ "$name" = "aus_port" ]; then \
		aus_port=$val
		continue;
	fi
	if [ "$name" = "aus_database_url" ]; then \
		aus_database_url=$val
		continue;
	fi
	if [ "$name" = "aus_database_username" ]; then \
		aus_database_username=$val
		continue;
	fi
	if [ "$name" = "aus_database_password" ]; then \
		aus_database_password=$val
		continue;
	fi
	if [ "$name" = "aus_show_sql" ]; then \
		aus_show_sql=$val
		continue;
	fi
	if [ "$name" = "aus_hikari_pool_size" ]; then \
		aus_hikari_pool_size=$val
		continue;
	fi
	if [ "$name" = "aus_swagger_enabled" ]; then \
		aus_swagger_enabled=$val
		continue;
	fi
done < ../../config/deployment.properties

export AUDITSAFE_WS_PORT=$ws_port
export AUDITSAFE_DS_PORT=$ds_port
export BCCE_AUS_PORT=$aus_port
aus_database_username=${aus_database_username//%database_username%/$database_username}
aus_database_password=${aus_database_password//%database_password%/$database_password}
aus_host=${aus_host//%host_ip%/$host_ip}
ds_host=${ds_host//%host_ip%/$host_ip}

cp docker.env.template docker.env

if [[ "$OSTYPE" =~ "linux" ]]; then
	sed -i  "s/_ds_host_/${ds_host}/g" docker.env
	sed -i  "s/_ds_port_/${ds_port}/g" docker.env
	sed -i  "s/_aus_host_/${aus_host}/g" docker.env
	sed -i  "s/_aus_port_/${aus_port}/g" docker.env
	sed -i  "s#_aus_database_url_#${aus_database_url}#g" docker.env
	sed -i  "s/_aus_database_username_/${aus_database_username}/g" docker.env
	sed -i  "s/_aus_database_password_/${aus_database_password}/g" docker.env
	sed -i  "s/_aus_database_driver_/${database_driver}/g" docker.env
	sed -i  "s/_database_driver_/${database_driver}/g" docker.env
	sed -i  "s#_database_url_#${database_url}#g" docker.env
	sed -i  "s/_database_username_/${database_username}/g" docker.env
	sed -i  "s/_database_password_/${database_password}/g" docker.env
	
	sed -i  "s/_elasticsearch_host_/${elasticsearch_host}/g" docker.env
	sed -i  "s/_elasticsearch_port_/${elasticsearch_port}/g" docker.env
	sed -i  "s/_elasticsearch_username_/${elasticsearch_username}/g" docker.env
	sed -i  "s/_elasticsearch_password_/${elasticsearch_password}/g" docker.env
	sed -i  "s/_elasticsearch_keystore_password_/${elasticsearch_keystore_password}/g" docker.env
	sed -i  "s/_elasticsearch_type_/${elasticsearch_type}/g" docker.env
	sed -i  "s/_elasticsearch_schema_/${elasticsearch_schema}/g" docker.env

	#AUS properties
	sed -i "s/_aus_show_sql_/${aus_show_sql}/g" docker.env
	sed -i "s/_aus_hikari_pool_size_/${aus_hikari_pool_size}/g" docker.env
	sed -i "s/_aus_swagger_enabled_/${aus_swagger_enabled}/g" docker.env

	sed -i  "s#_log4j2_file_#${log4j2_file}#g" docker.env
elif [[ "$OSTYPE" =~ "darwin" ]]; then
	sed -i  "" "s/_ds_host_/${ds_host}/g" docker.env
	sed -i  "" "s/_ds_port_/${ds_port}/g" docker.env
	sed -i  "" "s/_aus_host_/${aus_host}/g" docker.env
	sed -i  "" "s/_aus_port_/${aus_port}/g" docker.env
	sed -i  "" "s#_aus_database_url_#${aus_database_url}#g" docker.env
	sed -i  "" "s/_aus_database_username_/${aus_database_username}/g" docker.env
	sed -i  "" "s/_aus_database_password_/${aus_database_password}/g" docker.env
	sed -i  "" "s/_aus_database_driver_/${database_driver}/g" docker.env
	sed -i  "" "s/_database_driver_/${database_driver}/g" docker.env
	sed -i  "" "s#_database_url_#${database_url}#g" docker.env
	sed -i  "" "s/_database_username_/${database_username}/g" docker.env
	sed -i  "" "s/_database_password_/${database_password}/g" docker.env
	
	sed -i  "" "s/_elasticsearch_host_/${elasticsearch_host}/g" docker.env
	sed -i  "" "s/_elasticsearch_port_/${elasticsearch_port}/g" docker.env
	sed -i  "" "s/_elasticsearch_username_/${elasticsearch_username}/g" docker.env
	sed -i  "" "s/_elasticsearch_password_/${elasticsearch_password}/g" docker.env
	sed -i  "" "s/_elasticsearch_keystore_password_/${elasticsearch_keystore_password}/g" docker.env
	sed -i  "" "s/_elasticsearch_type_/${elasticsearch_type}/g" docker.env
	sed -i  "" "s/_elasticsearch_schema_/${elasticsearch_schema}/g" docker.env
	
	#AUS properties
	sed -i  "" "s/_aus_show_sql_/${aus_show_sql}/g" docker.env
	sed -i  "" "s/_aus_hikari_pool_size_/${aus_hikari_pool_size}/g" docker.env
	sed -i  "" "s/_aus_swagger_enabled_/${aus_swagger_enabled}/g" docker.env

	sed -i  "" "s#_log4j2_file_#${log4j2_file}#g" docker.env
fi
