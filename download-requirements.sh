#!/bin/bash

# set -x

REQUIREMENTS_FILE=$1
PACKAGE_PATH=$2
PACKAGES_TO_DOWNLOAD=`grep == $REQUIREMENTS_FILE`
PACKAGES_TO_NOT_DOWNLOAD=`grep -v == $REQUIREMENTS_FILE`

cd $PACKAGE_PATH
for PACKAGE in $PACKAGES_TO_DOWNLOAD; do
    PACKAGE_NAME=${PACKAGE%%==*}
    VERSION_WITH_EQUALS=${PACKAGE:${#PACKAGE_NAME}}
    PACKAGE_VERSION=${VERSION_WITH_EQUALS:2}

    FIRST_CHARACTER=${PACKAGE_NAME:0:1}

    # Sometimes the name in the requirements file is redirected to another name
    PACKAGE_CANONICAL_NAME=`wget -q -O - https://pypi.python.org/simple/$PACKAGE_NAME/ | perl -wlne 'print $1 if /\/packages\/source\/\w\/(\w+)\//' | head -1`
    if [ -n "$PACKAGE_CANONICAL_NAME" ]; then
        PACKAGE_URL_BASE=https://pypi.python.org/packages/source/$FIRST_CHARACTER/$PACKAGE_CANONICAL_NAME/$PACKAGE_CANONICAL_NAME-$PACKAGE_VERSION
        rm -f $PACKAGE_CANONICAL_NAME-$PACKAGE_VERSION.tar.gz $PACKAGE_CANONICAL_NAME-$PACKAGE_VERSION.zip
        if  ! wget -nv $PACKAGE_URL_BASE.tar.gz; then
            if  ! wget -nv $PACKAGE_URL_BASE.zip; then
                echo "Error downloading $PACKAGE"
                exit 1
            fi
        fi
    fi
done

echo
echo "Did not download:"
echo $PACKAGES_TO_NOT_DOWNLOAD