#!/bin/bash


if [ ! -f license_accepted.txt ]; then
	read -p "You must accept the License Agreement before proceeding. Press ENTER key to read the License. Press q to finish reading." yn
	less ../TIB_bcce_1.1.0_license.txt

	while true; do
	    read -p "Do you accept the license? (y/n) " yn
	    case $yn in
	        [Yy]* ) echo "You have accepted the license."; echo "License accepted on $(date)" > license_accepted.txt; break;;
	        [Nn]* ) echo "you did not agree the License Agreement. Exiting the deployment!"; exit;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done
fi

tfile=/tmp/file1
tfile2=/tmp/file2

# Check whether Docker is installed or not.
docker -v > $tfile 2>&1
if [ $? -ne 0 ]; then
	echo "##############################################################################"
	echo "Docker is not installed on this machine yet. The installation has to stop!!!"
	echo "##############################################################################"
	echo
	exit 1
fi

# Check whether kubernetes is installed or not.
kubectl version > $tfile2 2>&1
if [ $? -ne 0 ]; then
	echo "##############################################################################"
	echo "Kubernetes isn't installed on this machine yet. The installation has to stop!!!"
	echo "##############################################################################"
	echo
	exit 1
fi
rm -f $tfile $tfile2

# Set the default values
cms_swagger_enabled=false
bc_configstore_dbstore_cache_disable_for_qa_automation=false

# Read in all the properties from the deployment properties file.
while IFS="=" read name val
do
	if [ "$name" = "host_ip" ]; then \
		host_ip=$val
		continue;
	fi
	if [ "$name" = "docker_repository" ]; then \
		docker_repository=$val
		continue;
	fi
	if [ "$name" = "docker_username" ]; then \
		docker_username=$val
		continue;
	fi
	if [ "$name" = "k8s_namespace" ]; then \
		k8s_namespace=$val
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
	if [ "$name" = "log4j2_file" ]; then \
		log4j2_file=$val
		continue;
	fi
	if [ "$name" = "log4j2_json_file" ]; then \
		log4j2_json_file=$val
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
	if [ "$name" = "mount_path" ]; then \
		mount_path=$val
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
	if [ "$name" = "as_host" ]; then \
		as_host=$val
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
	if [ "$name" = "gs_host" ]; then \
		gs_host=$val
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
	if [ "$name" = "auditsafe_ws_host" ]; then \
		auditsafe_ws_host=$val
		continue;
	fi
	if [ "$name" = "auditsafe_ds_host" ]; then \
		auditsafe_ds_host=$val
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
	if [ "$name" = "aus_replicas" ]; then \
		aus_replicas=$val
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
	if [ "$name" = "security_group_id" ]; then \
		security_group_id=$val
		continue;
	fi
	if [ "$name" = "efs_server_ip" ]; then \
		efs_server_ip=$val
		continue;
	fi
	if [ "$name" = "resource_group" ]; then \
		resource_group=$val
		continue;
	fi
	if [ "$name" = "file_share_name" ]; then \
		file_share_name=$val
		continue;
	fi
	if [ "$name" = "pv_claim" ]; then \
		pv_claim=$val
		continue;
	fi
	if [ "$name" = "file_share_secret" ]; then \
		file_share_secret=$val
		continue;
	fi
done < ../config/deployment.properties

# Set the secret docker-login
k8s_key_secret=docker-login

if [ "$docker_repository" = "" ]; then
	echo "#################################################################################"
	echo "The docker_repository in deployment.properties must be set. Exiting process now!"
	echo "#################################################################################"
	echo
	exit 1
fi

if [ $? -ne 0 ]; then
        echo "##############################################################################"
        echo "Docker login error, Exit!"
        echo "##############################################################################"
        echo
        exit 1
fi

if [ "$database_username" = "<username>" ]; then
	echo "##############################################################################"
	echo "The property database_username isn't set properly."
	echo "Exit!"
	echo "##############################################################################"
	echo
	exit 1
fi

if [ "$database_password" = "<password>" ]; then
	echo "##############################################################################"
	echo "The property database_password isn't set properly."
	echo "Exit!"
	echo "##############################################################################"
	echo
	exit 1
fi

