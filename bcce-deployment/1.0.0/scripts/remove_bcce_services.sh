#!/bin/bash

# Read in the property from the deployment properties file.
while IFS="=" read name val
do
	if [ "$name" = "k8s_namespace" ]; then \
		k8s_namespace=$val
		continue;
	fi
done < ../config/deployment.properties


# All the service names: bcce-as bcce-cms bcce-gs bcce-is bcce-ps
for var in bcce-as bcce-cms bcce-gs bcce-is bcce-ps
do
	if [ "$var" != "bcce-is" ] && [ "$var" != "bcce-ps" ]; then
		sudo kubectl delete service $var --namespace=$k8s_namespace
	fi
	sudo kubectl delete deployment $var --namespace=$k8s_namespace
done

for each in $(sudo kubectl get secrets --namespace=${k8s_namespace} |grep docker-login |awk '{print $1}');
do
	if [ "$each" = "docker-login" ]; then
		sudo kubectl delete secret $each
	fi
done

sudo kubectl delete secret bcce-log4j2 --namespace=${k8s_namespace}
sudo kubectl delete secret bcce-gs-config --namespace=${k8s_namespace}


