######################################################################
# Copyright © 2021. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash

# Set the default values
cms_swagger_enabled=false
bc_configstore_dbstore_cache_disable_for_qa_automation=false

while IFS="=" read name val
do	
	if [ "$name" = "host_ip" ]; then \
		host_ip=$val
		continue;
	fi
	if [ "$name" = "auditsafe_ws_host" ]; then \
		auditsafe_ws_host=$val
		continue;
	fi
	if [ "$name" = "auditsafe_ds_host" ]; then \
		auditsafe_ds_host=$val
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
	if [ "$name" = "cms_show_sql" ]; then \
		cms_show_sql=$val
		continue;
	fi
	if [ "$name" = "cms_hikari_pool_size" ]; then \
		cms_hikari_pool_size=$val
		continue;
	fi
	if [ "$name" = "cms_swagger_enabled" ]; then \
		cms_swagger_enabled=$val
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
	if [ "$name" = "log4j2_json_file" ]; then \
		log4j2_json_file=$val
		continue;
	fi
	if [ "$name" = "log4j2_file" ]; then \
		log4j2_file=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_engines" ]; then \
		bcce_poller_engines=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_ib_email_instances" ]; then \
		bcce_poller_ib_email_instances=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_ib_email_refresh_rate" ]; then \
		bcce_poller_ib_email_refresh_rate=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_ib_email_weight" ]; then \
		bcce_poller_ib_email_weight=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_ib_file_instances" ]; then \
		bcce_poller_ib_file_instances=$val
		continue;
	fi

	if [ "$name" = "bcce_poller_ib_file_refresh_rate" ]; then \
		bcce_poller_ib_file_refresh_rate=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_ib_file_weight" ]; then \
		bcce_poller_ib_file_weight=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_ob_file_instances" ]; then \
		bcce_poller_ob_file_instances=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_ob_file_refresh_rate" ]; then \
		bcce_poller_ob_file_refresh_rate=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_ob_file_weight" ]; then \
		bcce_poller_ob_file_weight=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_ib_ftp_instances" ]; then \
		bcce_poller_ib_ftp_instances=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_ib_ftp_refresh_rate" ]; then \
		bcce_poller_ib_ftp_refresh_rate=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_ib_ftp_weight" ]; then \
		bcce_poller_ib_ftp_weight=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_internal_mdn_instances" ]; then \
		bcce_poller_internal_mdn_instances=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_internal_mdn_refresh_rate" ]; then \
		bcce_poller_internal_mdn_refresh_rate=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_internal_mdn_weight" ]; then \
		bcce_poller_internal_mdn_weight=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_internal_schd_instances" ]; then \
		bcce_poller_internal_schd_instances=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_internal_schd_refresh_rate" ]; then \
		bcce_poller_internal_schd_refresh_rate=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_internal_schd_weight" ]; then \
		bcce_poller_internal_schd_weight=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_internal_resend_instances" ]; then \
		bcce_poller_internal_resend_instances=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_internal_resend_refresh_rate" ]; then \
		bcce_poller_internal_resend_refresh_rate=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_internal_resend_weight" ]; then \
		bcce_poller_internal_resend_weight=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_internal_hiber_instances" ]; then \
		bcce_poller_internal_hiber_instances=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_internal_hiber_refresh_rate" ]; then \
		bcce_poller_internal_hiber_refresh_rate=$val
		continue;
	fi
	if [ "$name" = "bcce_poller_internal_hiber_weight" ]; then \
		bcce_poller_internal_hiber_weight=$val
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
	if [ "$name" = "bc_configstore_dbstore_cache_disable_for_qa_automation" ]; then \
		bc_configstore_dbstore_cache_disable_for_qa_automation=$val
		continue;
	fi
done < ../../config/deployment.properties

