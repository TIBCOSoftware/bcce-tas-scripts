######################################################################
# Copyright © 2021. TIBCO Software Inc.
# This file is subject to the license terms contained
# in the license file that is distributed with this file.
######################################################################
#!/bin/bash

if [ ! -f license_accepted.txt ]; then
	read -p "You must accept the License Agreement before proceeding. Press ENTER key to read the License. Press q to finish reading." yn
	less ../../TIB_bcce_1.1.0_license.txt

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
		echo "Do you want to run TIBCO Auth Server docker container?"
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
	echo "Do you want to run TIBCO BCCE Server docker containers?"
	echo "  1. ConfigStore Management Server"
	echo "  2. Admin Server"
	read -p "(y/n) " yn
	case $yn in
		[Yy]* ) install_others=yes; break;;
		[Nn]* ) break;;
		* ) echo "Please answer yes or no.";;
	esac
done

if [ "$install_others" = "yes" ]; then
	./docker-run-bcce-cms.sh
	./docker-run-bcce-as.sh
fi


while true; do
	echo "Do you want to run TIBCO BCCE Server docker containers?"
	echo "  3. Interior Server"
	echo "  4. Poller Server"
	echo "Please make sure the JMS Server settings are done properly from the BCCE Admin UI."
	echo "Otherwise, the Poller Server and Interior Server won't work."
	read -p "(y/n) " yn
	case $yn in
		[Yy]* ) install_others2=yes; break;;
		[Nn]* ) break;;
		* ) echo "Please answer yes or no.";;
	esac
done

if [ "$install_others2" = "yes" ]; then
	./docker-run-bcce-is.sh
	./docker-run-bcce-ps.sh
fi


while true; do
	echo "Do you want to deploy TIBCO BCCE Gateway Server service?"
	echo "Please make sure that you have downloaded the GSToken.zip from Admin UI, extracted it"
	echo "in a folder and set the property gstoken_unzip in the deployment.properties file."
	echo "Otherwise, the Gateway Server won't work."
	read -p "(y/n) " yn
	case $yn in
		[Yy]* ) install_gs=yes; break;;
		[Nn]* ) break;;
		* ) echo "Please answer yes or no.";;
	esac
done

if [ "$install_gs" = "yes" ]; then
	./docker-run-bcce-gs.sh
fi

echo "##########################################################################################"
echo "Starting the docker containers of TIBCO BusinessConnect Cloud Edition is finished now!!!"
echo "##########################################################################################"
echo

exit

