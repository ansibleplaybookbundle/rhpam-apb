#!/bin/bash

apb bundle prepare -nc Dockerfile-latest > /dev/null 1>&1
encoded_apb=$(sed -n '/com.redhat.apb.spec/{n;p;}' Dockerfile-latest)

for dockerfile in canary latest nightly
do
    echo "Prepare Dockerfile-$dockerfile"
    apb bundle prepare -c Dockerfile-$dockerfile > /dev/null 1>&1
    echo "Done"
done

echo "Update image.yaml file with b64 encoded spec"
sed -i "/com.redhat.apb.spec/!b;n;c\ \ \ \ value: ${encoded_apb}" image.yaml
echo "Finished prepare"