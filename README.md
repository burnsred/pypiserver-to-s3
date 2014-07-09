# PyPI server S3 mirror

This runs [pypiserver](https://github.com/schmir/pypiserver) and mirrors it to
S3 for an easy static PyPI server.

## Usage

First, create an S3 bucket. You'll need to enable S3 website and use the website
endpoint for the S3 bucket to serve index.html files for URLs ending in /

Note that S3 website does not yet support SSL, so if you need this (it's
probably a good idea), you should enable a Cloudfront distribution in front of
the bucket's website endpoint.

Now to run the scripts, you need to set some environment variables to make this
work:

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

To add a bunch of packages from a requirements.txt file:

    bash download-requirements <path/requirements.txt> <package_dir>


