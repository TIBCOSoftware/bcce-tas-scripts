#!/bin/bash

if [ ! -f license_accepted.txt ]; then
	read -p "You must accept the License Agreement before proceeding. Press ENTER key to read the License. Press q to finish reading." yn
	less ../TIB_auditsafe_1.1.0_license.txt

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
	rm -f $tfile
	exit 1
fi

# Check whether kubernetes is installed or not.
kubectl version > $tfile2 2>&1
if [ $? -ne 0 ]; then
	echo "##############################################################################"
	echo "Kubernetes isn't installed on this machine yet. The installation has to stop!!!"
	echo "##############################################################################"
	echo
	rm -f $tfile2
	exit 1
fi
rm -f $tfile $tfile2

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
	if [ "$name" = "database_driver" ]; then \
		database_driver=$val
		continue;
	fi
	if [ "$name" = "database_url" ]; then \
		database_url=$val
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
	if [ "$name" = "elasticsearch_keystore" ]; then \
		elasticsearch_keystore=$val
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
	if [ "$name" = "security_group_id" ]; then \
		security_group_id=$val
		continue;
	fi
	if [ "$name" = "resource_group" ]; then \
		resource_group=$val
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
	if [ "$name" = "aus_host" ]; then \
		aus_host=$val
		continue;
	fi
	if [ "$name" = "aus_port" ]; then \
		aus_port=$val
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
	if [ "$name" = "log4j2_file" ]; then \
		log4j2_file=$val
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
	if [ "$name" = "ws_host" ]; then \
		ws_host=$val
		continue;
	fi
	if [ "$name" = "ws_replicas" ]; then \
		ws_replicas=$val
		continue;
	fi
	if [ "$name" = "ds_replicas" ]; then \
		ds_replicas=$val
		continue;
	fi
	if [ "$name" = "aus_replicas" ]; then \
		aus_replicas=$val
		continue;
	fi
done < ../config/deployment.properties

# Set the secret docker-login
k8s_key_secret=docker-login