# String replacement
host_key=${host_key//%gstoken_unzip%/$gstoken_unzip}
peer_cert=${peer_cert//%gstoken_unzip%/$gstoken_unzip}
intercomp_props=${intercomp_props//%gstoken_unzip%/$gstoken_unzip}

if [ "$auditsafe_ws_host" = "%host_ip%" ]; then
	auditsafe_ws_host=${auditsafe_ws_host//%host_ip%/$host_ip}
fi

if [ "$auditsafe_ds_host" = "%host_ip%" ]; then
	auditsafe_ds_host=${auditsafe_ds_host//%host_ip%/$host_ip}
fi

if [ "$aus_host" = "%host_ip%" ]; then
	aus_host=${aus_host//%host_ip%/$host_ip}
fi

if [ "$as_host" = "%host_ip%" ]; then
	as_host=${as_host//%host_ip%/$host_ip}
fi

if [ "$gs_host" = "%host_ip%" ]; then
	gs_host=${gs_host//%host_ip%/$host_ip}
fi

if [ "$aus_database_username" = "%database_username%" ]; then
	aus_database_username=${aus_database_username//%database_username%/$database_username}
fi

if [ "$aus_database_password" = "%database_password%" ]; then
	aus_database_password=${aus_database_password//%database_password%/$database_password}
fi

# Check whether the Kubernetes namespace exists or not
for each in $(kubectl get namespaces |grep ${k8s_namespace} |awk '{print $1}');
do
	if [ "${k8s_namespace}" = "$each" ]; then
		find_namespace="true"
		break;
	fi
done
if [ "$find_namespace" = "" ]; then
	echo "##############################################################################"
	echo "Kubernetes Namespace ${k8s_namespace} doesn't exist yet."
	echo "It will be created now!"
	echo "##############################################################################"
	kubectl create namespace ${k8s_namespace}
fi

while true; do
	echo "Which Kubernetes environment do you want to deploy TIBCO BCCE services?"
	echo "1. Native Kubernetes"
	echo "2. AWS EKS"
	echo "3. Azure AKS"
	echo "4. Google Cloud GKE"
	echo "q. Quit"
	read -p "(1/2/3/4/q) " k8s_env
	case $k8s_env in
		[1]* ) k8s_env=1; break;;
		[2]* ) k8s_env=2; break;;
		[3]* ) k8s_env=3; break;;
		[4]* ) k8s_env=4; break;;
		[q]* ) exit;;
		* ) echo "Please select one.";;
	esac
done

if [ "$docker_repository" = "<docker_registry_ip>:<docker_registry_port>" ]; then
	echo "##############################################################################"
	echo "The property docker_repository isn't set properly."
	echo "Exit!"
	echo "##############################################################################"
	echo
	exit 1
fi

if [ "$host_ip" = "<host_ip>" ] && [ "$k8s_env" = "1" ]; then
	echo "##############################################################################"
	echo "The property host_ip isn't set properly."
	echo "Exit!"
	echo "##############################################################################"
	echo
	exit 1
fi

if [ "$k8s_env" = "1" ]; then
	cp -f ../services/gs/bcce-gs-svc.yaml.template.native ../services/gs/bcce-gs-svc.yaml.template
	cp -f ../services/is/bcce-is.yaml.template.native ../services/is/bcce-is.yaml.template
	cp -f ../services/ps/bcce-ps.yaml.template.native ../services/ps/bcce-ps.yaml.template
	cp -f ../services/as/bcce-as-svc.yaml.template.native ../services/as/bcce-as-svc.yaml.template
	cp -f ../services/aus/bcce-aus-svc.yaml.template.native ../services/aus/bcce-aus-svc.yaml.template
elif [ "$k8s_env" = "2" ]; then
	if [ "$security_group_id" = "<security_group_id>" ]; then
		echo "#################################################################################"
		echo "The security_group_id in deployment.properties must be set. Exiting process now!"
		echo "#################################################################################"
		echo
		exit 1
	fi
	cp -f ../services/gs/bcce-gs-svc.yaml.template.eks ../services/gs/bcce-gs-svc.yaml.template
	cp -f ../services/is/bcce-is.yaml.template.eks ../services/is/bcce-is.yaml.template
	cp -f ../services/ps/bcce-ps.yaml.template.eks ../services/ps/bcce-ps.yaml.template
	cp -f ../services/as/bcce-as-svc.yaml.template.eks ../services/as/bcce-as-svc.yaml.template
	cp -f ../services/aus/bcce-aus-svc.yaml.template.eks ../services/aus/bcce-aus-svc.yaml.template
elif [ "$k8s_env" = "3" ]; then
	if [ "$resource_group" = "<resource_group>" ]; then
		echo "##############################################################################"
		echo "The resource_group in deployment.properties must be set. Exiting process now!"
		echo "##############################################################################"
		echo
		exit 1
	fi
	if [ "$aus_host" = "%host_ip%" ]; then
		echo "##############################################################################"
		echo "The aus_host in deployment.properties must be set. Exiting process now!"
		echo "##############################################################################"
		echo
		exit 1
	fi
	if [ "$as_host" = "%host_ip%" ]; then
		echo "##############################################################################"
		echo "The as_host in deployment.properties must be set. Exiting process now!"
		echo "##############################################################################"
		echo
		exit 1
	fi
	if [ "$gs_host" = "%host_ip%" ]; then
		echo "##############################################################################"
		echo "The gs_host in deployment.properties must be set. Exiting process now!"
		echo "##############################################################################"
		echo
		exit 1
	fi
	if [ "$auditsafe_ws_host" = "%host_ip%" ]; then
		echo "#################################################################################"
		echo "The auditsafe_ws_host in deployment.properties must be set. Exiting process now!"
		echo "#################################################################################"
		echo
		exit 1
	fi
	cp -f ../services/gs/bcce-gs-svc.yaml.template.aks ../services/gs/bcce-gs-svc.yaml.template
	cp -f ../services/is/bcce-is.yaml.template.aks ../services/is/bcce-is.yaml.template
	cp -f ../services/ps/bcce-ps.yaml.template.aks ../services/ps/bcce-ps.yaml.template
	cp -f ../services/as/bcce-as-svc.yaml.template.aks ../services/as/bcce-as-svc.yaml.template
	cp -f ../services/aus/bcce-aus-svc.yaml.template.aks ../services/aus/bcce-aus-svc.yaml.template
elif [ "$k8s_env" = "4" ]; then
	if [ "$aus_host" = "%host_ip%" ]; then
		echo "##############################################################################"
		echo "The aus_host in deployment.properties must be set. Exiting process now!"
		echo "##############################################################################"
		echo
		exit 1
	fi
	if [ "$as_host" = "%host_ip%" ]; then
		echo "##############################################################################"
		echo "The as_host in deployment.properties must be set. Exiting process now!"
		echo "##############################################################################"
		echo
		exit 1
	fi
	if [ "$gs_host" = "%host_ip%" ]; then
		echo "##############################################################################"
		echo "The gs_host in deployment.properties must be set. Exiting process now!"
		echo "##############################################################################"
		echo
		exit 1
	fi
	if [ "$auditsafe_ws_host" = "%host_ip%" ]; then
		echo "#################################################################################"
		echo "The auditsafe_ws_host in deployment.properties must be set. Exiting process now!"
		echo "#################################################################################"
		echo
		exit 1
	fi
	cp -f ../services/gs/bcce-gs-svc.yaml.template.gke ../services/gs/bcce-gs-svc.yaml.template
	cp -f ../services/is/bcce-is.yaml.template.gke ../services/is/bcce-is.yaml.template
	cp -f ../services/ps/bcce-ps.yaml.template.gke ../services/ps/bcce-ps.yaml.template
	cp -f ../services/as/bcce-as-svc.yaml.template.gke ../services/as/bcce-as-svc.yaml.template
	cp -f ../services/aus/bcce-aus-svc.yaml.template.gke ../services/aus/bcce-aus-svc.yaml.template
fi


# Create the log4j2 secret
./apply_secret_log4j2.sh

# Create the log4j2.json secret
./apply_secret_log4j2_json.sh

# Check the docker-login secret
for each in $(kubectl get secrets --namespace $k8s_namespace |grep $k8s_key_secret |awk '{print $1}');
do
	if [ "$each" = "$k8s_key_secret" ]; then
		break
	fi
done
if [ "$each" != "$k8s_key_secret" ]; then
	./apply_secret_docker_login.sh
fi

cd ../services

aus_found=`kubectl get services --all-namespaces | grep bcce-aus`
if [ "$aus_found" = "" ]; then
	while true; do
		echo "Do you want to deploy TIBCO Auth Server service?"
		read -p "(y/n) " yn
		case $yn in
			[Yy]* ) install_aus=yes; break;;
			[Nn]* ) break;;
			* ) echo "Please answer yes or no.";;
		esac
	done

	if [ "$install_aus" = "yes" ]; then
		echo "##########################################################################"
		echo "Deploying the TIBCO Auth Server"
		echo "##########################################################################"
		echo
		cd aus
		while IFS="=" read name val
		do
			if [ "$name" = "aus_build_num" ]; then \
				aus_build_num=$val
			fi
		done < installation.properties

		sed "s/_REPLICAS_/${aus_replicas}/g" bcce-aus.yaml.template > bcce-aus.yaml.template1
		sed "s#_DOCKER_REPOSITORY_#${docker_repository}#g" bcce-aus.yaml.template1 > bcce-aus.yaml.template2
		sed "s#_DATABASE_URL_#${aus_database_url}#g" bcce-aus.yaml.template2 > bcce-aus.yaml.template1
		sed "s/_DATABASE_DRIVER_/${database_driver}/g" bcce-aus.yaml.template1 > bcce-aus.yaml.template2
		sed "s/_DATABASE_USERNAME_/${aus_database_username}/g" bcce-aus.yaml.template2 > bcce-aus.yaml.template1
		sed "s/_DATABASE_PASSWORD_/${aus_database_password}/g" bcce-aus.yaml.template1 > bcce-aus.yaml.template2
		sed "s/_BUILD_NUM_/${aus_build_num}/g" bcce-aus.yaml.template2 > bcce-aus.yaml.template1
		sed "s/_AUS_SHOW_SQL_/${aus_show_sql}/g" bcce-aus.yaml.template1 > bcce-aus.yaml.template2
		sed "s/_AUS_HIKARI_POOL_SIZE_/${aus_hikari_pool_size}/g" bcce-aus.yaml.template2 > bcce-aus.yaml.template1
		sed "s/_IMAGE_PULL_SECRETS_/${k8s_key_secret}/g" bcce-aus.yaml.template1 > bcce-aus.yaml.template2
		sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-aus.yaml.template2 > bcce-aus.yaml.template1
		sed "s/_AUS_SWAGGER_ENABLED_/${aus_swagger_enabled}/g" bcce-aus.yaml.template1 > bcce-aus.yaml
		sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-aus-svc.yaml.template > bcce-aus-svc.yaml.template1
		if [ "$k8s_env" = "2" ]; then
			sed "s/_AUS_PORT_/${aus_port}/g" bcce-aus-svc.yaml.template1 > bcce-aus-svc.yaml.template2
			sed "s/_SECURITY_GROUP_ID_/${security_group_id}/g" bcce-aus-svc.yaml.template2 > bcce-aus-svc.yaml
		elif [ "$k8s_env" = "3" ]; then
			sed "s/_AUS_PORT_/${aus_port}/g" bcce-aus-svc.yaml.template1 > bcce-aus-svc.yaml.template2
			sed "s/_RESOURCE_GROUP_/${resource_group}/g" bcce-aus-svc.yaml.template2 > bcce-aus-svc.yaml.template1
			sed "s/_PUBLIC_AUS_IP_/${aus_host}/g" bcce-aus-svc.yaml.template1 > bcce-aus-svc.yaml
		elif [ "$k8s_env" = "4" ]; then
			sed "s/_AUS_PORT_/${aus_port}/g" bcce-aus-svc.yaml.template1 > bcce-aus-svc.yaml.template2
			sed "s/_PUBLIC_AUS_IP_/${aus_host}/g" bcce-aus-svc.yaml.template2 > bcce-aus-svc.yaml
		else
			sed "s/_AUS_PORT_/${aus_port}/g" bcce-aus-svc.yaml.template1 > bcce-aus-svc.yaml
		fi
		rm -f bcce-aus.yaml.template1 bcce-aus.yaml.template2 bcce-aus-svc.yaml.template1 bcce-aus-svc.yaml.template2

		kubectl apply -f bcce-aus.yaml --namespace=${k8s_namespace}
		kubectl apply -f bcce-aus-svc.yaml --namespace=${k8s_namespace}
		echo "Waiting for the Auth Server to start..."
		sleep 60
		cd ..
	fi
else
	echo "Found the Auth Server service:"
	echo "=========================================================================================================="
	echo "$aus_found"
	echo "=========================================================================================================="
	echo "You have to undeploy the Auth Server first if you want to deploy Auth Server service."
	echo "Skip the Auth Server deployment."
fi

while true; do
	echo "Do you want to deploy TIBCO BCCE Server services?"
	echo "  1. ConfigStore Management Server"
	echo "  2. Admin Server"
	read -p "(y/n) " yn
	case $yn in
 		[Yy]* ) install_others=yes; break;;
		[Nn]* ) break;;
		* ) echo "Please answer yes or no.";;
	esac
