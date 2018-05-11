# ROLE Deploy Business Central
Deploys Red Hat Process Automation Manager - Business Central Monitoring

Options:

* `businesscentral_monitoring_deployment_name` (Required): How the k8s and openshift objects will be named. E.g. `svc/authoring-businesscentral-monitoring`
* `businesscentral_monitoring_service_name` (Required): How to name the `service` label. E.g. `rhpam-businesscentral-monitoring`
* `businesscentral_monitoring_ha`: If set to true it will create a service account `{{ _apb_plan_id }}-businesscentral-monitoring` and grant it the `view` role in order to use KUBE_PING
* `businesscentral_monitoring_volume_size` (Optional): Will create a `persistentVolumeClaim` to use the value of the variable as the PVC size. (e.g. 100Mi)
* `businesscentral_monitoring_image_name` (Optional): Defaults to `rhpam70-businesscentral-monitoring-openshift`
* `businesscentral_monitoring_image_tag` (Optional): Defaults to `1.0`
* `businesscentral_monitoring_image_namespace` (Optional): Defaults to `openshift`
* `businesscentral_monitoring_limits_memory` (Optional): Defaults to `2Gi`
* `businesscentral_monitoring_secret_name` (Optional): Secret to use. If not set a default one will be generated and used. Defaults to `{{ application_name }}-businesscentral-monitoring`
* `businesscentral_monitoring_image_pull_policy`: Defaults to `IfNotPresent`
