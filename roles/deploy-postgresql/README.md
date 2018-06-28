# PostgreSQL Role

## Objects created

* Service
* Persistent Volume Claim (if postgresql_volume_size is provided)
* Deployment Configuration

## Input variables

### Mandatory

* application_name: Name of the application this deployment belongs to
* service_name: Name of the deployment to use. e.g. rhpam-authoring-kieserver-mysql
* namespace: Namespace where to create the objects into
* state: Whether to create or remove the objects
* postgresql_database: Name of the database to create
* postgresql_user: Username to create
* postgresql_pwd: Password for the provided username

### Optional

* postgresql_volume_size: If provided a PersistentVolumeClaim will be created and used in the DeploymentConfig

### Default

* postgresql_image_name: Defaults to `postgresql`
* postgresql_image_tag: Defaults to `9.6`
* postgresql_image_namespace: Defaults to `openshift`