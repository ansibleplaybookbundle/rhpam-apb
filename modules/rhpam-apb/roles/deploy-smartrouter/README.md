# ROLE Deploy Smart Router

Deploys Red Hat Process Automation Manager - Smart Router

## Requirements

* Image Requirements
  * `{{smartrouter_image_namespace}}/{{smartrouter_image_name}}:{{smartrouter_image_tag}}` e.g. openshift/rhpam76-smartrouter-openshift:1.0

## Objects created

* Route
* Service
* Secret containing keystore (if it didn't exist)
* PersistentVolumeClaim (if smartrouter_volume_size is provided)
* DeploymentConfig
