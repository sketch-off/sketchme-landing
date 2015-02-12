#!/bin/sh
echo "$(tput setaf 2)Building Jekyll... $(tput sgr0)"
jekyll build
echo "$(tput setaf 2)Syncing with AWS S3... $(tput sgr0)"
BUCKET=sketchme.co
aws s3 rm s3://$BUCKET/assets --recursive
aws s3 sync _site s3://$BUCKET/ --region us-west-2 --exclude .DS_Store
