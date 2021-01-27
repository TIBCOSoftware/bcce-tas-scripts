Copyright (c) 2020 TIBCO Software Inc. All Rights Reserved


+++++ About Deployment Scripts for TIBCO BusinessConnect Container Edition and TIBCO AuditSafe +++++


TIBCO BusinessConnect™ Container Edition (BCCE) is the containerized edition of TIBCO BusinessConnect. It allows enterprises to host a business-to-business trading community with their trading partners in the cloud of their choice.
BCCE requires TIBCO® AuditSafe (AuditSafe) as a mandatory component. AuditSafe is a TIBCO product used to record the audit trail of business transactions from any applications. AuditSafe is shipped with BCCE.
In order to process EDI documents, BCCE requires a separately licensed product, namely TIBCO BusinessConnect™ Container Edition - EDI Protocol (BCCE-EDI). BCCE-EDI contains a module called FSRest, which is the engine that performs the EDI document validation and translation services for BCCE.


This read-me contains the instructions necessary to use the sample deployment scripts for launching the docker images of BCCE, AuditSafe, and FSRest, the validation engine of BCCE-EDI to your Kubernetes environments. 


Assumptions:
- You have already generated the docker images of BCCE, AuditSafe (both are shipped with BCCE), and FSRest (shipped with BCCE-EDI Protocol).
- You have installed and configured the necessary Kubernetes clusters in your cloud of choice.




+++++ Instructions for TIBCO BusinessConnect Container Edition +++++


Prerequisites:
========================================================================================================
1. TIBCO Enterprise Message Service™ (EMS): Install and configure EMS for TIBCO BusinessConnect™ 
   Container Edition (BCCE). The URL for the following properties in the file 
   TIBCO_HOME/ems/8.x/samples/config/factories.conf must be 
   updated to the EMS machine IP:
   ( ConnectionFactory, GenericConnectionFactory, TopicConnectionFactory, QueueConnectionFactory )
     *** localhost and local hostname won't work.
2. MySQL: Install MySQL database and provide the login credentials first.
   (1) Edit the config file: /etc/my.cnf
        [mysqld]
        ...
        #Set mysql max db connection to 2000
        max_connections = 2000
        #Set mysql max db connection errors to 2000
        max_connect_errors = 2000
        #Set default timezone
        default-time-zone = '-05:00'
        #Set log_bin_trust_function_creators to 1 (This is special only for AWS RDS)
        log_bin_trust_function_creators=1
      Restart mysql.
      *** If you use the AWS RDS, you don't need to set the properties above except the parameter
          log_bin_trust_function_creators.
   (2) Set access permission:
        GRANT ALL PRIVILEGES ON *.* TO '<your_username>'@'%' IDENTIFIED BY '<your_password>';
        FLUSH PRIVILEGES;
   (3) Note: Make sure mysql port(default 3306) of the mysql host machine is opened        
3. Docker: Install Docker for the Docker images.
4. kubectl: Install kubectl for the deployment on the Kubernetes cluster.
5. Kubernetes cluster: Install Kubernetes cluster for deploying and running the BCCE services.
6. TIBCO® AuditSafe: Required to be deployed and running to post the audit logs from BCCE.
7. Mount NFS folder: Required for Poller Server where Kubernetes can use the same network folder
   to access files for polling.


========================================================================================================




Deploying steps:
========================================================================================================
1. Configure and update all the property values in the deployment.properties and the values <xxxxx>
   MUST be replaced.
2. Use the script deploy-bcce.sh to deploy the BCCE services onto the Kubernetes cluster.
   a. Deploy the Auth Server, Admin Server and CMS Server first and then navigate to 
      http://master-node-ip:30000 to log in with username(admin) and password(Password) as credentials.
      (1) Set JNDI Context URLs of Private Process JMS and intercomponent JMS properly for Interior
          Server (IS) to use.
      (2) Create a host under Hosts.
      (3) Add the http under Gateway.
   b. Deploy the IS and Poller Server (PS).
   c. Go to the http://master-node-ip:30000/systemsettings/general URL to export the Gateway Server (GS) 
      configuration to get GSToken.zip file that includes the intercomProps, hostKey and peerCert files
      that are needed by the Gateway Server deployment.
   d. Deploy the GS at last since it needs the hostKey, peerCert and intercomProps to be generated.


========================================================================================================




Undeploying steps:
========================================================================================================
1. Run the script remove_bcce_services.sh to remove all the BCCE services/deployments.
2. Log in to MySQL to delete the database <dbname> which is set in your deployment.properties.


========================================================================================================




List of files
========================================================================================================
scripts:
deploy-bcce.sh


apply_secret_cert.sh
apply_secret_log4j2.sh
apply_secret_log4j2_json.sh
apply_secret_docker_login.sh
remove_bcce_services.sh


config:
deployment.properties
log4j2.xml
log4j2.json


========================================================================================================


Files
========================================================================================================
deploy_bcce.sh:
    It deploys the BCCE services onto the Kubernetes cluster.


deployment.properties:
     It contains all the properties that the user must set before pulling the BCCE's Docker images and
deploying them to the Kubernetes cluster.


log4j2.xml:
     It is the default xml file for creating the Kubernetes log4j2 secret.


