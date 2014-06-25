#!/bin/bash

if [ -z "$DEPLOY_DIRECTORY" ]; then
    S3_UPLOAD_URI=s3://$DEPLOY_BUCKET/packages/
else
    S3_UPLOAD_URI=s3://$DEPLOY_BUCKET/$DEPLOY_DIRECTORY/packages/
fi

cp s3cfg_template s3cfg
echo "access_key =" $AWS_ACCESS_KEY_ID >> s3cfg
echo "secret_key =" $AWS_SECRET_ACCESS_KEY >> s3cfg

mkdir -p $1

# Upload
s3cmd -c s3cfg sync \
    --acl-public \
    --add-header='Cache-Control: private, max-age=0, no-cache' \
    $S3_UPLOAD_URI \
    $1/

rm $1/index.html

rm s3cfg