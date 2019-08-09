#!/bin/bash

WORKING_DIR=$PWD
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )

WLS_INSTALLER_PATH=$1


echo "Creating temporary folders"
TEMP_FOLDER=$(mktemp -d)
TEMP_FOLDER_INSTALL=$(mktemp -d)
echo "Folders $TEMP_FOLDER and $TEMP_FOLDER_INSTALL created"

unzip "$WLS_INSTALLER_PATH" -d $TEMP_FOLDER
mkdir -p $TEMP_FOLDER/fmw_12.2.1.3.0_wls
unzip $TEMP_FOLDER/fmw_12.2.1.3.0_wls.jar -d $TEMP_FOLDER/fmw_12.2.1.3.0_wls

mkdir $TEMP_FOLDER_INSTALL/{oracle_common,wlserver}
ORACLE_COMMONS_FOLDER=$TEMP_FOLDER_INSTALL/oracle_common
WLSERVER_FOLDER=$TEMP_FOLDER_INSTALL/wlserver

cd "$ORACLE_COMMONS_FOLDER"
BASEPATH=$TEMP_FOLDER/fmw_12.2.1.3.0_wls/Disk1/stage/Components

unzip $BASEPATH/oracle.apache.commons.collections.mod/3.2.0.0.2/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.apache.commons.lang.mod/2.6.0.0.2/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.java.servlet/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.javavm.jrf/12.2.0.1.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.jrf.thirdparty.toplink/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.jrf.toplink/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.org.apache.ant.ant.bundle/1.9.8.0.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.webservices.base/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.webservices.wls/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.core.app.server/12.2.1.3.0/DataFiles/filegroup6.jar
unzip $BASEPATH/oracle.wls.jrf.tenancy.common.sharedlib/12.2.1.3.0/DataFiles/filegroup2.jar
unzip $BASEPATH/oracle.wls.shared.with.coh.standalone/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.shared.with.inst.sharedlib/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.shared.with.inst/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.thirdparty.javax.json/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.wlsportable.mod/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/org.codehaus.woodstox/4.2.0.0.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.libraries/12.2.1.3.0/DataFiles/filegroup2.jar
unzip $BASEPATH/oracle.joda.time.joda.time/2.9.4.0.0/DataFiles/filegroup1.jar


cd "$WLSERVER_FOLDER"
BASEPATH=$TEMP_FOLDER/fmw_12.2.1.3.0_wls/Disk1/stage/Components

cp $TEMP_FOLDER/fmw_12.2.1.3.0_wls/Disk1/install/modules/com.oracle.cie.comdev_7.8.2.0.jar ./modules/

unzip $BASEPATH/com.bea.core.xml.xmlbeans/2.6.2.0.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.fmwconfig.common.config.shared/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.fmwconfig.common.shared/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.fmwconfig.common.wls.shared.internal/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.glcm.dependency/1.8.2.0.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.glcm.wizard/7.8.2.0.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.common.cam.wlst/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.common.nodemanager/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.core.app.server/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.jrf.tenancy.common.sharedlib/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.jrf.tenancy.common/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.jrf.tenancy.ee.only.sharedlib/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.libraries/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.security.core.sharedlib/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.security.core/12.2.1.3.0/DataFiles/filegroup1.jar
unzip $BASEPATH/oracle.wls.shared.with.cam/12.2.1.3.0/DataFiles/filegroup1.jar

cd "$WORKING_DIR"
cd "$WLSERVER_FOLDER/server/lib/"
java -jar wljarbuilder.jar -verbose

cp $TEMP_FOLDER_INSTALL/wlserver/server/lib/wlfullclient.jar "$WORKING_DIR/wls122130_wlfullclient.jar"


echo "Deleting $TEMP_FOLDER and $TEMP_FOLDER_INSTALL"
# rm -rf "$TEMP_FOLDER" "$TEMP_FOLDER_INSTALL"