#!/bin/sh

usage() {
    echo "Need to set SERVER_NAME and ADMIN_URL environment variables or specify"
    echo "them in command line:"
    echo "Usage: $1 SERVER_NAME {ADMIN_URL}"
    echo "for example:"
    echo "$1 managedserver1 url for weblogic"
}

DOMAIN_NAME="NameDomain" # domain Name
ADMIN_URL="url for weblogic"
export WLS_USER

WLS_PW=""
export WLS_PW

JAVA_VM=""

if [ "$1" = "" ] ; then
    if [ "${SERVER_NAME}" = "" ] ; then
        usage $0
        exit
    fi
else
    SERVER_NAME="$1"
    shift
fi

if [ "$1" = "" ] ; then
    if [ "${ADMIN_URL}" = "" ] ; then
        usage $0
        exit
    fi
else
    ADMIN_URL="$1"
    shift
fi

ADMIN_URL="${ADMIN_URL}"
export ADMIN_URL

SERVER_NAME="${SERVER_NAME}"
export SERVER_NAME

DOMAIN_HOME="/path" # path for domain home

if [ "$1" = "" ] ; then
    
    ${DOMAIN_HOME}/bin/startWebLogic.sh nodebug noderby
else
    ${DOMAIN_HOME}/bin/startWebLogic.sh $*
fi

