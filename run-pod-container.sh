#!/bin/bash

POD_ID=$(crictl runp pod-config.json)
echo $POD_ID

crictl pull nginx

CONTAINER_ID=$(crictl create $POD_ID container-config-1.json pod-config.json)

crictl start $CONTAINER_ID
crictl ps

echo $POD_ID
POD_IP=$(crictl inspectp --output go-template --template '{{.status.network.ip}}' $POD_ID)
echo $POD_IP

curl $POD_IP
