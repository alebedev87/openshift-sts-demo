#! /bin/sh

set -e

oc create ns echoserver

oc apply -f echosrv/

curl -v $(oc -n echoserver get ingress echoserver -o json | jq -r '.status.loadBalancer.ingress[0].hostname')
