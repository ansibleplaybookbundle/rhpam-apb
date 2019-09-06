# RHPAM APB

[![Build Status](https://travis-ci.org/ansibleplaybookbundle/rhpam-apb.svg?branch=master)](https://travis-ci.org/ansibleplaybookbundle/rhpam-apb) [![License](https://img.shields.io/:license-Apache2-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

## Overview

This APB aims to deploy Red Hat Process Automation Manager (RHPAM) on OpenShift.

As a system engineer, you can deploy a Red Hat Process Automation Manager immutable server environment on Red Hat OpenShift Container Platform to provide an infrastructure to execute processes and other business assets.
You can use standard integration tools to manage the immutable Process Server image.
You can create new server images to add and update processes.

 Make sure the required ImageStreamTags exist in the openshift project. See below for the required images

## Usage

In the Openshift control panel, find and select the `Red Hat Process Automation Manager (APB)` and fill in the required fields.

## Plans

### Trial

Deploy an ephemeral environment for testing Business Central and KIE Server. A default `adminUser` user will be created with the `RedHat` password.
In case the generated routes need to be overridden, it is possible to set custom routes for both applications.

Deploys the following components:

* Business Central (ephemeral)
* KIE Process Server (ephemeral)

### Authoring

An environment for creating and modifying processes using Business Central. It consists of pods that provide Business Central for the authoring work and a Process Server for test execution of the processes.

Handles the deployment of the following components:

* Business Central (Persistent)
* KIE Process Server (Persistent)

### Immutable KIE Server

In this environment, when you deploy a Process Server pod, it builds an image that loads and starts a process or group of processes. You cannot stop any process on the pod or add any new process to the pod.
If you want to use another version of a process or modify the configuration in any other way, you deploy a new server image and displace the old one.

* **Artifact source** is mandatory and will configure the KIE Process Server instances to clone and build the source existing on a GIT repository to then deploy it and run it.
* **Router** integration is optional and will connect the KIE Process Server instances with an existing router endpoint.
* **Controller** integration is optional and will allow the KIE Process Server instances to be managed or monitored by an existing controller.

### Immutable Monitor

Use Business Central Monitoring to monitor the performance of the environment and to stop and restart some of the process instances, but not to deploy additional processes to any Process Server or undeploy any existing ones (you can not add or remove containers)

Deploys the following components:

* Business Central Monitoring (Persistent)
* Smart Router (Persistent)

### Managed Environment

An environment for running existing processes for staging and production purposes.
This environment includes several groups of Process Server pods; you can deploy and undeploy processes on every such group and also scale the group up or down as necessary. Use Business Central Monitoring to deploy, run, and stop the processes and to monitor their execution.

Deploys the following components:

* Business Central Monitoring (Persistent)
* Smart Router (Persistent)
* KIE Process Server (Persistent)

## Requirements

### Automation Broker

Requires the Automation Broker to be deployed and have `sandbox_role` set to `admin`. Edit the `broker-config` ConfigMap in the `openshift-automation-service-broker` namespace:

```{bash}
$ oc edit cm -n openshift-automation-service-broker broker-config
...
    openshift:
      host: ''
      ca_file: ''
      bearer_token_file: ''
      image_pull_policy: IfNotPresent
      sandbox_role: admin
...
```

Restart the automation service broker by deleting the pod:

```{bash}
$ oc delete pods -n openshift-automation-service-broker -l app=openshift-automation-service-broker
pod "openshift-automation-service-broker-1-b7pl6" deleted
```

### ImageStreams

The following `imageStreams` should exist in the `openshift` namespace:

* rhpam76-businesscentral-monitoring-openshift:1.0
* rhpam76-businesscentral-openshift:1.0
* rhpam76-controller-openshift:1.0
* rhpam76-elasticsearch-openshift:1.0
* rhpam76-kieserver-openshift:1.0
* rhpam76-smartrouter-openshift:1.0

### KIE Process Server

* If the number of replicas is greater than 1, H2 Database is not allowed.
* If the `External Database` is selected, all the fields in the `External Database` group are mandatory

## Options and integrations

### Database types

* H2
* MySQL
* PostgreSQL
* External Database

### RH-SSO

Configures authentication of Business Central, Business Central Monitoring and KIE Process Server against an existing Red Hat Single Sign-On instance.

The user and password is only needed when during the startup it is necessary to create the client and secret on the provided realm. If it already exists, these fields can be left empty.

## LDAP

Configures authentication of Business Central, Business Central Monitoring and KIE Process Server against an existing LDAP server.

### External Maven Repository

It is possible to additionally use an external Maven Repository for publishing the generated kjars. Except for the *Managed environment* and the *Immutable monitor* where is required.

### Secrets and Keystores

KIE Process Servers and Business Central (and Monitoring) requires a certificate in order to start the secure port (8443). For that, the user will be prompted to introduce the name of the secret containing a keystore with the certificate to use. If this secret doesn't exist, the APB will generate one selfsigned and use it.

## Development

When the `apb.yml` file is modified the base64 encoded version of the file must be generated and set to the image.yml file. There's a convenience script that will do that for you.

```{bash}
$ ./prepare.sh
Update image.yaml file with b64 encoded spec
Finished prepare
```

## Build

### Cekit

This APB can be built using [cekit](https://cekit.readthedocs.io/en/latest/index.html)

```{bash}
$ cekit build
2018-10-03 11:56:06,752 cekit        INFO     Generating files for docker engine.
2018-10-03 11:56:06,812 cekit        INFO     Initializing image descriptor...
...
2018-10-03 11:57:31,545 cekit        INFO     Image built and available under following tags: rhpam-7/rhpam-apb:1.3, rhpam-7/rhpam-apb:latest
2018-10-03 11:57:31,545 cekit        INFO     Finished!
```

### APB cli

```{bash}
Create buildconfig: 'oc new-build --binary=true --name <bundle-name>'
Start build:        'oc start-build --follow --from-dir . <bundle-name>'
```

## Testing

Check [ansible-playbook-bundle documentation](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle/blob/master/docs/getting_started.md#test).

## Demo

![rhpam apb demo](./docs/demos/rhpam-demo.gif)
