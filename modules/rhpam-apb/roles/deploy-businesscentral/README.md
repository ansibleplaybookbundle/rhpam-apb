# ROLE Deploy Business Central

Deploys Red Hat Process Automation Manager - Business Central

## Requirements

* Image Requirements
  * `{{businesscentral_image_namespace}}/{{businesscentral_image_name}}:{{businesscentral_image_tag}}` e.g. openshift/rhpam-businesscentral-rhel8:7.5.0

## Objects created

* Route
* Service
* Secret containing keystore (if it didn't exist)
* PersistentVolumeClaim (if businesscentral_volume_size is provided)
* DeploymentConfig
