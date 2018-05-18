# PostgreSQL Role

## Input variables

* mysql_database (mandatory): Name of the database to create
* mysql_user (mandatory): Username to create
* mysql_pwd (mandatory): Password for the provided username

* mysql_volume_size (optional): If provided a PersistentVolumeClaim will be created and used in the DeploymentConfig

* mysql_image_name: Defaults to `mysql`
* mysql_image_tag: Defaults to `5.7`
* mysql_image_namespace: Defaults to `openshift`

## Objects created

* Service
* Persistent Volume Claim (if mysql_volume_size is provided)
* Deployment Configuration