# String replacement
if [ "$aus_database_username" = "%database_username%" ]; then
	aus_database_username=${aus_database_username//%database_username%/$database_username}
fi
if [ "$aus_database_password" = "%database_password%" ]; then
	aus_database_password=${aus_database_password//%database_password%/$database_password}
fi
if [ "$aus_host" = "%host_ip%" ]; then
	aus_host=${aus_host//%host_ip%/$host_ip}
fi
if [ "$ds_host" = "%host_ip%" ]; then
	ds_host=${ds_host//%host_ip%/$host_ip}
fi
if [ "$ws_host" = "%host_ip%" ]; then
	ws_host=${ws_host//%host_ip%/$host_ip}
fi

if [ "$docker_repository" = "<docker_registry_ip>:<docker_registry_port>" ]; then
	echo "##############################################################################"
	echo "The docker_repository in deployment.properties must be set. Exiting process now!"
	echo "##############################################################################"
	echo
	exit 1
fi

if [ "$database_username" = "<username>" ]; then
	echo "##############################################################################"
	echo "The database_username in deployment.properties must be set. Exiting process now!"
	echo "##############################################################################"
	echo
	exit 1
fi

if [ "$database_password" = "<password>" ]; then
	echo "##############################################################################"
	echo "The database_password in deployment.properties must be set. Exiting process now!"
	echo "##############################################################################"
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
	echo "Which Kubernetes environment do you want to deploy TIBCO AuditSafe services?"
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

if [ "$host_ip" = "<host_ip>" ] && [ "$k8s_env" = "1" ]; then
	echo "##############################################################################"
	echo "The property host_ip isn't set properly."
	echo "Exit!"
	echo "##############################################################################"
	echo
	exit 1
fi

if [ "$k8s_env" = "1" ]; then
	cp -f ../services/ds/auditsafe-ds-svc.yaml.template.native ../services/ds/auditsafe-ds-svc.yaml.template
	cp -f ../services/ws/auditsafe-ws-svc.yaml.template.native ../services/ws/auditsafe-ws-svc.yaml.template
	cp -f ../services/aus/bcce-aus-svc.yaml.template.native ../services/aus/bcce-aus-svc.yaml.template
elif [ "$k8s_env" = "2" ]; then
	if [ "$security_group_id" = "<security_group_id>" ]; then
		echo "#################################################################################"
		echo "The security_group_id in deployment.properties must be set. Exiting process now!"
		echo "#################################################################################"
		echo
		exit 1
	fi
	cp -f ../services/ds/auditsafe-ds-svc.yaml.template.eks ../services/ds/auditsafe-ds-svc.yaml.template
	cp -f ../services/ws/auditsafe-ws-svc.yaml.template.eks ../services/ws/auditsafe-ws-svc.yaml.template
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
	if [ "$ds_host" = "%host_ip%" ]; then
		echo "##############################################################################"
		echo "The ds_host in deployment.properties must be set. Exiting process now!"
		echo "##############################################################################"
		echo
		exit 1
	fi
	if [ "$ws_host" = "%host_ip%" ]; then
		echo "##############################################################################"
		echo "The ws_host in deployment.properties must be set. Exiting process now!"
		echo "##############################################################################"
		echo
		exit 1
	fi
	cp -f ../services/ds/auditsafe-ds-svc.yaml.template.aks ../services/ds/auditsafe-ds-svc.yaml.template
	cp -f ../services/ws/auditsafe-ws-svc.yaml.template.aks ../services/ws/auditsafe-ws-svc.yaml.template
	cp -f ../services/aus/bcce-aus-svc.yaml.template.aks ../services/aus/bcce-aus-svc.yaml.template
else
	if [ "$aus_host" = "%host_ip%" ]; then
		echo "##############################################################################"
		echo "The aus_host in deployment.properties must be set. Exiting process now!"
		echo "##############################################################################"
		echo
		exit 1
	fi
	if [ "$ds_host" = "%host_ip%" ]; then
		echo "##############################################################################"
		echo "The ds_host in deployment.properties must be set. Exiting process now!"
		echo "##############################################################################"
		echo
		exit 1
	fi
	if [ "$ws_host" = "%host_ip%" ]; then
		echo "##############################################################################"
		echo "The ws_host in deployment.properties must be set. Exiting process now!"
		echo "##############################################################################"
		echo
		exit 1
	fi
	cp -f ../services/ds/auditsafe-ds-svc.yaml.template.gke ../services/ds/auditsafe-ds-svc.yaml.template
	cp -f ../services/ws/auditsafe-ws-svc.yaml.template.gke ../services/ws/auditsafe-ws-svc.yaml.template
	cp -f ../services/aus/bcce-aus-svc.yaml.template.gke ../services/aus/bcce-aus-svc.yaml.template
fi

# Create the log4j2 secret
./apply_secret_log4j2.sh

# Create the truststore secret
./apply_secret_truststore.sh

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
		rm -f bcce-aus.yaml.template1 bcce-aus.yaml.template2

		kubectl apply -f bcce-aus.yaml --namespace=${k8s_namespace}
		kubectl apply -f bcce-aus-svc.yaml --namespace=${k8s_namespace}
		# force to wait for Auth server deployment
		echo "Waiting for the Auth Server to start..."
		sleep 30
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

aus_namespace=`kubectl get services --all-namespaces | grep bcce-aus | awk '{print $1}'`
while true; do
	echo "Do you want to deploy TIBCO AuditSafe Data Server service?"
	read -p "(y/n) " yn
	case $yn in
		[Yy]* ) install_ds=yes; break;;
		[Nn]* ) break;;
		* ) echo "Please answer yes or no.";;
	esac
done

if [ "$install_ds" = "yes" ]; then
	echo "##################################################################"
	echo "Start to deploy the TIBCO AuditSafe Data Server"
	echo "##################################################################"
	echo
	cd ds
	while IFS="=" read name val
	do
		if [ "$name" = "ds_build_num" ]; then \
			ds_build_num=$val
		fi
	done < installation.properties

	sed "s/_REPLICAS_/${ds_replicas}/g" auditsafe-ds.yaml.template > auditsafe-ds.yaml.template2
	sed "s#_DOCKER_REPOSITORY_#${docker_repository}#g" auditsafe-ds.yaml.template2 > auditsafe-ds.yaml.template1
	sed "s#_DATABASE_URL_#${database_url}#g" auditsafe-ds.yaml.template1 > auditsafe-ds.yaml.template2
	sed "s/_DATABASE_DRIVER_/${database_driver}/g" auditsafe-ds.yaml.template2 > auditsafe-ds.yaml.template1
	sed "s/_DATABASE_USERNAME_/${database_username}/g" auditsafe-ds.yaml.template1 > auditsafe-ds.yaml.template2
	sed "s/_DATABASE_PASSWORD_/${database_password}/g" auditsafe-ds.yaml.template2 > auditsafe-ds.yaml.template1
	sed "s#_ELASTICSEARCH_HOST_#${elasticsearch_host}#g" auditsafe-ds.yaml.template1 > auditsafe-ds.yaml.template2
	sed "s/_ELASTICSEARCH_PORT_/\"${elasticsearch_port}\"/g" auditsafe-ds.yaml.template2 > auditsafe-ds.yaml.template1
	sed "s/_ELASTICSEARCH_USERNAME_/${elasticsearch_username}/g" auditsafe-ds.yaml.template1 > auditsafe-ds.yaml.template2
	sed "s/_ELASTICSEARCH_PASSWORD_/${elasticsearch_password}/g" auditsafe-ds.yaml.template2 > auditsafe-ds.yaml.template1
	sed "s/_ELASTICSEARCH_KEYSTORE_PASSWORD_/${elasticsearch_keystore_password}/g" auditsafe-ds.yaml.template1 > auditsafe-ds.yaml.template2
	sed "s#_ELASTICSEARCH_KEYSTORE_#${elasticsearch_keystore}#g" auditsafe-ds.yaml.template2 > auditsafe-ds.yaml.template1
	sed "s/_ELASTICSEARCH_TYPE_/${elasticsearch_type}/g" auditsafe-ds.yaml.template1 > auditsafe-ds.yaml.template2
	sed "s/_ELASTICSEARCH_SCHEMA_/${elasticsearch_schema}/g" auditsafe-ds.yaml.template2 > auditsafe-ds.yaml.template1
	sed "s/_IMAGE_PULL_SECRETS_/${k8s_key_secret}/g" auditsafe-ds.yaml.template1 > auditsafe-ds.yaml.template2
	sed "s/_NAMESPACE_/${k8s_namespace}/g" auditsafe-ds.yaml.template2 > auditsafe-ds.yaml.template1
	sed "s/_BUILD_NUM_/${ds_build_num}/g" auditsafe-ds.yaml.template1 > auditsafe-ds.yaml.template2
	sed "s/_NAMESPACE2_/${aus_namespace}/g" auditsafe-ds.yaml.template2 > auditsafe-ds.yaml.template1
	sed "s/_AUS_PORT_/${aus_port}/g" auditsafe-ds.yaml.template1 > auditsafe-ds.yaml
	sed "s/_NAMESPACE_/${k8s_namespace}/g" auditsafe-ds-svc.yaml.template > auditsafe-ds-svc.yaml.template1
	if [ "$k8s_env" = "2" ]; then
		sed "s/_DS_PORT_/${ds_port}/g" auditsafe-ds-svc.yaml.template1 > auditsafe-ds-svc.yaml.template2
		sed "s/_SECURITY_GROUP_ID_/${security_group_id}/g" auditsafe-ds-svc.yaml.template2 > auditsafe-ds-svc.yaml
	elif [ "$k8s_env" = "3" ]; then
		sed "s/_DS_PORT_/${ds_port}/g" auditsafe-ds-svc.yaml.template1 > auditsafe-ds-svc.yaml.template2
		sed "s/_RESOURCE_GROUP_/${resource_group}/g" auditsafe-ds-svc.yaml.template2 > auditsafe-ds-svc.yaml.template1
		sed "s/_PUBLIC_DS_IP_/${ds_host}/g" auditsafe-ds-svc.yaml.template1 > auditsafe-ds-svc.yaml
	elif [ "$k8s_env" = "4" ]; then
		sed "s/_DS_PORT_/${ds_port}/g" auditsafe-ds-svc.yaml.template1 > auditsafe-ds-svc.yaml.template2
		sed "s/_PUBLIC_DS_IP_/${ds_host}/g" auditsafe-ds-svc.yaml.template2 > auditsafe-ds-svc.yaml
	else
		sed "s/_DS_PORT_/${ds_port}/g" auditsafe-ds-svc.yaml.template1 > auditsafe-ds-svc.yaml
	fi
	rm -f auditsafe-ds.yaml.template1 auditsafe-ds.yaml.template2 auditsafe-ds-svc.yaml.template1 auditsafe-ds-svc.yaml.template2

	kubectl apply -f auditsafe-ds.yaml
	kubectl apply -f auditsafe-ds-svc.yaml
	cd ..
fi

while true; do
	echo "Do you want to deploy TIBCO AuditSafe Web Server service?"
	read -p "(y/n) " yn
	case $yn in
		[Yy]* ) install_ws=yes; break;;
		[Nn]* ) break;;
		* ) echo "Please answer yes or no.";;
	esac
