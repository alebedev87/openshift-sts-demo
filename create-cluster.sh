#! /bin/bash

# Source: https://docs.openshift.com/container-platform/4.12/authentication/managing_cloud_provider_credentials/cco-mode-sts.html#sts-mode-installing-manual-run-installer_cco-mode-sts

set -e

# 1. Generate install config.

INSTALL_DIR="aleb-sts-a"
openshift-install create install-config --dir "${INSTALL_DIR}"

# 2. Set CCO to manual mode.

sed -i '4i credentialsMode: Manual' "${INSTALL_DIR}/install-config.yaml"

# 3. Generate cluster manifests and cluster operator STS secret to them.

cd "${INSTALL_DIR}"
openshift-install create manifests
cp ../manifests/* ./manifests/
cp -a ../tls .

# 4. Create the cluster.

exec openshift-install create cluster
