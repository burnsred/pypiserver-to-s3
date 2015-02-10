# #!/bin/bash

# Take a mirror
pypi-server $1 &
sleep 1
wget -mk localhost:8080
kill %1

# Make lowercase copies of everything
for PACKAGE in `find localhost:8080/simple -type d`; do
    PACKAGE_LOWER=`echo "$PACKAGE" | tr '[:upper:]' '[:lower:]'`

    if [ ! -d "$PACKAGE_LOWER" ]; then
        cp -r "$PACKAGE" "$PACKAGE_LOWER"
    fi
done

if [ -z "$DEPLOY_DIRECTORY" ]; then
    S3_UPLOAD_URI=s3://$DEPLOY_BUCKET/
else
    S3_UPLOAD_URI=s3://$DEPLOY_BUCKET/$DEPLOY_DIRECTORY/
fi

cp s3cfg_template s3cfg
echo "access_key =" $AWS_ACCESS_KEY_ID >> s3cfg
echo "secret_key =" $AWS_SECRET_ACCESS_KEY >> s3cfg

# Upload
s3cmd -c s3cfg sync \
    --acl-public \
    --add-header='Cache-Control: private, max-age=0, no-cache' \
    localhost:8080/ \
    $S3_UPLOAD_URI

rm s3cfg
rm -r localhost:8080
