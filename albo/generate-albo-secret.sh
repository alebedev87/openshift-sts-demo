#! /bin/bash

set -e

[ -z "${IDP_ARN}" ] && { echo "no identity provider arn given"; exit 1 }

oc create namespace aws-load-balancer-operator

curl --create-dirs -o cr/cr.yaml https://raw.githubusercontent.com/openshift/aws-load-balancer-operator/main/hack/operator-credentials-request.yaml

../ccoctl aws create-iam-roles --name albo-optr --region=us-east-2 --credentials-requests-dir=cr --identity-provider-arn ${IDP_ARN}

ls manifests/*-credentials.yaml | xargs -I{} oc apply -f {}

oc -n aws-load-balancer-operator get secret aws-load-balancer-operator -o json | jq -r '.data.credentials' | base64 -d