done

if [ "$install_others" = "yes" ]; then
	aus_namespace=`kubectl get services --all-namespaces | grep bcce-aus |awk '{print $1}'`
	if [ ! "$k8s_env" = "1" ]; then
		if [ "$auditsafe_ws_host" = "%host_ip%" ]; then
			echo "#################################################################################"
			echo "The auditsafe_ws_host in deployment.properties must be set. Exiting process now!"
			echo "#################################################################################"
			echo
			exit 1
		fi
	fi

	echo "##########################################################################"
	echo "Deploying the TIBCO BCCE ConfigStore Management Server"
	echo "##########################################################################"
	echo
	cd cms
	while IFS="=" read name val
	do
		if [ "$name" = "cms_build_num" ]; then \
			cms_build_num=$val
		fi
	done < installation.properties

	sed "s/_REPLICAS_/${cms_replicas}/g" bcce-cms.yaml.template > bcce-cms.yaml.template1
	sed "s#_DOCKER_REPOSITORY_#${docker_repository}#g" bcce-cms.yaml.template1 > bcce-cms.yaml.template2
	sed "s#_DATABASE_URL_#${database_url}#g" bcce-cms.yaml.template2 > bcce-cms.yaml.template1
	sed "s/_DATABASE_DRIVER_/${database_driver}/g" bcce-cms.yaml.template1 > bcce-cms.yaml.template2
	sed "s/_DATABASE_USERNAME_/${database_username}/g" bcce-cms.yaml.template2 > bcce-cms.yaml.template1
	sed "s/_DATABASE_PASSWORD_/${database_password}/g" bcce-cms.yaml.template1 > bcce-cms.yaml.template2
	sed "s/_BUILD_NUM_/${cms_build_num}/g" bcce-cms.yaml.template2 > bcce-cms.yaml.template1
	sed "s/_CMS_SHOW_SQL_/${cms_show_sql}/g" bcce-cms.yaml.template1 > bcce-cms.yaml.template2
	sed "s/_CMS_HIKARI_POOL_SIZE_/${cms_hikari_pool_size}/g" bcce-cms.yaml.template2 > bcce-cms.yaml.template1
	sed "s/_BCCE_INSTALLATION_PREFIX_/${bcce_installation_prefix}/g" bcce-cms.yaml.template1 > bcce-cms.yaml.template2
	sed "s/_BCCE_INSTALLATION_NAME_/${bcce_installation_name}/g" bcce-cms.yaml.template2 > bcce-cms.yaml.template1
	sed "s/_IMAGE_PULL_SECRETS_/${k8s_key_secret}/g" bcce-cms.yaml.template1 > bcce-cms.yaml.template2
	sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-cms.yaml.template2 > bcce-cms.yaml.template1
	sed "s/_CMS_SWAGGER_ENABLED_/${cms_swagger_enabled}/g" bcce-cms.yaml.template1 > bcce-cms.yaml.template2
	sed "s/_NAMESPACE2_/${aus_namespace}/g" bcce-cms.yaml.template2 > bcce-cms.yaml.template1
	sed "s/_AUS_PORT_/${aus_port}/g" bcce-cms.yaml.template1 > bcce-cms.yaml.template2
	sed "s/_CONFIGSTORE_QA_AUTOMATION_/${bc_configstore_dbstore_cache_disable_for_qa_automation}/g" bcce-cms.yaml.template2 > bcce-cms.yaml
	sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-cms-svc.yaml.template > bcce-cms-svc.yaml
	rm -f bcce-cms.yaml.template1 bcce-cms.yaml.template2

	kubectl apply -f bcce-cms.yaml --namespace=${k8s_namespace}
	kubectl apply -f bcce-cms-svc.yaml --namespace=${k8s_namespace}
	cd ..

	echo "##################################################################"
	echo "Deploying the TIBCO BCCE Admin Server"
	echo "##################################################################"
	echo
	cd as
	while IFS="=" read name val
	do
		if [ "$name" = "as_build_num" ]; then \
			as_build_num=$val
		fi
	done < installation.properties

	sed "s/_REPLICAS_/${as_replicas}/g" bcce-as.yaml.template > bcce-as.yaml.template1
	sed "s#_AUDITSAFE_WS_HOST_#${auditsafe_ws_host}#g" bcce-as.yaml.template1 > bcce-as.yaml.template2
	sed "s#_DOCKER_REPOSITORY_#${docker_repository}#g" bcce-as.yaml.template2 > bcce-as.yaml.template1
	sed "s/_IMAGE_PULL_SECRETS_/${k8s_key_secret}/g" bcce-as.yaml.template1 > bcce-as.yaml.template2
	sed "s/_AS_PORT_/${as_port}/g" bcce-as.yaml.template2 > bcce-as.yaml.template1
	sed "s/_AUDITSAFE_WS_PORT_/${auditsafe_ws_port}/g" bcce-as.yaml.template1 > bcce-as.yaml.template2
	sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-as.yaml.template2 > bcce-as.yaml.template1
	sed "s/_BUILD_NUM_/${as_build_num}/g" bcce-as.yaml.template1 > bcce-as.yaml
	sed "s/_AS_PORT_/${as_port}/g" bcce-as-svc.yaml.template > bcce-as-svc.yaml.template1
	if [ "$k8s_env" = "2" ]; then
		sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-as-svc.yaml.template1 > bcce-as-svc.yaml.template2
		sed "s/_SECURITY_GROUP_ID_/${security_group_id}/g" bcce-as-svc.yaml.template2 > bcce-as-svc.yaml
	elif [ "$k8s_env" = "3" ]; then
		sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-as-svc.yaml.template1 > bcce-as-svc.yaml.template2
		sed "s/_RESOURCE_GROUP_/${resource_group}/g" bcce-as-svc.yaml.template2 > bcce-as-svc.yaml.template1
		sed "s/_PUBLIC_AS_IP_/${as_host}/g" bcce-as-svc.yaml.template1 > bcce-as-svc.yaml
	elif [ "$k8s_env" = "4" ]; then
		sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-as-svc.yaml.template1 > bcce-as-svc.yaml.template2
		sed "s/_PUBLIC_AS_IP_/${as_host}/g" bcce-as-svc.yaml.template2 > bcce-as-svc.yaml
	else
		sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-as-svc.yaml.template1 > bcce-as-svc.yaml
	fi
	rm -f bcce-as.yaml.template1 bcce-as.yaml.template2 bcce-as-svc.yaml.template1 bcce-as-svc.yaml.template2

	kubectl apply -f bcce-as.yaml --namespace=${k8s_namespace}
	kubectl apply -f bcce-as-svc.yaml --namespace=${k8s_namespace}
	cd ..
