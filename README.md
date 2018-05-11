# RHPAM APB

[![Build Status](https://travis-ci.org/ruromero/rhpam-apb.svg?branch=master)](https://travis-ci.org/ruromero/rhpam-apb) [![License](https://img.shields.io/:license-Apache2-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)

![rhpam image](./docs/imgs/jbpm_logo.png)

## Overview

This APB aims to deploy Red Hat Process Automation Manager (RHPAM) on OpenShift.

## Usage

In the Openshift control panel, find and select the `RHPAM (APB)` and fill in the required fields.

### Plans

**Authoring**

Handles the deployment of the following components:
* Business Central
 * Persistent of ephemeral
* KIE Server
 * Persistent or Ephemeral Database storage
 * Different solutions for the database-backed storage
   * H2
   * MySQL
   * PostgreSQL

**KIE Server**

Deploys only KIE Server with these options:

 * Persistent or Ephemeral Database storage
 * Different solutions for the database-backed storage
   * H2
   * MySQL
   * PostgreSQL
   * External Database
  * non-HA or HA. HA will span 3 instances of KIE Server with the selected Database (If MySQL or PostgreSQL is selected).

**SIT (System Integration Testing)**

//TBD

**Production**

Deploys a production-ready environment:
* Business Central Monitoring
  * Persistent of ephemeral
  * non-HA or HA. HA will span 3 instances of Business Central Monitoring
* KIE Server
 * Persistent or Ephemeral Database storage
 * Different solutions for the database-backed storage
   * H2
   * MySQL
   * PostgreSQL
  * non-HA or HA. HA will span 3 instances of KIE Server with the selected Database (If MySQL or PostgreSQL is selected).


**Production immutable monitor**

//TBD

**Production immutable kieserver**

//TBD

## Requirements
For HA requires the broker to run with `admin` `RoleBinding` for that the broker must be configured as follows:

```
$ oc edit cm broker-config -n ansible-service-broker
...
      sandbox_role: "admin"
...
```

The following `imageStreams` should exist in the `openshift` namespace:

 * rhpam70-businesscentral-monitoring-openshift:1.0
 * rhpam70-businesscentral-openshift:1.0
 * rhpam70-controller-openshift:1.0
 * rhpam70-elasticsearch-openshift:1.0
 * rhpam70-kieserver-openshift:1.0
 * rhpam70-smartrouter-openshift:1.0

## Testing

Check [ansible-playbook-bundle documentation](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle/blob/master/docs/getting_started.md#test).

## Demo

![rhpam apb demo](./docs/demos/rhpam-demo.gif)
