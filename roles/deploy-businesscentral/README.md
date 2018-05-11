# ROLE Deploy Business Central
Deploys Red Hat Process Automation Manager - Business Central

Options:

* `businesscentral_deployment_name` (Required): How the k8s and openshift objects will be named. E.g. `svc/authoring-businesscentral`
* `businesscentral_service_name` (Required): How to name the `service` label. E.g. `rhpam-businesscentral`
* `businesscentral_ha`: If set to true it will create a service account `{{ _apb_plan_id }}-businesscentral` and grant it the `view` role in order to use KUBE_PING
* `businesscentral_volume_size` (Optional): Will create a `persistentVolumeClaim` to use the value of the variable as the PVC size. (e.g. 100Mi)
* `businesscentral_image_name` (Optional): Defaults to `rhpam70-businesscentral-openshift`
* `businesscentral_image_tag` (Optional): Defaults to `1.0`
* `businesscentral_image_namespace` (Optional): Defaults to `openshift`
* `businesscentral_limits_memory` (Optional): Defaults to `2Gi`
* `businesscentral_secret_name` (Optional): Secret to use. If not set a default one will be generated and used. Defaults to `{{ application_name }}-businesscentral`
* `businesscentral_image_pull_policy`: Defaults to `IfNotPresent`
