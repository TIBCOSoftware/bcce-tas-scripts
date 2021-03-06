#!/bin/bash

if [ ! -f license_accepted.txt ]; then
	read -p "You must accept the License Agreement before proceeding. Press ENTER key to read the License. Press q to finish reading." yn
	less ../TIB_auditsafe_1.0.0_license.txt

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
sudo kubectl version > $tfile2 2>&1
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
	if [ "$name" = "ws_replicas" ]; then \
		ws_replicas=$val
		continue;
	fi
	if [ "$name" = "ds_replicas" ]; then \
		ds_replicas=$val
		continue;
	fi
done < ../config/deployment.properties

# Set the secret docker-login
k8s_key_secret=docker-login

if [ "$docker_repository" = "<docker_registry_ip>:5000" ]; then
	echo "##############################################################################"
	echo "The docker_repository in deployment.properties must be set. Exit now!"
	echo "##############################################################################"
	echo
	exit 1
fi

if [ "$database_username" = "<username>" ]; then
	echo "##############################################################################"
	echo "The database_username in deployment.properties must be set. Exit now!"
	echo "##############################################################################"
	echo
	exit 1
fi

if [ "$database_password" = "<password>" ]; then
	echo "##############################################################################"
	echo "The database_password in deployment.properties must be set. Exit now!"
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
for each in $(sudo kubectl get namespaces |grep ${k8s_namespace} |awk '{print $1}');
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
	sudo kubectl create namespace ${k8s_namespace}
fi

# Create the log4j2 secret
./apply_secret_log4j2.sh

# Create the truststore secret
./apply_secret_truststore.sh

# Check the docker-login secret
for each in $(sudo kubectl get secrets --namespace $k8s_namespace |grep $k8s_key_secret |awk '{print $1}');
do
	if [ "$each" = "$k8s_key_secret" ]; then
		break
	fi
done
if [ "$each" != "$k8s_key_secret" ]; then
	./apply_secret_docker_login.sh
fi

cd ../services
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
	echo "Start to build the TIBCO AuditSafe Data Server Docker image"
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
	sed "s/_BUILD_NUM_/${ds_build_num}/g" auditsafe-ds.yaml.template1 > auditsafe-ds.yaml
	sed "s/_DS_PORT_/${ds_port}/g" auditsafe-ds-svc.yaml.template > auditsafe-ds-svc.yaml.template1
	sed "s/_NAMESPACE_/${k8s_namespace}/g" auditsafe-ds-svc.yaml.template1 > auditsafe-ds-svc.yaml
	rm -f auditsafe-ds.yaml.template1 auditsafe-ds.yaml.template2 auditsafe-ds-svc.yaml.template1

	sudo kubectl apply -f auditsafe-ds.yaml
	sudo kubectl apply -f auditsafe-ds-svc.yaml
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
	echo "##################################################################"
	echo "Start to build the TIBCO AuditSafe Web Server Docker image"
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
	sed "s/_BUILD_NUM_/${ws_build_num}/g" auditsafe-ws.yaml.template1 > auditsafe-ws.yaml
	sed "s/_WS_PORT_/${ws_port}/g" auditsafe-ws-svc.yaml.template > auditsafe-ws-svc.yaml.template1
	sed "s/_NAMESPACE_/${k8s_namespace}/g" auditsafe-ws-svc.yaml.template1 > auditsafe-ws-svc.yaml
	rm -f auditsafe-ws.yaml.template1 auditsafe-ws.yaml.template2 auditsafe-ws-svc.yaml.template1

	sudo kubectl apply -f auditsafe-ws.yaml
	sudo kubectl apply -f auditsafe-ws-svc.yaml
	cd ..
fi

echo "##########################################################################################"
echo "Deploying TIBCO AuditSafe finished now!!!"
echo "##########################################################################################"
echo

