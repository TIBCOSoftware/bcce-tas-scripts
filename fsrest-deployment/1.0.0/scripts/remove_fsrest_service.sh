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

deployment_found=`kubectl get deployments --namespace=$k8s_namespace | grep fsrest`
if [ ! "$deployment_found" = "" ]; then
	kubectl delete deployment fsrest --namespace=$k8s_namespace
fi

service_found=`kubectl get services --namespace=$k8s_namespace | grep fsrest`
if [ ! "$service_found" = "" ]; then
	kubectl delete service fsrest --namespace=$k8s_namespace
fi
