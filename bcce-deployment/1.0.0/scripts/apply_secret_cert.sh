#!/bin/bash
 
# Read in the property from the deployment properties file.
while IFS="=" read name val
do
	if [ "$name" = "k8s_namespace" ]; then \
		k8s_namespace=$val
		continue;
	fi
	if [ "$name" = "host_key" ]; then \
		host_key=$val
		continue;
	fi
	if [ "$name" = "peer_cert" ]; then \
		peer_cert=$val
		continue;
	fi
	if [ "$name" = "gstoken_unzip" ]; then \
		gstoken_unzip=$val
		continue;
	fi
done < ../config/deployment.properties

if [ "${k8s_namespace}" = "" ]; then
	echo "###################################################################################"
	echo "The property k8s_namespace isn't set in the ../config/deployment.properties!"
	echo "###################################################################################"
	exit 1
fi


# Check whether the gstoken_unzip exists or not
if [ ! -d ${gstoken_unzip} ]; then
	echo "##############################################################################"
	echo "The path ${gstoken_unzip} doesn't exist!"
	echo "##############################################################################"
	exit 1
fi

host_key=${host_key//%gstoken_unzip%/$gstoken_unzip}
peer_cert=${peer_cert//%gstoken_unzip%/$gstoken_unzip}

# Check whether the files exist or not.
if [ "${host_key}" == "" ] || [ ! -f "${host_key}" ]; then
	echo "##############################################################################"
	echo "The file ${host_key} doesn't exist!"
	echo "##############################################################################"
	exit 1
fi

if [ "${peer_cert}" == "" ] || [ ! -f "${peer_cert}" ]; then
	echo "##############################################################################"
	echo "The file ${peer_cert} doesn't exist!"
	echo "##############################################################################"
	exit 1
fi

# Create or update the secret for key/cert files
sudo kubectl create secret generic bcce-gs-config --namespace=${k8s_namespace} --from-file=${host_key} --from-file=${peer_cert} --dry-run -o yaml | sudo kubectl apply -f -

