#!/bin/bash


FSREST_BUILD_NUM=009

if [ ! -f license_accepted.txt ]; then
	read -p "You must accept the License Agreement before proceeding. Press ENTER key to read the License. Press q to finish reading." yn
	less ../../TIB_fsrest_1.0.0_license.txt

	while true; do
	    read -p "Do you accept the license? (y/n) " yn
            case $yn in
                [Yy]* ) echo "You have accepted the license."; echo "License accepted on $(date)" > license_accepted.txt; break;;
                [Nn]* ) echo "you did not agree the License Agreement. Exiting the deployment!"; exit;;
                * ) echo "Please answer yes or no.";;
            esac
        done
fi

while true; do
	echo "Do you want to deploy TIBCO FSRest service?"
	read -p "(y/n) " yn
	case $yn in
		[Yy]* ) install_fsrest=yes; break;;
		[Nn]* ) break;;
		* ) echo "Please answer yes or no.";;
	esac
done

if [ "$install_fsrest" = "yes" ]; then
	source setenv.sh
	if [ "${DOCKER_REGISTRY}" = "" ]; then
		docker run --name fsrest --env-file=docker.env \
			-d -p 30100:8080 fsrest:${FSREST_BUILD_NUM}
	else
		docker run --name fsrest --env-file=docker.env \
			-d -p 30100:8080 ${DOCKER_REGISTRY}/fsrest:${FSREST_BUILD_NUM}
	fi
fi

echo "##########################################################################################"
echo "Starting the docker container of TIBCO FSRest is finished now!!!"
echo "##########################################################################################"
echo

exit