done

if [ "$install_ws" = "yes" ]; then
	if [ "$k8s_env" = "2" ]; then
		while IFS="=" read name val
		do
			if [ "$name" = "ds_host" ]; then \
				ds_host=$val
				continue;
			fi
		done < ../config/deployment.properties
		if [ "$ds_host" = "%host_ip%" ]; then
			echo "##############################################################################"
			echo "The ds_host in deployment.properties must be set. Exiting process now!"
			echo "##############################################################################"
			echo
			exit 1
		fi
	fi

	echo "##################################################################"
	echo "Start to deploy the TIBCO AuditSafe Web Server"
	echo "##################################################################"
	echo
	cd ws
	while IFS="=" read name val
	do
		if [ "$name" = "ws_build_num" ]; then \
			ws_build_num=$val
		fi
	done < installation.properties

	sed "s/_REPLICAS_/${ws_replicas}/g" auditsafe-ws.yaml.template > auditsafe-ws.yaml.template2
	sed "s#_DOCKER_REPOSITORY_#${docker_repository}#g" auditsafe-ws.yaml.template2 > auditsafe-ws.yaml.template1
	sed "s#_DATABASE_URL_#${database_url}#g" auditsafe-ws.yaml.template1 > auditsafe-ws.yaml.template2
	sed "s/_DATABASE_DRIVER_/${database_driver}/g" auditsafe-ws.yaml.template2 > auditsafe-ws.yaml.template1
	sed "s/_DATABASE_USERNAME_/${database_username}/g" auditsafe-ws.yaml.template1 > auditsafe-ws.yaml.template2
	sed "s/_DATABASE_PASSWORD_/${database_password}/g" auditsafe-ws.yaml.template2 > auditsafe-ws.yaml.template1
	sed "s#_ELASTICSEARCH_HOST_#${elasticsearch_host}#g" auditsafe-ws.yaml.template1 > auditsafe-ws.yaml.template2
	sed "s/_ELASTICSEARCH_PORT_/\"${elasticsearch_port}\"/g" auditsafe-ws.yaml.template2 > auditsafe-ws.yaml.template1
	sed "s/_ELASTICSEARCH_USERNAME_/${elasticsearch_username}/g" auditsafe-ws.yaml.template1 > auditsafe-ws.yaml.template2
	sed "s/_ELASTICSEARCH_PASSWORD_/${elasticsearch_password}/g" auditsafe-ws.yaml.template2 > auditsafe-ws.yaml.template1
	sed "s/_ELASTICSEARCH_KEYSTORE_PASSWORD_/${elasticsearch_keystore_password}/g" auditsafe-ws.yaml.template1 > auditsafe-ws.yaml.template2
	sed "s#_ELASTICSEARCH_KEYSTORE_#${elasticsearch_keystore}#g" auditsafe-ws.yaml.template2 > auditsafe-ws.yaml.template1
	sed "s/_ELASTICSEARCH_TYPE_/${elasticsearch_type}/g" auditsafe-ws.yaml.template1 > auditsafe-ws.yaml.template2
	sed "s/_ELASTICSEARCH_SCHEMA_/${elasticsearch_schema}/g" auditsafe-ws.yaml.template2 > auditsafe-ws.yaml.template1
	sed "s/_IMAGE_PULL_SECRETS_/${k8s_key_secret}/g" auditsafe-ws.yaml.template1 > auditsafe-ws.yaml.template2
	sed "s/_NAMESPACE_/${k8s_namespace}/g" auditsafe-ws.yaml.template2 > auditsafe-ws.yaml.template1
	sed "s/_BUILD_NUM_/${ws_build_num}/g" auditsafe-ws.yaml.template1 > auditsafe-ws.yaml.template2
	sed "s/_NAMESPACE2_/${aus_namespace}/g" auditsafe-ws.yaml.template2 > auditsafe-ws.yaml.template1
	sed "s/_AUS_PORT_/${aus_port}/g" auditsafe-ws.yaml.template1 > auditsafe-ws.yaml.template2
	sed "s/_AUDITSAFE_DS_PORT_/${ds_port}/g" auditsafe-ws.yaml.template2 > auditsafe-ws.yaml.template1
	sed "s/_AUDITSAFE_DS_HOST_/${ds_host}/g" auditsafe-ws.yaml.template1 > auditsafe-ws.yaml
	sed "s/_NAMESPACE_/${k8s_namespace}/g" auditsafe-ws-svc.yaml.template > auditsafe-ws-svc.yaml.template1
	if [ "$k8s_env" = "2" ]; then
		sed "s/_WS_PORT_/${ws_port}/g" auditsafe-ws-svc.yaml.template1 > auditsafe-ws-svc.yaml.template2
		sed "s/_SECURITY_GROUP_ID_/${security_group_id}/g" auditsafe-ws-svc.yaml.template2 > auditsafe-ws-svc.yaml
	elif [ "$k8s_env" = "3" ]; then
		sed "s/_WS_PORT_/${ws_port}/g" auditsafe-ws-svc.yaml.template1 > auditsafe-ws-svc.yaml.template2
		sed "s/_RESOURCE_GROUP_/${resource_group}/g" auditsafe-ws-svc.yaml.template2 > auditsafe-ws-svc.yaml.template1
		sed "s/_PUBLIC_WS_IP_/${ws_host}/g" auditsafe-ws-svc.yaml.template1 > auditsafe-ws-svc.yaml
	elif [ "$k8s_env" = "4" ]; then
		sed "s/_WS_PORT_/${ws_port}/g" auditsafe-ws-svc.yaml.template1 > auditsafe-ws-svc.yaml.template2
		sed "s/_PUBLIC_WS_IP_/${ws_host}/g" auditsafe-ws-svc.yaml.template2 > auditsafe-ws-svc.yaml
	else
		sed "s/_WS_PORT_/${ws_port}/g" auditsafe-ws-svc.yaml.template1 > auditsafe-ws-svc.yaml
	fi
	rm -f auditsafe-ws.yaml.template1 auditsafe-ws.yaml.template2 auditsafe-ws-svc.yaml.template1 auditsafe-ws-svc.yaml.template2

	kubectl apply -f auditsafe-ws.yaml
	kubectl apply -f auditsafe-ws-svc.yaml
	cd ..
fi

echo "##########################################################################################"
echo "Deploying TIBCO AuditSafe finished now!!!"
echo "##########################################################################################"
echo

