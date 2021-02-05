######################################################################
# Copyright © 2021. TIBCO Software Inc.
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
	if [ "$name" = "elasticsearch_keystore" ]; then \
		elasticsearch_keystore=$val
		continue;
	fi
done < ../config/deployment.properties

if [ "${k8s_namespace}" = "" ]; then
	echo "###################################################################################"
	echo "The property k8s_namespace isn't set in the ../config/deployment.properties!"
	echo "###################################################################################"
	exit 1
fi

# Check whether the file exists or not
if [[ ! $elasticsearch_keystore =~ ^/ ]]; then
	elasticsearch_keystore=../$elasticsearch_keystore
	elasticsearch_keystore=`echo "$(cd "$(dirname "$elasticsearch_keystore")"; pwd)/$(basename "$elasticsearch_keystore")"`
fi
if [ ! -f "${elasticsearch_keystore}" ]; then
	echo "##############################################################################"
	echo "The file ${elasticsearch_keystore} doesn't exist!"
	echo "##############################################################################"
	exit 1
fi

# Create or update the secret for truststore file
kubectl create secret generic auditsafe-truststore --namespace=${k8s_namespace} --from-file=${elasticsearch_keystore} --dry-run -o yaml | kubectl apply -f -

