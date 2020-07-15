#!/bin/sh

set -eu

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <CloudPakforData_URL> <username> <password>" >&2
  exit 1
fi

CloudPakforData_URL="$1"
username="$2"
password="$3"

myToken=`curl -k ${CloudPakforData_URL}/v1/preauth/validateAuth \
              -u ${username}:${password} \
         | sed -n -e 's/^.*accessToken":"//p' | cut -d'"' -f1`  


curl -k -X PUT \
   "${CloudPakforData_URL}/zen-data/v1/volumes/files/%2F_global_%2Fconfig%2F.runtime-definitions%2Fibm" \
   -H "Authorization: Bearer ${myToken}" \
   -H "content-type: multipart/form-data" \
   -F upFile=@jupyter-lab-carolina-server.json

