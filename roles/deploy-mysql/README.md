# MySQL Role

## Input variables

### Mandatory

* application_name: Name of the application this deployment belongs to
* service_name: Name of the deployment to use. e.g. rhpam-authoring-kieserver-mysql
* namespace: Namespace where to create the objects into
* state: Whether to create or remove the objects
* mysql_database: Name of the database to create
* mysql_user: Username to create
* mysql_pwd: Password for the provided username

### Optional

* mysql_volume_size (optional): If provided a PersistentVolumeClaim will be created and used in the DeploymentConfig

### Default

* mysql_image_name: Defaults to `mysql`
* mysql_image_tag: Defaults to `5.7`
* mysql_image_namespace: Defaults to `openshift`

## Objects created

* Service
* Persistent Volume Claim (if mysql_volume_size is provided)
* Deployment Configuration
