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
	sudo kubectl delete deployment $var --namespace=$k8s_namespace
	sudo kubectl delete service $var --namespace=$k8s_namespace
done

sudo kubectl delete secret auditsafe-log4j2 --namespace=$k8s_namespace
sudo kubectl delete secret auditsafe-truststore --namespace=$k8s_namespace

