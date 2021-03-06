######################################################################
# Copyright © 2021. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash

source ./setenv.sh

if [ ! -f license_accepted.txt ]; then
        read -p "You must accept the License Agreement before proceeding. Press ENTER key to read the License. Press q to finish reading." yn
        less ../../TIB_auditsafe_1.1.0_license.txt

        while true; do
            read -p "Do you accept the license? (y/n) " yn
            case $yn in
                [Yy]* ) echo "You have accepted the license."; echo "License accepted on $(date)" > license_accepted.txt; break;;
                [Nn]* ) echo "you did not agree the License Agreement. Exiting the deployment!"; exit;;
                * ) echo "Please answer yes or no.";;
            esac
        done
fi

aus_found=`docker ps | grep bcce-aus`
if [ "$aus_found" = "" ]; then
	while true; do
		echo "Do you want to run TIBCO Auth-Server docker containers?"
		read -p "(y/n) " yn
		case $yn in
			[Yy]* ) install_aus=yes; break;;
			[Nn]* ) break;;
			* ) echo "Please answer yes or no.";;
		esac
	done
	if [ "$install_aus" = "yes" ]; then
		./docker-run-bcce-aus.sh
		echo "Waiting for the Auth Server service to start..."
		sleep 30
	fi
else
	echo "Found the Auth Server service:"
	echo "==============================================================================================================================================================="
	echo "$aus_found"
	echo "==============================================================================================================================================================="
	echo "You have to undeploy the Auth Server first if you want to deploy Auth Server service."
	echo "Skip the Auth Server deployment."
fi

while true; do
	echo "Do you want to run AuditSafe Data-Server docker containers?"
	read -p "(y/n) " yn
	case $yn in
		[Yy]* ) install_ds=yes; break;;
		[Nn]* ) break;;
		* ) echo "Please answer yes or no.";;
	esac
done

if [ "$install_ds" = "yes" ]; then
	./docker-run-auditsafe-ds.sh
fi


while true; do
	echo "Do you want to run TIBCO AuditSafe Web-Server docker container?"
	read -p "(y/n) " yn
	case $yn in
		[Yy]* ) install_ws=yes; break;;
		[Nn]* ) break;;
		* ) echo "Please answer yes or no.";;
	esac
done

if [ "$install_ws" = "yes" ]; then
	./docker-run-auditsafe-ws.sh
fi


echo "##########################################################################################"
echo "Starting the docker containers of TIBCO AuditSafe is finished now!!!"
echo "##########################################################################################"
echo

exit

