#!/bin/bash

encoded_apb=$(base64 -w 0 apb.yml)

echo "Update image.yaml file with b64 encoded spec"
sed -i "/com.redhat.apb.spec/!b;n;c\ \ \ \ value: \"${encoded_apb}\"" image.yaml
echo "Finished prepare"