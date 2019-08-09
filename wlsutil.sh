#!/bin/bash

WORKING_DIR=$0
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )

WLST=$SCRIPT_DIR/wlst/wlfullclient.jar

ARG_ENVIRONMENT=${1:-env}

if [ ! -z "$ARG_ENVIRONMENT" ]; then

    WLS_IP=
    WLS_PORT=
    WLS_USERNAME=
    WLS_PASSWORD=
    WLS_TARGETS=

    ENV_PATH=$(readlink -f $ARG_ENVIRONMENT)
    echo "Reading variables from file " $ENV_PATH
    . $ENV_PATH
fi

if [ -z "$WLS_IP" ]; then
    echo "Variable WLS_IP is missing,"
    WLS_IP="127.0.0.1"
fi

if [ -z "$WLS_PORT" ]; then
    echo "Variable WLS_PORT is missing, default port number 7001 will be used."
    WLS_PORT=7001
fi

if [ -z "$WLS_USERNAME" ]; then
    echo "Variable WLS_USERNAME is missing, default username \"weblogic\" will be used."
    WLS_USERNAME="127.0.0.1"
fi

if [ -z "$WLS_PASSWORD" ]; then
    echo "Variable WLS_PASSWORD is missing, default password \"welcome1\" will be used"
    WLS_PASSWORD="welcome1"
fi

if [ -z "$WLS_TARGETS" ]; then
    echo "Variable WLS_TARGETS is missing, dafault password \"AdminServer\""
    WLS_TARGETS="AdminServer"
fi

echo $WLST

function wlst.deploy-lib {
    printf "##################\nDEPLOYING LIB $1\n##################\n\n"
    ADMIN_URL=t3://$WLS_IP:$WLS_PORT
    java -cp "$WLST" weblogic.Deployer -adminurl "$ADMIN_URL" -username "$WLS_USERNAME" -password "$WLS_PASSWORD" -upload -library -targets "$WLS_TARGETS" -deploy -source "$1"
    sleep 1;
    echo
    
}

function wlst.deploy-app {
    printf "##################\nDEPLOYING APP $1\n##################\n\n"
    ADMIN_URL=t3://$WLS_IP:$WLS_PORT
    java -cp "$WLST" weblogic.Deployer -adminurl "$ADMIN_URL" -username "$WLS_USERNAME" -password "$WLS_PASSWORD" -upload -deploy -targets "$WLS_TARGETS" -deploy -source "$1"
    sleep 1;
    echo
}

function wlst.undeploy {
    printf "##################\nUNDEPLOYING $1\n##################\n\n"
    ADMIN_URL=t3://$WLS_IP:$WLS_PORT
    java -cp "$WLST" weblogic.Deployer -adminurl $ADMIN_URL -username $WLS_USERNAME -password $WLS_PASSWORD -undeploy -name $1 -targets "$WLS_TARGETS"
    sleep 1;
    echo
}

function wlst.stop {
    printf "##################\nSTOPPING $1\n##################\n\n"
    ADMIN_URL=t3://$WLS_IP:$WLS_PORT
    java -cp "$WLST" weblogic.Deployer -adminurl $ADMIN_URL -username $WLS_USERNAME -password $WLS_PASSWORD -stop -name $1 -targets "$WLS_TARGETS"
    sleep 1;
    echo
}

function wlst.start {
    printf "##################\nSTARTING $1\n##################\n\n"
    ADMIN_URL=t3://$WLS_IP:$WLS_PORT
    java -cp "$WLST" weblogic.Deployer -adminurl $ADMIN_URL -username $WLS_USERNAME -password $WLS_PASSWORD -start -name $1 -targets "$WLS_TARGETS"
    sleep 1;
    echo
}

function  wlst.deploy-libs {
    printf "##################\nDEPLOYING LIBS ON $1\n##################\n\n"
    ADMIN_URL=t3://$WLS_IP:$WLS_PORT

    for FILE in $1/*.war
    do
       wlst.deploy-lib $FILE
    done
    echo
}

function  wlst.deploy-apps {
    printf "##################\nDEPLOYING APPS ON $1\n##################\n\n"
    ADMIN_URL=t3://$WLS_IP:$WLS_PORT

    for FILE in $1/*.war
    do
       wlst.deploy-app $FILE
    done
    echo
}