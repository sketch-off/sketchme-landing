#!/bin/sh
echo "$(tput setaf 2)Building Jekyll... $(tput sgr0)"
jekyll build
echo "$(tput setaf 2)Syncing with AWS S3... $(tput sgr0)"
BUCKET=sketchme.co
REGION=us-west-2
aws s3 rm s3://$BUCKET/assets --region $REGION --recursive
aws s3 sync _site s3://$BUCKET/ --region $REGION --exclude .DS_Store
echo "$(tput setaf 2)Configuring redirections... $(tput sgr0)"
APPSTORE_URL="https://itunes.apple.com/us/app/sketchme-know-thy-friends/id806820979?mt=8"
aws s3api put-object --bucket $BUCKET --key appstore/index.html --region $REGION --content-type "text/html" --website-redirect-location $APPSTORE_URL
aws s3api put-object --bucket $BUCKET --key AppStore/index.html --region $REGION --content-type "text/html" --website-redirect-location $APPSTORE_URL
