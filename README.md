# PyPI server S3 mirror

This runs [pypiserver](https://github.com/schmir/pypiserver) and mirrors it to
S3 for an easy static PyPI server.

## Usage

You need to set some environment variables to make this work:

  * `AWS_ACCESS_KEY_ID`: an AWS access key with permission to upload to the
bucket;
  * `AWS_SECRET_ACCESS_KEY`: the secret key for the above account;
  * `DEPLOY_BUCKET`: the name of the S3 bucket to host the repository;
  * `DEPLOY_DIRECTORY`: an optional directory under which to synchronise. Can
be a long random string as a form of token based security.

Then you need to install dependencies (it's best if you create virtualenv for
this purpose):

    pip install -r requirements.txt

Place a bunch of packages in a directory and run

    bash update-mirror.sh <package_dir>

If you need to synchronise down packages, run

    bash download-mirror-packages.sh <package_dir>
