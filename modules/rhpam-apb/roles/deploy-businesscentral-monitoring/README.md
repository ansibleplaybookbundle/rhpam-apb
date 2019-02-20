# ROLE Deploy Business Central Monitoring

Deploys Red Hat Process Automation Manager - Business Central Monitoring

## Requirements

* Image Requirements
  * `{{businesscentral_image_namespace}}/{{businesscentral_image_name}}:{{businesscentral_image_tag}}` e.g. openshift/rhpam72-businesscentral-monitoring-openshift:1.1

## Objects created

* Route
* Service
* Ping Service
* Secret containing keystore (if it didn't exist)
* PersistentVolumeClaim (if businesscentral_volume_size is provided)
* DeploymentConfig