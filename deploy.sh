#!/bin/sh
echo "$(tput setaf 2)Building Jekyll... $(tput sgr0)"
jekyll build
echo "$(tput setaf 2)Syncing with AWS S3... $(tput sgr0)"
aws s3 sync _site s3://sketchme.co/ --region us-west-2
