#!/bin/bash

# Encode the apb.yml file and break lines maxing out 512 characters per line.
# Additionally append slashes at the end, and remove last slashes
encoded_apb=$(base64 -w 512 apb.yml | sed 's/$/\\\\\\/g' | sed '$ s/...$//')

echo "Update image.yaml file with b64 encoded spec"
perl -i -0pe "s/name: \"com.redhat.apb.spec\"\n    value: \".*\"/name: \"com.redhat.apb.spec\"\n    value: \"${encoded_apb}\"/gms" image.yaml
echo "Finished prepare"
