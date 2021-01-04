#!/bin/bash

# Read in the property from the deployment properties file.
while IFS="=" read name val
do
	if [ "$name" = "k8s_namespace" ]; then \
		k8s_namespace=$val
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
done < ../config/deployment.properties

# Set the secret docker-login
k8s_key_secret=docker-login

# Check whether the properties are set or not
if [ "${k8s_namespace}" = "" ]; then
	echo "###################################################################################"
	echo "The property k8s_namespace isn't set in the ../config/deployment.properties!"
	echo "###################################################################################"
	exit 1
fi

if [ "${docker_repository}" == "" ]; then
	echo "##############################################################################"
	echo "The property docker_repository in the config/deployment isn't set!"
	echo "##############################################################################"
	exit 1
fi

if [ "${docker_username}" == "" ]; then
	echo "##############################################################################"
	echo "The property docker_username in the config/deployment isn't set!"
	echo "##############################################################################"
	exit 1
fi

while true; do
	read -p "Please enter the password for the Docker login user ${docker_username}. " password
	if [ "${password}" != "" ]; then
		break
	fi
done

# Create or update the secret for Docker registry login
sudo kubectl create secret docker-registry ${k8s_key_secret} --namespace=${k8s_namespace} --docker-server=${docker_repository} --docker-username=${docker_username} --docker-password=${password} --dry-run -o yaml | sudo kubectl apply -f -

