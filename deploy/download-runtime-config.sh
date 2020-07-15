#!/bin/sh

set -eu

if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <CloudPakforData_URL> <username> <password> <runtime_config_json>" >&2
  exit 1
fi

CloudPakforData_URL="$1"
username="$2"
password="$3"
runtime_config_json="$4"

myToken=`curl -k ${CloudPakforData_URL}/v1/preauth/validateAuth \
              -u ${username}:${password} \
         | sed -n -e 's/^.*accessToken":"//p' | cut -d'"' -f1`

curl -k -X GET "${CloudPakforData_URL}/zen-data/v1/volumes/files/%2F_global_%2Fconfig%2F.runtime-definitions%2Fibm%2F${runtime_config_json}" --header "Authorization: Bearer ${myToken}" > ${runtime_config_json}

echo "File ${runtime_config_json} saved"
echo "Image name: $(grep \"image\" ${runtime_config_json} | awk -F\" '{print $4}')"

