#!/bin/bash

####################################Pre-requists#############################################
#
# 1. In order to run ElasticSearch snapshot and restore, you need add below property
#    path.repo: ["<PATH_TO_WHERE_YOU_WANT_SAVE_BACKUP>"]
#    in your elasticsearch.yml(<ElasticSearch_HOME>/config) and restart elasticsearch
# 2. Please run ./elasticsearchtools -p to create repo first and then run snapshot/restore 
#    commands.
#
############################################################################################

BACKUP_LOCATION=/tmp/backup
ELASTICSEARCH_HOST=<elasticsearch_host_ip>
ELASTICSEARCH_PORT=9200 
BACKUP_REPO_NAME=backups 
INDEX_NAME=tcta_transaction_bcce


usage()
{
   echo "Usage:"
   echo "-p                   [create backup repository]"
   echo "-s <snapshot_name>            [create snapshot]"
   echo "-r <snapshot_name>           [restore snapshot]"
   echo "-d <index_name>                  [delete index]"
}


createRepo(){
    curl --header "Content-Type: application/json" -XPUT "http://$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT/_snapshot/$BACKUP_REPO_NAME" -d'{ 
    "type": "fs",
    "settings": {
     "location": "$BACKUP_LOCATION",
     "compress": true
     }
   }'
   echo ""
}

createSnapshot(){
  curl --header "Content-Type: application/json" -XPUT "http://$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT/_snapshot/$BACKUP_REPO_NAME/$1?wait_for_completion=true" -d'{
       "indices": "$INDEX_NAME",
       "ignore_unavailable": true,
       "include_global_state": false
   }'
}

restoreSnapshot(){
  while true; do
  read -p "Caution!! After you run restore, index data will be restored (y/n) " yn
            case $yn in
                [Yy]* ) echo "Restore process started";  break;;
                [Nn]* ) exit;;
                * ) echo "Please answer yes or no.";; 
            esac
 done
 curl -XPOST "http://$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT/$INDEX_NAME/_close"
 curl --header "Content-Type: application/json" -XPOST "http://$ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT/_snapshot/$BACKUP_REPO_NAME/$1/_restore?wait_for_completion=true" -d'{
       "indices": "$INDEX_NAME",
       "ignore_unavailable": true,
       "include_global_state": false
   }'

}

deleteIndex(){
  while true; do
  read -p "Caution!! After you run delete, index will be deleted (y/n) " yn
            case $yn in
                [Yy]* ) echo "deleting process started";  break;;
                [Nn]* ) exit;;
                * ) echo "Please answer yes or no.";;
            esac
 done
 curl -XDELETE $ELASTICSEARCH_HOST:$ELASTICSEARCH_PORT/$1
}

if [ $# -eq 1 ] && [ $1 == "-p" ]; then
	echo create backup repository 
	createRepo
	exit 0	
fi

if [ $# -ne 2 ]; then
        usage
        exit 1;
fi

if [ $1 == "-s" ]; then
	echo create snapshot $2
	createSnapshot $2
elif [ $1 == "-r" ]; then
	echo create restore $2
	restoreSnapshot $2
elif [ $1 == "-d" ]; then
	echo delete index $2
	deleteIndex $2
else
	echo unknown argument $1
	usage
	exit 1
fi



