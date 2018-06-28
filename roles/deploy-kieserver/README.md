# ROLE Deploy KIE Server

Deploys Red Hat Process Automation Manager - KIE Process Server

## Requirements

* Image Requirements
  * `{{kieserver_image_namespace}}/{{kieserver_image_name}}:{{kieserver_image_tag}}` e.g. openshift/rhpam70-kieserver-openshift:1.1
* External Database. If selected all the external DB values are mandatory
* If H2 Database is selected, replicas must not be > 1

## Objects created

* Route
* Service
* Ping Service
* Secret containing keystore (if it didn't exist)
* PersistentVolumeClaim (if kieserver_db_size is provided and kieserver_db_type == "H2")
* DeploymentConfig
* [PostgreSQL](../deploy-postgresql/README.md) / [MySQL](../deploy-mysql/README.md) database depending on kieserver_db_type
