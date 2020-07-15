#!/bin/sh

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <your_registry_location> <base_name> <base_tag>" >&2
  exit 1
fi

set -eux

registry_location=$1
base_image=$2
base_tag=$3

CAROLINA_VER=3.8.20
CAROLINA_KERNEL_VER=1.0.7

# check carolina packages exits
ls -l carolina_files/carolina.lic \
      carolina_files/carolina-$CAROLINA_VER.tar.gz \
      carolina_files/carolina-ibmcloud-plugin-$CAROLINA_VER.tar.gz \
      carolina_files/carolina_kernel-$CAROLINA_KERNEL_VER.tar.gz



podman build -t ${base_image}-carolina:${base_tag}-${CAROLINA_VER} \
    --build-arg base_image_tag=${registry_location}/${base_image}:${base_tag} \
    --build-arg carolina_ver=${CAROLINA_VER} \
    --build-arg carolina_kernel_ver=${CAROLINA_KERNEL_VER} \
    -f Dockerfile .


podman tag ${base_image}-carolina:${base_tag}-${CAROLINA_VER} \
	    ${registry_location}/${base_image}-carolina:${base_tag}-${CAROLINA_VER}

podman push ${registry_location}/${base_image}-carolina:${base_tag}-${CAROLINA_VER} \
            --tls-verify=false


