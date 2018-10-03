# ROLE Deploy Smart Router

Deploys Red Hat Process Automation Manager - Smart Router

## Requirements

* Image Requirements
  * `{{smartrouter_image_namespace}}/{{smartrouter_image_name}}:{{smartrouter_image_tag}}` e.g. openshift/rhpam70-smartrouter-openshift:1.1

## Objects created

* Route
* Service
* Secret containing keystore (if it didn't exist)
* PersistentVolumeClaim (if smartrouter_volume_size is provided)
* DeploymentConfig