###################### Export for docker run ######################
# HOST can be set to hostname or machine ip (can't be set to localhost)
AUDITSAFE_WS_HOST=${auditsafe_ws_host//%host_ip%/$host_ip}
AUDITSAFE_DS_HOST=${auditsafe_ds_host//%host_ip%/$host_ip}
AUS_HOST=${aus_host//%host_ip%/$host_ip}
aus_database_username=${aus_database_username//%database_username%/$database_username}
aus_database_password=${aus_database_password//%database_password%/$database_password}
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
    log4j2_json_file=../../$log4j2_json_file
    log4j2_json_file=`echo "$(cd "$(dirname "$log4j2_json_file")"; pwd)/$(basename "$log4j2_json_file")"`
fi
if [ ! -f $log4j2_file ]; then
    echo "##############################################################################"
    echo "The file $log4j2_file doesn't exist!"
    echo "##############################################################################"
    exit 1
else
	export LOG4J_FILE_PATH=$log4j2_file
	export LOG4J_FILE_PATH2=$log4j2_json_file
fi

export FILE_POLLER_PATH=$mount_path
export BCCE_AUS_PORT=$aus_port
export BCCE_AS_PORT=$as_port
export BCCE_IS_PORT=$is_port
export BCCE_GS_PORT=$gs_port
export BCCE_GS_SECURE_PORT=$gs_secure_port
export BCCE_GS_SECURE_CA_PORT=$gs_secure_ca_port
export GS_TOKEN_PATH=$gstoken_unzip

###################### Replace the properties in docker.env ######################
cp docker.env.template docker.env
if [[ "$OSTYPE" =~ "linux" ]]; then
	sed -i "s/_AUDITSAFE_WS_HOST_/${AUDITSAFE_WS_HOST}/g" docker.env
	sed -i "s/_AUDITSAFE_DS_HOST_/${AUDITSAFE_DS_HOST}/g" docker.env
	sed -i "s/_BCCE_HOST_/${BCCE_HOST}/g" docker.env
	
	#AUS properties
	sed -i "s/_DB_DRIVER_/${database_driver}/g" docker.env
	sed -i "s#_AUS_DB_URL_#${aus_database_url}#g" docker.env
	sed -i "s/_AUS_DB_USERNAME_/${aus_database_username}/g" docker.env
	sed -i "s/_AUS_DB_PASSWORD_/${aus_database_password}/g" docker.env
	sed -i "s/_AUS_SHOW_SQL_/${aus_show_sql}/g" docker.env
	sed -i "s/_AUS_HIKARI_POOL_SIZE_/${aus_hikari_pool_size}/g" docker.env
	sed -i "s/_AUS_SWAGGER_ENABLED_/${aus_swagger_enabled}/g" docker.env

	#CMS properties
	sed -i "s/_DB_DRIVER_/${database_driver}/g" docker.env
	sed -i "s#_DB_URL_#${database_url}#g" docker.env
	sed -i "s/_DB_USERNAME_/${database_username}/g" docker.env
	sed -i "s/_DB_PASSWORD_/${database_password}/g" docker.env
	sed -i "s/_BCCE_INSTALLATION_PREFIX_/${bcce_installation_prefix}/g" docker.env
	sed -i "s/_BCCE_INSTALLATION_NAME_/${bcce_installation_name}/g" docker.env
	sed -i "s/_CMS_SHOW_SQL_/${cms_show_sql}/g" docker.env
	sed -i "s/_CMS_HIKARI_POOL_SIZE_/${cms_hikari_pool_size}/g" docker.env
	sed -i "s/_CMS_SWAGGER_ENABLED_/${cms_swagger_enabled}/g" docker.env
	sed -i "s/_AUS_HOST_/${AUS_HOST}/g" docker.env
	sed -i "s/_AUS_PORT_/${BCCE_AUS_PORT}/g" docker.env
	sed -i "s/_CONFIGSTORE_QA_AUTOMATION_/${bc_configstore_dbstore_cache_disable_for_qa_automation}/g" docker.env
	
	#AS properties
	sed -i "s/_AS_PORT_/${as_port}/g" docker.env
	sed -i "s/_AUDITSAFE_WS_PORT_/${auditsafe_ws_port}/g" docker.env

	#IS properties
	sed -i "s/_AUDITSAFE_DS_PORT_/${auditsafe_ds_port}/g" docker.env
	
	#PS properties
	sed -i "s/_BCCE_POLLER_ENGINES_/${bcce_poller_engines}/g" docker.env
	sed -i "s/_BCCE_POLLER_IB_EMAIL_INSTANCES_/${bcce_poller_ib_email_instances}/g" docker.env
	sed -i "s/_BCCE_POLLER_IB_EMAIL_REFRESH_RATE_/${bcce_poller_ib_email_refresh_rate}/g" docker.env
	sed -i "s/_BCCE_POLLER_IB_EMAIL_WEIGHT_/${bcce_poller_ib_email_weight}/g" docker.env
	sed -i "s/_BCCE_POLLER_IB_FILE_INSTANCES_/${bcce_poller_ib_file_instances}/g" docker.env
	sed -i "s/_BCCE_POLLER_IB_FILE_REFRESH_RATE_/${bcce_poller_ib_file_refresh_rate}/g" docker.env
	sed -i "s/_BCCE_POLLER_IB_FILE_WEIGHT_/${bcce_poller_ib_file_weight}/g" docker.env
	sed -i "s/_BCCE_POLLER_OB_FILE_INSTANCES_/${bcce_poller_ob_file_instances}/g" docker.env
	sed -i "s/_BCCE_POLLER_OB_FILE_REFRESH_RATE_/${bcce_poller_ob_file_refresh_rate}/g" docker.env
	sed -i "s/_BCCE_POLLER_OB_FILE_WEIGHT_/${bcce_poller_ob_file_weight}/g" docker.env
	sed -i "s/_BCCE_POLLER_IB_FTP_INSTANCES_/${bcce_poller_ib_ftp_instances}/g" docker.env
	sed -i "s/_BCCE_POLLER_IB_FTP_REFRESH_RATE_/${bcce_poller_ib_ftp_refresh_rate}/g" docker.env
	sed -i "s/_BCCE_POLLER_IB_FTP_WEIGHT_/${bcce_poller_ib_ftp_weight}/g" docker.env
        sed -i "s/_BCCE_POLLER_INTERNAL_MDN_INSTANCES_/${bcce_poller_internal_mdn_instances}/g" docker.env
        sed -i "s/_BCCE_POLLER_INTERNAL_MDN_REFRESH_RATE_/${bcce_poller_internal_mdn_refresh_rate}/g" docker.env
        sed -i "s/_BCCE_POLLER_INTERNAL_MDN_WEIGHT_/${bcce_poller_internal_mdn_weight}/g" docker.env
        sed -i "s/_BCCE_POLLER_INTERNAL_SCHD_INSTANCES_/${bcce_poller_internal_schd_instances}/g" docker.env
        sed -i "s/_BCCE_POLLER_INTERNAL_SCHD_REFRESH_RATE_/${bcce_poller_internal_schd_refresh_rate}/g" docker.env
        sed -i "s/_BCCE_POLLER_INTERNAL_SCHD_WEIGHT_/${bcce_poller_internal_schd_weight}/g" docker.env
        sed -i "s/_BCCE_POLLER_INTERNAL_RESEND_INSTANCES_/${bcce_poller_internal_resend_instances}/g" docker.env
        sed -i "s/_BCCE_POLLER_INTERNAL_RESEND_REFRESH_RATE_/${bcce_poller_internal_resend_refresh_rate}/g" docker.env
        sed -i "s/_BCCE_POLLER_INTERNAL_RESEND_WEIGHT_/${bcce_poller_internal_resend_weight}/g" docker.env
        sed -i "s/_BCCE_POLLER_INTERNAL_HIBER_INSTANCES_/${bcce_poller_internal_hiber_instances}/g" docker.env
        sed -i "s/_BCCE_POLLER_INTERNAL_HIBER_REFRESH_RATE_/${bcce_poller_internal_hiber_refresh_rate}/g" docker.env
        sed -i "s/_BCCE_POLLER_INTERNAL_HIBER_WEIGHT_/${bcce_poller_internal_hiber_weight}/g" docker.env

elif [[ "$OSTYPE" =~ "darwin" ]]; then
# MAC OS
	sed -i "" "s/_AUDITSAFE_WS_HOST_/${AUDITSAFE_WS_HOST}/g" docker.env
	sed -i "" "s/_AUDITSAFE_DS_HOST_/${AUDITSAFE_DS_HOST}/g" docker.env
	sed -i "" "s/_BCCE_HOST_/${BCCE_HOST}/g" docker.env
	
	#AUS properties
	sed -i "" "s/_DB_DRIVER_/${database_driver}/g" docker.env
	sed -i "" "s#_AUS_DB_URL_#${aus_database_url}#g" docker.env
	sed -i "" "s/_AUS_DB_USERNAME_/${aus_database_username}/g" docker.env
	sed -i "" "s/_AUS_DB_PASSWORD_/${aus_database_password}/g" docker.env
	sed -i "" "s/_AUS_SHOW_SQL_/${aus_show_sql}/g" docker.env
	sed -i "" "s/_AUS_HIKARI_POOL_SIZE_/${aus_hikari_pool_size}/g" docker.env
	sed -i "" "s/_AUS_SWAGGER_ENABLED_/${aus_swagger_enabled}/g" docker.env
	
	#CMS properties
	sed -i "" "s/_DB_DRIVER_/${database_driver}/g" docker.env
	sed -i "" "s#_DB_URL_#${database_url}#g" docker.env
	sed -i "" "s/_DB_USERNAME_/${database_username}/g" docker.env
	sed -i "" "s/_DB_PASSWORD_/${database_password}/g" docker.env
	sed -i "" "s/_BCCE_INSTALLATION_PREFIX_/${bcce_installation_prefix}/g" docker.env
	sed -i "" "s/_BCCE_INSTALLATION_NAME_/${bcce_installation_name}/g" docker.env
	sed -i "" "s/_CMS_SHOW_SQL_/${cms_show_sql}/g" docker.env
	sed -i "" "s/_CMS_HIKARI_POOL_SIZE_/${cms_hikari_pool_size}/g" docker.env
	sed -i "" "s/_CMS_SWAGGER_ENABLED_/${cms_swagger_enabled}/g" docker.env
	sed -i "" "s/_AUS_HOST_/${AUS_HOST}/g" docker.env
	sed -i "" "s/_AUS_PORT_/${BCCE_AUS_PORT}/g" docker.env
	
	#AS properties
	sed -i "" "s/_AS_PORT_/${as_port}/g" docker.env
	sed -i "" "s/_AUDITSAFE_WS_PORT_/${auditsafe_ws_port}/g" docker.env

	#IS properties
	sed -i "" "s/_AUDITSAFE_DS_PORT_/${auditsafe_ds_port}/g" docker.env
	
	#PS properties
	sed -i "" "s/_BCCE_POLLER_ENGINES_/${bcce_poller_engines}/g" docker.env
	sed -i "" "s/_BCCE_POLLER_IB_EMAIL_INSTANCES_/${bcce_poller_ib_email_instances}/g" docker.env
	sed -i "" "s/_BCCE_POLLER_IB_EMAIL_REFRESH_RATE_/${bcce_poller_ib_email_refresh_rate}/g" docker.env
	sed -i "" "s/_BCCE_POLLER_IB_EMAIL_WEIGHT_/${bcce_poller_ib_email_weight}/g" docker.env
	sed -i "" "s/_BCCE_POLLER_IB_FILE_INSTANCES_/${bcce_poller_ib_file_instances}/g" docker.env
	sed -i "" "s/_BCCE_POLLER_IB_FILE_REFRESH_RATE_/${bcce_poller_ib_file_refresh_rate}/g" docker.env
	sed -i "" "s/_BCCE_POLLER_IB_FILE_WEIGHT_/${bcce_poller_ib_file_weight}/g" docker.env
	sed -i "" "s/_BCCE_POLLER_OB_FILE_INSTANCES_/${bcce_poller_ob_file_instances}/g" docker.env
	sed -i "" "s/_BCCE_POLLER_OB_FILE_REFRESH_RATE_/${bcce_poller_ob_file_refresh_rate}/g" docker.env
	sed -i "" "s/_BCCE_POLLER_OB_FILE_WEIGHT_/${bcce_poller_ob_file_weight}/g" docker.env
	sed -i "" "s/_BCCE_POLLER_IB_FTP_INSTANCES_/${bcce_poller_ib_ftp_instances}/g" docker.env
	sed -i "" "s/_BCCE_POLLER_IB_FTP_REFRESH_RATE_/${bcce_poller_ib_ftp_refresh_rate}/g" docker.env
	sed -i "" "s/_BCCE_POLLER_IB_FTP_WEIGHT_/${bcce_poller_ib_ftp_weight}/g" docker.env
        sed -i "" "s/_BCCE_POLLER_INTERNAL_MDN_INSTANCES_/${bcce_poller_internal_mdn_instances}/g" docker.env
        sed -i "" "s/_BCCE_POLLER_INTERNAL_MDN_REFRESH_RATE_/${bcce_poller_internal_mdn_refresh_rate}/g" docker.env
        sed -i "" "s/_BCCE_POLLER_INTERNAL_MDN_WEIGHT_/${bcce_poller_internal_mdn_weight}/g" docker.env
        sed -i "" "s/_BCCE_POLLER_INTERNAL_SCHD_INSTANCES_/${bcce_poller_internal_schd_instances}/g" docker.env
        sed -i "" "s/_BCCE_POLLER_INTERNAL_SCHD_REFRESH_RATE_/${bcce_poller_internal_schd_refresh_rate}/g" docker.env
        sed -i "" "s/_BCCE_POLLER_INTERNAL_SCHD_WEIGHT_/${bcce_poller_internal_schd_weight}/g" docker.env
        sed -i "" "s/_BCCE_POLLER_INTERNAL_RESEND_INSTANCES_/${bcce_poller_internal_resend_instances}/g" docker.env
        sed -i "" "s/_BCCE_POLLER_INTERNAL_RESEND_REFRESH_RATE_/${bcce_poller_internal_resend_refresh_rate}/g" docker.env
        sed -i "" "s/_BCCE_POLLER_INTERNAL_RESEND_WEIGHT_/${bcce_poller_internal_resend_weight}/g" docker.env
        sed -i "" "s/_BCCE_POLLER_INTERNAL_HIBER_INSTANCES_/${bcce_poller_internal_hiber_instances}/g" docker.env
        sed -i "" "s/_BCCE_POLLER_INTERNAL_HIBER_REFRESH_RATE_/${bcce_poller_internal_hiber_refresh_rate}/g" docker.env
        sed -i "" "s/_BCCE_POLLER_INTERNAL_HIBER_WEIGHT_/${bcce_poller_internal_hiber_weight}/g" docker.env
fi

###################### Prepare for GS, the replacement of GS will be in docker-run-bcce-all.sh ######################
# String replacement
host_key=${host_key//%gstoken_unzip%/$gstoken_unzip}
peer_cert=${peer_cert//%gstoken_unzip%/$gstoken_unzip}
intercomp_props=${intercomp_props//%gstoken_unzip%/$gstoken_unzip}
