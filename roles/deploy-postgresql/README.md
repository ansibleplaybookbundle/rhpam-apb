# PostgreSQL Role

## Input variables

* postgresql_database (mandatory): Name of the database to create
* postgresql_user (mandatory): Username to create
* postgresql_pwd (mandatory): Password for the provided username

* postgresql_volume_size (optional): If provided a PersistentVolumeClaim will be created and used in the DeploymentConfig

* postgresql_image_name: Defaults to `postgresql`
* postgresql_image_tag: Defaults to `9.6`
* postgresql_image_namespace: Defaults to `openshift`

## Objects created

* Service
* Persistent Volume Claim (if postgresql_volume_size is provided)
* Deployment Configuration
