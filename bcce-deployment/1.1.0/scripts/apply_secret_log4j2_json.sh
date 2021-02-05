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
	if [ "$name" = "log4j2_json_file" ]; then \
		log4j2_json_file=$val
		continue;
	fi
done < ../config/deployment.properties

if [ "${k8s_namespace}" = "" ]; then
	echo "###################################################################################"
	echo "The property k8s_namespace isn't set in the ../config/deployment.properties!"
	echo "###################################################################################"
	exit 1
fi

# Check log4j2.json file
if [[ ! $log4j2_json_file =~ ^/ ]]; then
	log4j2_json_file=../$log4j2_json_file
	log4j2_json_file=`echo "$(cd "$(dirname "$log4j2_json_file")"; pwd)/$(basename "$log4j2_json_file")"`
fi
if [ ! -f ${log4j2_json_file} ]; then
	echo "##############################################################################"
	echo "The file ${log4j2_json_file} doesn't exist!"
	echo "##############################################################################"
	exit 1
fi

# Create or update the secret for log4j2 file
kubectl create secret generic common-log4j2-json --namespace=${k8s_namespace} --from-file=${log4j2_json_file} --dry-run -o yaml | kubectl apply -f -

