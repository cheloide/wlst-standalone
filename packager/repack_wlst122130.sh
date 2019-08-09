#!/bin/bash

WORKING_DIR=$PWD
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )

PROVIDED_JDK_PATH=$1
WLS_INSTALLER_ZIP_PATH=$2
DESTINATION_FOLDER=$3

if [ -z "$DESTINATION_FOLDER" ]; then
    DESTINATION_FOLDER=$WORKING_DIR
fi



echo "Creating temporary folders"
TEMP_FOLDER=$(mktemp -d)
ORACLE_HOME=$TEMP_FOLDER/ORACLE_HOME
TEMP_ORAINV=$TEMP_FOLDER/orainv.loc
TEMP_RESPONSEFILE=$TEMP_FOLDER/responseFile

echo "Created temporary directory $TEMP_FOLDER"

mkdir $ORACLE_HOME
touch $TEMP_ORAINV
touch $TEMP_RESPONSEFILE

echo "Created folder $ORACLE_HOME"
echo "Created file $TEMP_ORAINV"
echo "Created file $TEMP_RESPONSEFILE"
echo
echo "Unpacking provided jdk..."
tar -C $TEMP_FOLDER -zxf $PROVIDED_JDK_PATH 
JAVA_EXEC=$(find $TEMP_FOLDER -maxdepth 3 -name java -type f)
JAVA_HOME=${JAVA_EXEC%/bin/java}
echo "JDK unpacked to "$JAVA_HOME
echo

echo "inventory_loc=$ORACLE_HOME/.inventory"        >   $TEMP_ORAINV
echo "inst_group=nobody"                            >>  $TEMP_ORAINV

echo "[ENGINE]"                                     >   $TEMP_RESPONSEFILE
echo "Response File Version=1.0.0.0.0"              >>  $TEMP_RESPONSEFILE
echo "[GENERIC]"                                    >>  $TEMP_RESPONSEFILE
echo "INSTALL_TYPE=WebLogic Server"                 >>  $TEMP_RESPONSEFILE
echo "SOFTWARE ONLY TYPE=true"                      >>  $TEMP_RESPONSEFILE
echo "DECLINE_SECURITY_UPDATES=true"                >>  $TEMP_RESPONSEFILE
echo "SECURITY_UPDATES_VIA_MYORACLESUPPORT=false"   >>  $TEMP_RESPONSEFILE

echo
echo "Unzipping Weblogic Server 12.2.1.3.0 installer"
unzip "$WLS_INSTALLER_ZIP_PATH" -d $TEMP_FOLDER

echo
echo "Installing Weblogic Server 12.2.1.3.0"
$JAVA_HOME/bin/java -jar $TEMP_FOLDER/fmw_12.2.1.3.0_wls.jar \
-silent \
-responseFile $TEMP_RESPONSEFILE \
-invPtrLoc $TEMP_ORAINV \
-jreLoc $JAVA_HOME \
-ignoreSysPrereqs -force -novalidation \
ORACLE_HOME=$ORACLE_HOME \
INSTALL_TYPE="WebLogic Server"

echo
cd "$ORACLE_HOME/wlserver/server/lib/"
java -jar wljarbuilder.jar
echo

mkdir -p "$DESTINATION_FOLDER/wlst-122130"
WLST_FOLDER="$DESTINATION_FOLDER/wlst-122130/"

cp \
$ORACLE_HOME/wlserver/server/lib/wlfullclient.jar                               \
$ORACLE_HOME/wlserver/modules/com.oracle.core.weblogic.msgcat.jar               \
$ORACLE_HOME/wlserver/modules/com.bea.core.xml.xmlbeans.jar                     \
$ORACLE_HOME/oracle_common/modules/com.oracle.cie.comdev_7.8.2.0.jar            \
$ORACLE_HOME/oracle_common/modules/com.oracle.cie.dependency_1.8.2.0.jar        \
$ORACLE_HOME/oracle_common/modules/com.oracle.cie.wizard_7.8.2.0.jar            \
$ORACLE_HOME/oracle_common/modules/com.oracle.cie.encryption_2.6.0.0.jar        \
$ORACLE_HOME/oracle_common/modules/com.oracle.cie.service-table_1.6.0.0.jar     \
$ORACLE_HOME/oracle_common/modules/com.oracle.cie.config-owsm_8.6.0.0.jar       \
$ORACLE_HOME/oracle_common/modules/com.oracle.cie.config-security_8.6.0.0.jar   \
$ORACLE_HOME/oracle_common/modules/com.oracle.cie.config_8.6.0.0.jar            \
$ORACLE_HOME/oracle_common/modules/com.oracle.cie.config-wls-schema_8.6.0.0.jar \
$ORACLE_HOME/oracle_common/modules/com.oracle.cie.config-wls_8.6.0.0.jar        \
$ORACLE_HOME/wlserver/common/wlst/modules/jython-modules.jar                    \
"$WLST_FOLDER"

echo "Copied files":
echo "  $ORACLE_HOME/wlserver/server/lib/wlfullclient.jar"
echo "  $ORACLE_HOME/wlserver/modules/com.oracle.core.weblogic.msgcat.jar"
echo "  $ORACLE_HOME/wlserver/modules/com.bea.core.xml.xmlbeans.jar"
echo "  $ORACLE_HOME/oracle_common/modules/com.oracle.cie.comdev_7.8.2.0.jar"
echo "  $ORACLE_HOME/oracle_common/modules/com.oracle.cie.dependency_1.8.2.0.jar"
echo "  $ORACLE_HOME/oracle_common/modules/com.oracle.cie.wizard_7.8.2.0.jar"
echo "  $ORACLE_HOME/oracle_common/modules/com.oracle.cie.encryption_2.6.0.0.jar"
echo "  $ORACLE_HOME/oracle_common/modules/com.oracle.cie.service-table_1.6.0.0.jar"
echo "  $ORACLE_HOME/oracle_common/modules/com.oracle.cie.config-owsm_8.6.0.0.jar"
echo "  $ORACLE_HOME/oracle_common/modules/com.oracle.cie.config-security_8.6.0.0.jar"
echo "  $ORACLE_HOME/oracle_common/modules/com.oracle.cie.config_8.6.0.0.jar"
echo "  $ORACLE_HOME/oracle_common/modules/com.oracle.cie.config-wls-schema_8.6.0.0.jar"
echo "  $ORACLE_HOME/oracle_common/modules/com.oracle.cie.config-wls_8.6.0.0.jar"
echo "  $ORACLE_HOME/wlserver/common/wlst/modules/jython-modules.jar"
echo "to folder $WLST_FOLDER"
echo

echo "Deleting $TEMP_FOLDER and all it's contents!"
rm -rf "$TEMP_FOLDER"