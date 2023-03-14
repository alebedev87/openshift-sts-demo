#! /bin/bash

# Source 1: https://docs.openshift.com/container-platform/4.12/authentication/managing_cloud_provider_credentials/cco-mode-sts.html#cco-ccoctl-configuring_cco-mode-sts
# Source 2: https://docs.openshift.com/container-platform/4.12/authentication/managing_cloud_provider_credentials/cco-mode-sts.html#cco-ccoctl-creating-at-once_cco-mode-sts

set -e

RELEASE_IMAGE=$(openshift-install version | awk '/release image/ {print $3}')

CCO_IMAGE=$(oc adm release info --image-for='cloud-credential-operator' "${RELEASE_IMAGE}" -a .pull-secret)

oc image extract "${CCO_IMAGE}" --file="/usr/bin/ccoctl" -a .pull-secret; chmod 775 ccoctl

CRED_REQ_DIR="credrequests"; mkdir "${CRED_REQ_DIR}"

oc adm release extract --credentials-requests --cloud=aws --to="${CRED_REQ_DIR}" --from="${RELEASE_IMAGE}"

cat "${CRED_REQ_DIR}/0000_50_cluster-ingress-operator_00-ingress-credentials-request.yaml"

./ccoctl aws create-all --name=albo-sts --region=us-east-2 --credentials-requests-dir="${CRED_REQ_DIR}"

cat manifests/openshift-ingress-operator-cloud-credentials-credentials.yaml

cat manifests/cluster-authentication-02-config.yaml && echo