fi

while true; do
	echo "Do you want to deploy the TIBCO BCCE Server services?"
	echo "  3. Poller Server"
	echo "  4. Interior Server"
	echo "Please make sure the JMS Server settings are done properly from the BCCE Admin UI."
	echo "Otherwise, the Poller Server and Interior Server won't work."
	read -p "(y/n) " yn
	case $yn in
 		[Yy]* ) install_others2=yes; break;;
		[Nn]* ) break;;
		* ) echo "Please answer yes or no.";;
	esac
done

if [ "$install_others2" = "yes" ]; then
	if [ "$k8s_env" = "2" ]; then
		ds_namespace=`kubectl get services --all-namespaces | grep auditsafe-ds |awk '{print $1}'`
		if [ "$ds_namespace" = "" ]; then
			echo "########################################################################################"
			echo "The AuditSafe Data Server must be deployed before BCCE IS and PS. Exiting process now!"
			echo "########################################################################################"
			echo
			exit 1
		fi
		if [ "$efs_server_ip" = "<efs_server_ip>" ]; then
			echo "##############################################################################"
			echo "The efs_server_ip in deployment.properties must be set. Exiting process now!"
			echo "##############################################################################"
			echo
			exit 1
		fi
	fi
	if [ "$k8s_env" = "3" ]; then
		ds_namespace=`kubectl get services --all-namespaces | grep auditsafe-ds |awk '{print $1}'`
		if [ "$ds_namespace" = "" ]; then
			echo "########################################################################################"
			echo "The AuditSafe Data Server must be deployed before BCCE IS and PS. Exiting process now!"
			echo "########################################################################################"
			echo
			exit 1
		fi
		if [ "$file_share_name" = "<file_share_name>" ]; then
			echo "#################################################################################"
			echo "The file_share_name in deployment.properties must be set. Exiting process now!"
			echo "#################################################################################"
			echo
			exit 1
		fi
		if [ "$file_share_secret" = "<file_share_secret>" ]; then
			echo "#################################################################################"
			echo "The file_share_secret in deployment.properties must be set. Exiting process now!"
			echo "#################################################################################"
			echo
			exit 1
		fi
	fi
	if [ "$k8s_env" = "4" ]; then
		ds_namespace=`kubectl get services --all-namespaces | grep auditsafe-ds |awk '{print $1}'`
		if [ "$ds_namespace" = "" ]; then
			echo "########################################################################################"
			echo "The AuditSafe Data Server must be deployed before BCCE IS and PS. Exiting process now!"
			echo "########################################################################################"
			echo
			exit 1
		fi
		if [ "$pv_claim" = "<pv_claim>" ]; then
			echo "##############################################################################"
			echo "The pv_claim in deployment.properties must be set. Exiting process now!"
			echo "##############################################################################"
			echo
			exit 1
		fi
	fi
	echo "##################################################################"
	echo "Deploying the TIBCO BCCE Poller Server"
	echo "##################################################################"
	echo
	cd ps
	while IFS="=" read name val
	do
		if [ "$name" = "ps_build_num" ]; then \
			ps_build_num=$val
		fi
	done < installation.properties

	sed "s/_REPLICAS_/${ps_replicas}/g" bcce-ps.yaml.template > bcce-ps.yaml.template1
	sed "s#_K8S_HOST_#${host_ip}#g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s#_DOCKER_REPOSITORY_#${docker_repository}#g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s#_DATABASE_URL_#${database_url}#g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_DATABASE_DRIVER_/${database_driver}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_DATABASE_USERNAME_/${database_username}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_DATABASE_PASSWORD_/${database_password}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_BCCE_INSTALLATION_PREFIX_/${bcce_installation_prefix}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_BCCE_INSTALLATION_NAME_/${bcce_installation_name}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_IMAGE_PULL_SECRETS_/${k8s_key_secret}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s#_MOUNT_PATH_#${mount_path}#g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_BUILD_NUM_/${ps_build_num}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_BCCE_POLLER_ENGINES_/${bcce_poller_engines}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_BCCE_POLLER_IB_EMAIL_INSTANCES_/${bcce_poller_ib_email_instances}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_BCCE_POLLER_IB_EMAIL_REFRESH_RATE_/${bcce_poller_ib_email_refresh_rate}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_BCCE_POLLER_IB_EMAIL_WEIGHT_/${bcce_poller_ib_email_weight}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_BCCE_POLLER_IB_FILE_INSTANCES_/${bcce_poller_ib_file_instances}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_BCCE_POLLER_IB_FILE_REFRESH_RATE_/${bcce_poller_ib_file_refresh_rate}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_BCCE_POLLER_IB_FILE_WEIGHT_/${bcce_poller_ib_file_weight}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_BCCE_POLLER_OB_FILE_INSTANCES_/${bcce_poller_ob_file_instances}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_BCCE_POLLER_OB_FILE_REFRESH_RATE_/${bcce_poller_ob_file_refresh_rate}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_BCCE_POLLER_OB_FILE_WEIGHT_/${bcce_poller_ob_file_weight}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_BCCE_POLLER_IB_FTP_INSTANCES_/${bcce_poller_ib_ftp_instances}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_BCCE_POLLER_IB_FTP_REFRESH_RATE_/${bcce_poller_ib_ftp_refresh_rate}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_BCCE_POLLER_IB_FTP_WEIGHT_/${bcce_poller_ib_ftp_weight}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_BCCE_POLLER_INTERNAL_MDN_INSTANCES_/${bcce_poller_internal_mdn_instances}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_BCCE_POLLER_INTERNAL_MDN_REFRESH_RATE_/${bcce_poller_internal_mdn_refresh_rate}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_BCCE_POLLER_INTERNAL_MDN_WEIGHT_/${bcce_poller_internal_mdn_weight}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_BCCE_POLLER_INTERNAL_SCHD_INSTANCES_/${bcce_poller_internal_schd_instances}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_BCCE_POLLER_INTERNAL_SCHD_REFRESH_RATE_/${bcce_poller_internal_schd_refresh_rate}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_BCCE_POLLER_INTERNAL_SCHD_WEIGHT_/${bcce_poller_internal_schd_weight}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_BCCE_POLLER_INTERNAL_RESEND_INSTANCES_/${bcce_poller_internal_resend_instances}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_BCCE_POLLER_INTERNAL_RESEND_REFRESH_RATE_/${bcce_poller_internal_resend_refresh_rate}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_BCCE_POLLER_INTERNAL_RESEND_WEIGHT_/${bcce_poller_internal_resend_weight}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	if [ "$k8s_env" = "1" ]; then
		sed "s#_AUDITSAFE_DS_HOST_#${auditsafe_ds_host}#g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	else
		sed "s#_NAMESPACE2_#${ds_namespace}#g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	fi
	sed "s/_CONFIGSTORE_QA_AUTOMATION_/${bc_configstore_dbstore_cache_disable_for_qa_automation}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_BCCE_POLLER_INTERNAL_HIBER_INSTANCES_/${bcce_poller_internal_hiber_instances}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	sed "s/_BCCE_POLLER_INTERNAL_HIBER_REFRESH_RATE_/${bcce_poller_internal_hiber_refresh_rate}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
	sed "s/_BCCE_POLLER_INTERNAL_HIBER_WEIGHT_/${bcce_poller_internal_hiber_weight}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
	if [ "$k8s_env" = "2" ]; then
		sed "s/_AUDITSAFE_DS_PORT_/${auditsafe_ds_port}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
		sed "s/_EFS_SERVER_IP_/${efs_server_ip}/g" bcce-ps.yaml.template1 > bcce-ps.yaml
	elif [ "$k8s_env" = "3" ]; then
		sed "s/_AUDITSAFE_DS_PORT_/${auditsafe_ds_port}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
		sed "s/_FILE_SHARE_NAME_/${file_share_name}/g" bcce-ps.yaml.template1 > bcce-ps.yaml.template2
		sed "s/_FILE_SHARE_SECRET_/${file_share_secret}/g" bcce-ps.yaml.template2 > bcce-ps.yaml
	elif [ "$k8s_env" = "4" ]; then
		sed "s/_AUDITSAFE_DS_PORT_/${auditsafe_ds_port}/g" bcce-ps.yaml.template2 > bcce-ps.yaml.template1
		sed "s/_PV_CLAIM_/${pv_claim}/g" bcce-ps.yaml.template1 > bcce-ps.yaml
	else
		sed "s/_AUDITSAFE_DS_PORT_/${auditsafe_ds_port}/g" bcce-ps.yaml.template2 > bcce-ps.yaml
	fi
	rm -f bcce-ps.yaml.template1 bcce-ps.yaml.template2

	kubectl apply -f bcce-ps.yaml --namespace=${k8s_namespace}
	cd ..

	echo "##################################################################"
	echo "Deploying the TIBCO BCCE Interior Server"
	echo "##################################################################"
	echo
	cd is
	while IFS="=" read name val
	do
		if [ "$name" = "is_build_num" ]; then \
			is_build_num=$val
		fi
	done < installation.properties

	sed "s/_REPLICAS_/${is_replicas}/g" bcce-is.yaml.template > bcce-is.yaml.template1
	if [ "$k8s_env" = "1" ]; then
		sed "s#_AUDITSAFE_DS_HOST_#${auditsafe_ds_host}#g" bcce-is.yaml.template1 > bcce-is.yaml.template2
	else
		sed "s#_NAMESPACE2_#${ds_namespace}#g" bcce-is.yaml.template1 > bcce-is.yaml.template2
	fi
	sed "s#_DOCKER_REPOSITORY_#${docker_repository}#g" bcce-is.yaml.template2 > bcce-is.yaml.template1
	sed "s#_DATABASE_URL_#${database_url}#g" bcce-is.yaml.template1 > bcce-is.yaml.template2
	sed "s/_DATABASE_DRIVER_/${database_driver}/g" bcce-is.yaml.template2 > bcce-is.yaml.template1
	sed "s/_DATABASE_USERNAME_/${database_username}/g" bcce-is.yaml.template1 > bcce-is.yaml.template2
	sed "s/_DATABASE_PASSWORD_/${database_password}/g" bcce-is.yaml.template2 > bcce-is.yaml.template1
	sed "s/_BCCE_INSTALLATION_PREFIX_/${bcce_installation_prefix}/g" bcce-is.yaml.template1 > bcce-is.yaml.template2
	sed "s/_BCCE_INSTALLATION_NAME_/${bcce_installation_name}/g" bcce-is.yaml.template2 > bcce-is.yaml.template1
	sed "s/_IMAGE_PULL_SECRETS_/${k8s_key_secret}/g" bcce-is.yaml.template1 > bcce-is.yaml.template2
	sed "s/_AUDITSAFE_DS_PORT_/${auditsafe_ds_port}/g" bcce-is.yaml.template2 > bcce-is.yaml.template1
	sed "s#_MOUNT_PATH_#${mount_path}#g" bcce-is.yaml.template1 > bcce-is.yaml.template2
	sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-is.yaml.template2 > bcce-is.yaml.template1
	sed "s/_CONFIGSTORE_QA_AUTOMATION_/${bc_configstore_dbstore_cache_disable_for_qa_automation}/g" bcce-is.yaml.template1 > bcce-is.yaml.template2
	if [ "$k8s_env" = "2" ]; then
		sed "s/_BUILD_NUM_/${is_build_num}/g" bcce-is.yaml.template2 > bcce-is.yaml.template1
		sed "s/_EFS_SERVER_IP_/${efs_server_ip}/g" bcce-is.yaml.template1 > bcce-is.yaml
	elif [ "$k8s_env" = "3" ]; then
		sed "s/_BUILD_NUM_/${is_build_num}/g" bcce-is.yaml.template2 > bcce-is.yaml.template1
		sed "s/_FILE_SHARE_NAME_/${file_share_name}/g" bcce-is.yaml.template1 > bcce-is.yaml.template2
		sed "s/_FILE_SHARE_SECRET_/${file_share_secret}/g" bcce-is.yaml.template2 > bcce-is.yaml
	elif [ "$k8s_env" = "4" ]; then
		sed "s/_BUILD_NUM_/${is_build_num}/g" bcce-is.yaml.template2 > bcce-is.yaml.template1
		sed "s/_PV_CLAIM_/${pv_claim}/g" bcce-is.yaml.template1 > bcce-is.yaml
	else
		sed "s/_BUILD_NUM_/${is_build_num}/g" bcce-is.yaml.template2 > bcce-is.yaml
	fi
	rm -f bcce-is.yaml.template1 bcce-is.yaml.template2

	kubectl apply -f bcce-is.yaml --namespace=${k8s_namespace}
	cd ..
