#!/bin/bash
source 
# $DEPLOYMENT_NAME $QMGR $EXECGRP $ENV
DEPLOYMENT_NAME=$1
BROKER=$2
EXECGRP=$3
ENV=$4

#get the collector properties from the properties file
databaseName=`fgrep ${CFG_SVC_NAME}.databaseName ${DEPLOYMENT_NAME}.${ENV}.properties | cut -d= -f2 | tr -d '[:cntrl:]'`
jarsURL=/MQHA/${BROKER}/data/IIB/mqsi/config/${BROKER}/shared-classes
port=`fgrep ${CFG_SVC_NAME}.port ${DEPLOYMENT_NAME}.${ENV}.properties | cut -d= -f2 | tr -d '[:cntrl:]'`
server=`fgrep ${CFG_SVC_NAME}.server ${DEPLOYMENT_NAME}.${ENV}.properties | cut -d= -f2 | tr -d '[:cntrl:]'`

#See if the service already exists
CFG_SVC_NAME=nz_doanalytics
mqsireportproperties $BROKER -c JDBCProviders -o $CFG_SVC_NAME -r 1>/dev/null 2>1
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
  echo " "
  echo "Attempting to create configurable services on $BROKER"
  echo " "
  mqsicreateconfigurableservice $BROKER -c JDBCProviders -o $CFG_SVC_NAME -n connectionUrlFormat,connectionUrlFormatAttr1,connectionUrlFormatAttr2,connectionUrlFormatAttr3,connectionUrlFormatAttr4,connectionUrlFormatAttr5,databaseName,databaseType,databaseVersion,description,environmentParms,jarsURL,jdbcProviderXASupport,maxConnectionPoolSize,portNumber,securityIdentity,serverName,type4DatasourceClassName,type4DriverClassName -v jdbc:netezza://[serverName]:[portNumber]/[databaseName],,,,,,$databaseName,Netezza,default_Database_Version,Netezza_DOAnalytics_DB,default_none,$jarsURL,false,0,$port,nz_doanalytics_id,$server,org.netezza.datasource.NzDatasource,org.netezza.Driver
else
  echo " "
  echo "Attempting to update configurable services on $BROKER"
  echo " "
  mqsichangeproperties $BROKER -c JDBCProviders -o $CFG_SVC_NAME -n connectionUrlFormat,connectionUrlFormatAttr1,connectionUrlFormatAttr2,connectionUrlFormatAttr3,connectionUrlFormatAttr4,connectionUrlFormatAttr5,databaseName,databaseType,databaseVersion,description,environmentParms,jarsURL,jdbcProviderXASupport,maxConnectionPoolSize,portNumber,securityIdentity,serverName,type4DatasourceClassName,type4DriverClassName -v jdbc:netezza://[serverName]:[portNumber]/[databaseName],,,,,,$databaseName,Netezza,default_Database_Version,Netezza_DOAnalytics_DB,default_none,$jarsURL,false,0,$port,nz_doanalytics_id,$server,org.netezza.datasource.NzDatasource,org.netezza.Driver
fi

#See if the service already exists
CFG_SVC_NAME=MASALRM
mqsireportproperties $BROKER -c Collector -o $CFG_SVC_NAME -r 1>/dev/null 2>1
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
  echo " "
  echo "Attempting to create configurable services on $BROKER"
  echo " "
  mqsicreateconfigurableservice $BROKER -c Collector -o $CFG_SVC_NAME -n collectionExpirySeconds,queuePrefix -v 60,MASALRM  
else
  echo " "
  echo "Attempting to update configurable services on $BROKER"
  echo " "
  mqsichangeproperties $BROKER -c Collector -o $CFG_SVC_NAME -n collectionExpirySeconds,queuePrefix -v 60,MASALRM  
fi

#See if the service already exists
CFG_SVC_NAME=MASTP
mqsireportproperties $BROKER -c Collector -o $CFG_SVC_NAME -r 1>/dev/null 2>1
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
  echo " "
  echo "Attempting to create configurable services on $BROKER"
  echo " "
  mqsicreateconfigurableservice $BROKER -c Collector -o $CFG_SVC_NAME -n collectionExpirySeconds,queuePrefix -v 60,MASTP  
else
  echo " "
  echo "Attempting to update configurable services on $BROKER"
  echo " "
  mqsichangeproperties $BROKER -c Collector -o $CFG_SVC_NAME -n collectionExpirySeconds,queuePrefix -v 60,MASTP  
fi
