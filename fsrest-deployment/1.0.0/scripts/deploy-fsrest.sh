######################################################################
# Copyright © 2020. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash


if [ ! -f license_accepted.txt ]; then
	read -p "You must accept the License Agreement before proceeding. Press ENTER key to read the License. Press q to finish reading." yn
	less ../TIB_fs-restapi_1.0.0_license.txt

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
	if [ "$name" = "auditsafe_ds_port" ]; then \
		auditsafe_ds_port=$val
		continue;
	fi
	if [ "$name" = "fsrest_replicas" ]; then \
		fsrest_replicas=$val
		continue;
	fi
done < ../config/deployment.properties

# Set the secret docker-login
k8s_key_secret=docker-login

if [ "$docker_repository" = "" ]; then
	echo "##############################################################################"
	echo "The docker_repository in deployment.properties must be set. Exiting process now!"
	echo "##############################################################################"
	echo
	exit 1
fi

if [ $? -ne 0 ]; then
        echo "##############################################################################"
        echo "Docker login error, Exiting process now!"
        echo "##############################################################################"
        echo
        exit 1
fi

# Find the namespace that the bcce-cms was deployed on
cms_namespace=`kubectl get services --all-namespaces | grep bcce-cms | awk '{print $1}'`
if [ "$cms_namespace" = "" ]; then
	echo "##############################################################################"
	echo "It looks like the BCCE wasn't deployed on this Kubernetes cluster yet."
	echo "Please make sure that both the BCCE and FSRest services should be deployed"
	echo "under a same Kubernetes namespace."
	echo "##############################################################################"
	echo
else
	if [ ! "$cms_namespace" = "$k8s_namespace" ]; then
		echo "##############################################################################"
		echo "The Kubernetes namespace '$cms_namespace' that the BCCE was deployed on is "
		echo "different from '$k8s_namespace' that you set for the FSRest deployment."
		echo "You have to deploy the BCCE and FSRest services under a same Kubernetes"
		echo "namespace. Exiting process now!"
		echo "##############################################################################"
		echo
		exit 1
	fi
fi

while true; do
	echo "Which the Kubernetes environment do you want to deploy TIBCO BCCE services?"
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

ds_namespace=`kubectl get services --all-namespaces | grep auditsafe-ds |awk '{print $1}'`
if [ "$ds_namespace" = "" ]; then
	echo "##############################################################################"
	echo "The AuditSafe Data Server must be deployed before FSRest. Exiting process now!"
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


echo "##########################################################################"
echo "Deploying the TIBCO FSRest Server"
echo "##########################################################################"
echo
cd ../services/fsrest
while IFS="=" read name val
do
	if [ "$name" = "fsrest_build_num" ]; then \
		fsrest_build_num=$val
	fi
done < installation.properties

sed "s/_REPLICAS_/${fsrest_replicas}/g" fsrest.yaml.template > fsrest.yaml.template1
sed "s#_DOCKER_REPOSITORY_#${docker_repository}#g" fsrest.yaml.template1 > fsrest.yaml.template2
sed "s/_BUILD_NUM_/${fsrest_build_num}/g" fsrest.yaml.template2 > fsrest.yaml.template1
sed "s/_IMAGE_PULL_SECRETS_/${k8s_key_secret}/g" fsrest.yaml.template1 > fsrest.yaml.template2
sed "s/_NAMESPACE_/${k8s_namespace}/g" fsrest.yaml.template2 > fsrest.yaml.template1
sed "s#_NAMESPACE2_#${ds_namespace}#g" fsrest.yaml.template1 > fsrest.yaml.template2
sed "s/_AUDITSAFE_DS_PORT_/${auditsafe_ds_port}/g" fsrest.yaml.template2 > fsrest.yaml
sed "s/_NAMESPACE_/${k8s_namespace}/g" fsrest-svc.yaml.template > fsrest-svc.yaml
rm -f fsrest.yaml.template1 fsrest.yaml.template2

kubectl apply -f fsrest.yaml --namespace=${k8s_namespace}
kubectl apply -f fsrest-svc.yaml --namespace=${k8s_namespace}

echo "##########################################################################################"
echo "Deployment of TIBCO FSRest is finished now!!!"
echo "##########################################################################################"
echo

exit
