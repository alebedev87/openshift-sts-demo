#! /bin/bash

# Source: https://docs.openshift.com/container-platform/4.12/authentication/managing_cloud_provider_credentials/cco-mode-sts.html#sts-mode-installing-manual-run-installer_cco-mode-sts

set -e

INSTALL_DIR="aleb-sts-a"
openshift-install create install-config --dir "${INSTALL_DIR}"

sed -i '4i credentialsMode: Manual' "${INSTALL_DIR}/install-config.yaml"

cd "${INSTALL_DIR}"
openshift-install create manifests

cp ../manifests/* ./manifests/
cp -a ../tls .

exec openshift-install create cluster
