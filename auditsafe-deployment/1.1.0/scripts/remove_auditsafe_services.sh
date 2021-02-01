######################################################################
# Copyright © 2020. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash

# Read in the property from the deployment properties file.
while IFS="=" read name val
do
	if [ "$name" = "k8s_namespace" ]; then \
		k8s_namespace=$val
		continue;
	fi
done < ../config/deployment.properties


# All the service names: auditsafe-ws auditsafe-ds
for var in auditsafe-ws auditsafe-ds
do
	deployment_found=`kubectl get deployments --namespace=$k8s_namespace | grep $var`
	if [ ! "$deployment_found" = "" ]; then
		kubectl delete deployment $var --namespace=$k8s_namespace
	fi
	service_found=`kubectl get services --namespace=$k8s_namespace | grep $var`
	if [ ! "$service_found" = "" ]; then
		kubectl delete service $var --namespace=$k8s_namespace
	fi
done

secret_found=`kubectl get secrets --namespace=${k8s_namespace} | grep auditsafe-truststore`
if [ ! "$secret_found" = "" ]; then
	kubectl delete secret auditsafe-truststore --namespace=$k8s_namespace
fi

aus_found=`kubectl get services --namespace=$k8s_namespace | grep bcce-aus`
if [ ! "$aus_found" = "" ]; then
	while true; do
		echo "Do you want to undeploy TIBCO Auth Server service?"
		read -p "(y/n) " yn
		case $yn in
			[Yy]* ) remove_aus=yes; break;;
			[Nn]* ) break;;
			* ) echo "Please answer yes or no.";;
		esac
	done
	if [ "$remove_aus" = "yes" ]; then
		kubectl delete deployment bcce-aus --namespace=$k8s_namespace
		kubectl delete service bcce-aus --namespace=$k8s_namespace
		kubectl delete secret common-log4j2 --namespace=$k8s_namespace
		secret_found=`kubectl get secrets --namespace=${k8s_namespace} | grep docker-login`
		if [ ! "$secret_found" = "" ]; then
			kubectl delete secret docker-login --namespace=$k8s_namespace
		fi
	fi
else
	secret_found=`kubectl get secrets --namespace=${k8s_namespace} | grep common-log4j2`
	if [ ! "$secret_found" = "" ]; then
		kubectl delete secret common-log4j2 --namespace=$k8s_namespace
	fi
        secret_found=`kubectl get secrets --namespace=${k8s_namespace} | grep docker-login`
	if [ ! "$secret_found" = "" ]; then
		kubectl delete secret docker-login --namespace=$k8s_namespace
	fi
fi