fi


while true; do
	echo "Do you want to deploy TIBCO BCCE Gateway Server service?"
	echo "Please make sure that you have downloaded the GSToken.zip from Admin UI, extracted it"
	echo "in a folder and set the property gstoken_unzip in the deployment.properties file."
	echo "Otherwise, the Gateway Server won't work."
	read -p "(y/n) " yn
	case $yn in
		[Yy]* ) install_gs=yes; break;;
		[Nn]* ) break;;
		* ) echo "Please answer yes or no.";;
	esac
done

if [ "$install_gs" != "yes" ]; then
	exit
fi

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

	# Create the key/cert secret
	cd ../scripts
	./apply_secret_cert.sh
	cd ../services

	# Read in all the properties from the property file.
	while IFS="=" read name val
	do
		if [ "$name" = "gs.intercomp.installation.prefix" ]; then \
			gs_intercomp_installation_prefix=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.installation.name" ]; then \
			gs_intercomp_installation_name=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.jndi.url" ]; then \
			gs_intercomp_jms_jndi_url=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.jndi.cf" ]; then \
			gs_intercomp_jms_jndi_cf=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.jndi.user" ]; then \
			gs_intercomp_jms_jndi_user=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.jndi.password" ]; then \
			gs_intercomp_jms_jndi_password=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.qcf" ]; then \
			gs_intercomp_jms_qcf=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.tcf" ]; then \
			gs_intercomp_jms_tcf=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.user" ]; then \
			gs_intercomp_jms_user=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.password" ]; then \
			gs_intercomp_jms_password=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.reconnect.duration" ]; then \
			gs_intercomp_jms_reconnect_duration=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.secure" ]; then \
			gs_intercomp_jms_secure=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.verify.host" ]; then \
			gs_intercomp_jms_verify_host=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.expected.host.name" ]; then \
			gs_intercomp_jms_expected_host_name=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.strong.cipher.only" ]; then \
			gs_intercomp_jms_strong_cipher_only=$val
			continue;
		fi
		if [ "$name" = "gs.intercomp.jms.use.trace" ]; then \
			gs_intercomp_jms_use_trace=$val
			continue;
		fi
	done < $intercomp_props

	echo "##################################################################"
	echo "Deploying the TIBCO BCCE Gateway Server"
	echo "##################################################################"
	echo
	cd gs
	while IFS="=" read name val
	do
		if [ "$name" = "gs_build_num" ]; then \
			gs_build_num=$val
		fi
	done < installation.properties

	sed "s/_REPLICAS_/${gs_replicas}/g" bcce-gs.yaml.template > bcce-gs.yaml.template1
	sed "s#_DOCKER_REPOSITORY_#${docker_repository}#g" bcce-gs.yaml.template1 > bcce-gs.yaml.template2
	sed "s/_GS_BINDING_MGMTPORT_/${gs_binding_mgmtport}/g" bcce-gs.yaml.template2 > bcce-gs.yaml.template1
	sed "s/_GS_BINDING_DDTPORT_/${gs_binding_ddtpport}/g" bcce-gs.yaml.template1 > bcce-gs.yaml.template2
	sed "s/_GS_SERVICES_/${gs_services}/g" bcce-gs.yaml.template2 > bcce-gs.yaml.template1
	sed "s/_BCCE_INSTALLATION_PREFIX_/${bcce_installation_prefix}/g" bcce-gs.yaml.template1 > bcce-gs.yaml.template2
	sed "s/_BCCE_INSTALLATION_PREFIX_/${bcce_installation_prefix}/g" bcce-gs.yaml.template2 > bcce-gs.yaml.template1
	sed "s/_BCCE_INSTALLATION_NAME_/${bcce_installation_name}/g" bcce-gs.yaml.template1 > bcce-gs.yaml.template2
	sed "s/_GS_INTERCOMP_JMS_USER_/${gs_intercomp_jms_user}/g" bcce-gs.yaml.template2 > bcce-gs.yaml.template1
	sed "s/_GS_INTERCOMP_JMS_QCF_/${gs_intercomp_jms_qcf}/g" bcce-gs.yaml.template1 > bcce-gs.yaml.template2
	sed "s/_GS_INTERCOMP_JMS_JNDI_PASSWORD_/${gs_intercomp_jms_jndi_password}/g" bcce-gs.yaml.template2 > bcce-gs.yaml.template1
	sed "s/_GS_INTERCOMP_JMS_USE_TRACE_/${gs_intercomp_jms_use_trace}/g" bcce-gs.yaml.template1 > bcce-gs.yaml.template2
	sed "s/_GS_INTERCOMP_INSTALLATION_PREFIX_/${gs_intercomp_installation_prefix}/g" bcce-gs.yaml.template2 > bcce-gs.yaml.template1
	sed "s/_GS_INTERCOMP_JMS_VERIFY_HOST_/${gs_intercomp_jms_verify_host}/g" bcce-gs.yaml.template1 > bcce-gs.yaml.template2
	sed "s/_GS_INTERCOMP_JMS_STRONG_CIPHER_ONLY_/${gs_intercomp_jms_strong_cipher_only}/g" bcce-gs.yaml.template2 > bcce-gs.yaml.template1
	sed "s/_GS_INTERCOMP_JMS_PASSWORD_/${gs_intercomp_jms_password}/g" bcce-gs.yaml.template1 > bcce-gs.yaml.template2
	sed "s/_GS_INTERCOMP_JMS_RECONNECT_DURATION_/${gs_intercomp_jms_reconnect_duration}/g" bcce-gs.yaml.template2 > bcce-gs.yaml.template1
	sed "s/_GS_INTERCOMP_JMS_TCF_/${gs_intercomp_jms_tcf}/g" bcce-gs.yaml.template1 > bcce-gs.yaml.template2
	sed "s/_GS_INTERCOMP_JMS_SECURE_/${gs_intercomp_jms_secure}/g" bcce-gs.yaml.template2 > bcce-gs.yaml.template1
	sed "s#_GS_INTERCOMP_JMS_JNDI_URL_#${gs_intercomp_jms_jndi_url}#g" bcce-gs.yaml.template1 > bcce-gs.yaml.template2
	sed "s/_GS_INTERCOMP_JMS_JNDI_USER_/${gs_intercomp_jms_jndi_user}/g" bcce-gs.yaml.template2 > bcce-gs.yaml.template1
	sed "s/_GS_INTERCOMP_JMS_JNDI_CF_/${gs_intercomp_jms_jndi_cf}/g" bcce-gs.yaml.template1 > bcce-gs.yaml.template2
	sed "s/_GS_INTERCOMP_INSTALLATION_NAME_/${gs_intercomp_installation_name}/g" bcce-gs.yaml.template2 > bcce-gs.yaml.template1
	sed "s/_GS_INTERCOMP_JMS_EXPECTED_HOST_NAME_/${gs_intercomp_jms_expected_host_name}/g" bcce-gs.yaml.template1 > bcce-gs.yaml.template2
	sed "s/_IMAGE_PULL_SECRETS_/${k8s_key_secret}/g" bcce-gs.yaml.template2 > bcce-gs.yaml.template1
	sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-gs.yaml.template1 > bcce-gs.yaml.template2
	sed "s/_BUILD_NUM_/${gs_build_num}/g" bcce-gs.yaml.template2 > bcce-gs.yaml.template1
	sed "s/_CONFIGSTORE_QA_AUTOMATION_/${bc_configstore_dbstore_cache_disable_for_qa_automation}/g" bcce-gs.yaml.template1 > bcce-gs.yaml
	sed "s/_GS_PORT_/${gs_port}/g" bcce-gs-svc.yaml.template > bcce-gs-svc.yaml.template1
	sed "s/_GS_SECURE_PORT_/${gs_secure_port}/g" bcce-gs-svc.yaml.template1 > bcce-gs-svc.yaml.template2
	sed "s/_GS_SECURE_CA_PORT_/${gs_secure_ca_port}/g" bcce-gs-svc.yaml.template2 > bcce-gs-svc.yaml.template1
	if [ "$k8s_env" = "2" ]; then
		sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-gs-svc.yaml.template1 > bcce-gs-svc.yaml.template2
		sed "s/_SECURITY_GROUP_ID_/${security_group_id}/g" bcce-gs-svc.yaml.template2 > bcce-gs-svc.yaml
	elif [ "$k8s_env" = "3" ]; then
		sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-gs-svc.yaml.template1 > bcce-gs-svc.yaml.template2
		sed "s/_RESOURCE_GROUP_/${resource_group}/g" bcce-gs-svc.yaml.template2 > bcce-gs-svc.yaml.template1
		sed "s/_PUBLIC_GS_IP_/${gs_host}/g" bcce-gs-svc.yaml.template1 > bcce-gs-svc.yaml
	elif [ "$k8s_env" = "4" ]; then
		sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-gs-svc.yaml.template1 > bcce-gs-svc.yaml.template2
		sed "s/_PUBLIC_GS_IP_/${gs_host}/g" bcce-gs-svc.yaml.template2 > bcce-gs-svc.yaml
	else
		sed "s/_NAMESPACE_/${k8s_namespace}/g" bcce-gs-svc.yaml.template1 > bcce-gs-svc.yaml
	fi
	rm -f bcce-gs.yaml.template1 bcce-gs.yaml.template2 bcce-gs-svc.yaml.template1 bcce-gs-svc.yaml.template2

	kubectl apply -f bcce-gs.yaml --namespace=${k8s_namespace}
	kubectl apply -f bcce-gs-svc.yaml --namespace=${k8s_namespace}
	cd ..
fi

echo "##########################################################################################"
echo "Deployment of TIBCO BusinessConnect Container Edition is finished now!!!"
echo "##########################################################################################"
echo

exit