log4j2.json:
     It is the default json file for creating the Kubernetes log4j2_json secret.


apply_secret_log4j2.sh:
     It creates the Kubernetes secret log4j2 with the log4j2.xml. 


apply_secret_log4j2_json.sh:
     It creates the Kubernetes secret log4j2_json with the log4j2.json. 


apply_secret_cert.sh:
     It creates the Kubernetes secret bcce-gs-config for two key/cert files.


apply_secret_docker_login.sh:
     It creates the Kubernetes secret Docker-registry for Docker login.


remove_bcce_services.sh:
     It deletes all the BCCE services and deployments.


========================================================================================================


kubectl commands:
========================================================================================================
1. kubectl get nodes (Gets all the machine nodes)
2. kubectl get secrets --all-namespaces
3. kubectl get pods --all-namespaces (Gets all the pods for all the namespaces)
4. kubectl get pods (Gets all the pods for the default namespace)
5. kubectl get services --all-namespaces (Gets all the services for all the namespaces)
6. kubectl get deployments --all-namespaces (Gets all the deployments for all the namespaces)
7. kubectl delete pod|service|deployment pod-id|service-name|deployment-name (Deletes the object) 
     *** The service-name and deployment-name are bcce-as, bcce-cms, bcce-is, bcce-ps, and bcce-gs.
8. kubectl logs pod-id -c service-name --follow (Gets the log of the pod)
9. kubectl exec -it pod-id bash (Gets into the environment of the pod)


========================================================================================================






+++++ Instructions for TIBCO AuditSafe +++++




Prerequisites:
========================================================================================================
1. ElasticSearch: Install ElasticSearch for storing BCCE logs.
2. MySQL: Install MySQL database and provide its login credentials first.
3. Docker: Install Docker for building the Docker images.
4. kubectl: Install kubectl for the deployment on the Kubernetes cluster.
5. Kubernetes cluster: Install Kubernetes cluster for deploying and running the AuditSafe services.


========================================================================================================


Deploying steps:
========================================================================================================
1. Configure and update the property values in the deployment.properties and the value <xxxxx>
   MUST be replaced.
3. Use the script deploy-auditsafe.sh to deploy the AuditSafe services onto the Kubernetes cluster.


========================================================================================================


Undeploying steps: 
========================================================================================================
1. Run the script remove_auditsafe_services.sh to remove all the AuditSafe services/deployments.
2. Log in to MySQL to delete the database <dbname> which is set in your deployment.properties.


========================================================================================================




List of files
========================================================================================================
scripts:
deploy-auditsafe.sh


apply_secret_log4j2.sh
apply_secret_truststore.sh
apply_secret_docker_login.sh
remove_auditsafe_services.sh


config:
deployment.properties
log4j2.xml
truststore.jks
========================================================================================================


Files
========================================================================================================
build-images.sh:
    It creates the AuditSafe Docker images and push the images to the Docker repository.


deploy-auditsafe.sh:
    It deploys the AuditSafe services onto the Kubernetes cluster.


deployment.properties:
     It contains all the properties that you must set before building the BCCE's Docker images and
deploying to the Kubernetes cluster.


log4j2.xml:
     It is the default xml file for creating the Kubernetes log4j2 secret.


truststore.jks:
     It is the empty file for creating the Kubernetes truststore secret. You can update this file and 
     then run apply_secret_truststore.sh to update the secret.


apply_secret_log4j2.sh:
     It creates the Kubernetes secret log4j2 with the log4j2.xml. 


apply_secret_truststore.sh:
     It creates the Kubernetes secret truststore with the truststore.jks. 


apply_secret_docker_login.sh:
     It creates the Kubernetes secret Docker-registry for Docker login.


remove_auditsafe_services.sh:
     It deletes all the BCCE services and deployments.


========================================================================================================




+++++ Instructions for FSRest, the EDI processing engine shipped with TIBCO BusinessConnect Container Edition - EDI Protocol +++++




Prerequisites:
========================================================================================================
1. TIBCO® BCCE: Required to be deployed and running for FSRest to communicate.
2. TIBCO® AuditSafe: Required to be deployed and running to post the audit logs from FSRest.


========================================================================================================




Deploying steps:
========================================================================================================
1. Configure and update all the property values in the deployment.properties and the values <xxxxx>
   MUST be replaced.
2. Use the script deploy-fsrest.sh to deploy the FSRest service onto the Kubernetes cluster.


========================================================================================================




Undeploying steps:
========================================================================================================
1. Run the script remove_fsrest_service.sh to remove the FSRest service/deployment.


========================================================================================================




List of files
========================================================================================================
scripts:
deploy-fsrest.sh


apply_secret_docker_login.sh
remove_fsrest_service.sh


config:
deployment.properties


========================================================================================================


Files
========================================================================================================
deploy_fsrest.sh:
    It deploys the FSRest service onto the Kubernetes cluster.


deployment.properties:
     It contains all the properties that the user must set before pulling the FSRest's Docker image and
deploying it to the Kubernetes cluster.


apply_secret_docker_login.sh:
     It creates the Kubernetes secret Docker-registry for Docker login.


remove_fsrest_service.sh:
     It deletes the FSRest service and deployment.


========================================================================================================