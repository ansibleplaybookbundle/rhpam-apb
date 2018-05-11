# ROLE Deploy KIE Server
Deploys Red Hat Process Automation Manager - KIE Server

Options:

* `kieserver_deployment_name` (Required): How the k8s and openshift objects will be named. E.g. `svc/authoring-kieserver`
* `kieserver_service_name` (Required): How to name the `service` label. E.g. `rhpam-kieserver`
* `kieserver_ha`: If set to true it will create a service account `{{ _apb_plan_id }}-kieserver` and grant it the `view` role in order to use KUBE_PING
* `kieserver_db_size` (Optional): Will create a `persistentVolumeClaim` for the Database to use the value of the variable as the PVC size. (e.g. 100Mi)
* `kieserver_db_type` (Required). Defaults to H2. Choose between H2, PostgreSQL and MySQL. If different from H2, will also deploy the selected Database.
* `kieserver_image_name` (Optional): Defaults to `rhpam70-kieserver-openshift`
* `kieserver_image_tag` (Optional): Defaults to `1.0`
* `kieserver_image_namespace` (Optional): Defaults to `openshift`
* `kieserver_limits_memory` (Optional): Defaults to `2Gi`
* `kieserver_secret_name` (Optional): Secret to use. If not set a default one will be generated and used. Defaults to `{{ application_name }}-kieserver`
* `kieserver_image_pull_policy`: Defaults to `IfNotPresent`
* `kieserver_external_maven_repo` (Optional): External maven repo to use.
