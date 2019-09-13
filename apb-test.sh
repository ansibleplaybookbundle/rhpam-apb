#!/bin/bash

# Idea and code snippets taken from:
# https://gist.github.com/geerlingguy/73ef1e5ee45d8694570f334be385e181

# Exit on any individual command failure.
set -ex

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
neutral='\033[0m'

apb_name=${apb_name:-"rhpam7-dev-apb"}
apb_image=rhpam-7/rhpam7-dev-apb
dockerfile=${dockerfile:-"Dockerfile"}
cluster_role=${cluster_role:-"admin"}
binding=${binding:-"rolebinding"}

# Lock Helm version until latest is functional
DESIRED_HELM_VERSION="v2.8.2"

function run_apb() {
    local action=$1
    local pod_name="$apb_name-$action"

    printf ${green}"Run $action Playbook"${neutral}"\n"
    echo -en 'travis_fold:start:'$pod_name'\\r'
    $CMD run "$pod_name" \
        --namespace=$apb_name \
        --env="POD_NAME=$pod_name" \
        --env="POD_NAMESPACE=$apb_name" \
        --image=$apb_image \
        --image-pull-policy=Never \
        --restart=Never \
        --attach=true \
        --serviceaccount=$apb_name \
        -- $action --extra-vars '{ "namespace": "'$apb_name'", "cluster": "'$CLUSTER'" }'
    printf "\n"
    $CMD get all -n $apb_name
    echo -en 'travis_fold:end:'$pod_name'\\r'
    printf "\n"
}

function setup_openshift() {
    printf ${green}"Testing APB in OpenShift"${neutral}"\n"
    echo -en 'travis_fold:start:openshift\\r'
    printf ${yellow}"Setting up docker for insecure registry"${neutral}"\n"
    sudo apt-get update -qq
    sudo cat /etc/docker/daemon.json

    #{"registry-mirrors": ["https://mirror.gcr.io"], "mtu": 1460}
    # sudo echo "{ \"insecure-registries\": [\"172.30.0.0/16\"] }" >  /etc/docker/daemon.json
    # sudo rm -rf  /etc/docker/daemon.json
    sudo sed -i "s/\DOCKER_OPTS=\"/DOCKER_OPTS=\"--insecure-registry=172.30.0.0\/16 /g" /etc/default/docker
    sudo cat /etc/default/docker
    sudo iptables -F
    sudo service docker restart
    sudo ps faux | grep docker

    printf "\n"

    printf ${yellow}"Bringing up an openshift cluster and logging in"${neutral}"\n"
#    sudo docker cp $(docker create docker.io/openshift/origin:$OPENSHIFT_VERSION):/bin/oc /usr/local/bin/oc
#    sudo cp /usr/local/bin/oc /usr/local/bin/kubectl
    if [ "$OPENSHIFT_VERSION" == "v3.11" ]; then
        wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
        tar -xzvf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz --strip-components=1 openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc

    elif [ "${OPENSHIFT_VERSION}" == "v3.10" ]; then
        wget https://github.com/openshift/origin/releases/download/v3.10.0/openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit.tar.gz
        tar -xzvf openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit.tar.gz --strip-components=1 openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit/oc

    elif [ "${OPENSHIFT_VERSION}" == "v3.9" ]; then
        wget https://github.com/openshift/origin/releases/download/v3.9.0/openshift-origin-client-tools-v3.9.0-191fece-linux-64bit.tar.gz
        tar -xzvf openshift-origin-client-tools-v3.9.0-191fece-linux-64bit.tar.gz --strip-components=1 openshift-origin-client-tools-v3.9.0-191fece-linux-64bit/oc
    fi
    sudo cp oc /usr/local/bin/
    sudo cp /usr/local/bin/oc /usr/local/bin/kubectl
    oc cluster up \
        --skip-registry-check=true \
        --routing-suffix=172.17.0.1.nip.io \
        --public-hostname=172.17.0.1 \
        --enable=service-catalog,template-service-broker,router,registry,web-console,persistent-volumes,sample-templates,rhel-imagestreams

    echo -en 'travis_fold:end:openshift\\r'
    printf "\n"

    oc login -u system:admin

    # Use for cluster operations
    export CMD=oc
    export CLUSTER=openshift
    alias kubectl='oc'
}

function setup_kubernetes() {
    printf ${green}"Setup: Testing APB in Kubernetes"${neutral}"\n"

    # https://github.com/kubernetes/minikube#linux-continuous-integration-without-vm-support
    printf ${yellow}"Bringing up minikube"${neutral}"\n"
    echo -en 'travis_fold:start:minikube\\r'
    sudo curl -Lo /usr/bin/minikube https://storage.googleapis.com/minikube/releases/v0.27.0/minikube-linux-amd64
    sudo chmod +x /usr/bin/minikube
    if [ "$KUBERNETES_VERSION" == "latest" ]; then
        sudo curl -Lo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    else
        sudo curl -Lo /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$KUBERNETES_VERSION/bin/linux/amd64/kubectl
    fi
    sudo chmod +x /usr/bin/kubectl
    curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | DESIRED_VERSION=$DESIRED_HELM_VERSION bash

    export MINIKUBE_WANTUPDATENOTIFICATION=false
    export MINIKUBE_WANTREPORTERRORPROMPT=false
    export MINIKUBE_HOME=$HOME
    export CHANGE_MINIKUBE_NONE_USER=true
    mkdir $HOME/.kube || true
    touch $HOME/.kube/config
    export KUBECONFIG=$HOME/.kube/config

    if [ "$KUBERNETES_VERSION" == "v1.9.0" ]; then
      export AUTO_ESCALATE=true
    fi

    if [ "$KUBERNETES_VERSION" == "latest" ]; then
        sudo minikube start \
            --vm-driver=none \
            --bootstrapper=localkube \
            --extra-config=apiserver.Authorization.Mode=RBAC
    else
        sudo minikube start \
            --vm-driver=none \
            --bootstrapper=localkube \
            --extra-config=apiserver.Authorization.Mode=RBAC \
            --kubernetes-version=$KUBERNETES_VERSION
    fi
    minikube update-context

    # this for loop waits until kubectl can access the api server that Minikube has created
    for i in {1..150}; do # timeout for 5 minutes
      kubectl get po &> /dev/null && break
      sleep 2
    done

    # Install service-catalog
    helm init --wait
    kubectl create clusterrolebinding tiller-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
    helm repo add svc-cat https://svc-catalog-charts.storage.googleapis.com
    # TODO: Remove when 0.1.29 is released
    helm install svc-cat/catalog --version 0.1.27 --name catalog --namespace catalog
    # Wait until the catalog is ready before moving on
    until kubectl get pods -n catalog -l app=catalog-catalog-apiserver | grep 2/2; do sleep 1; done
    until kubectl get pods -n catalog -l app=catalog-catalog-controller-manager | grep 1/1; do sleep 1; done

    echo -en 'travis_fold:end:minikube\\r'
    printf "\n"

    # Use for cluster operations
    export CMD=kubectl
    export CLUSTER=kubernetes
    alias oc='kubectl'
}

function requirements() {
    printf ${yellow}"Installing requirements"${neutral}"\n"
    echo -en 'travis_fold:start:install_requirements\\r'
    if [ -z "$TRAVIS_PYTHON_VERSION" ]; then
        export PATH=$HOME/.local/bin:$PATH
        pip install --pre apb yamllint --user
    else
        pip install --pre apb yamllint
    fi

    # Install nsenter
    docker run --rm jpetazzo/nsenter cat /nsenter > /tmp/nsenter 2> /dev/null; sudo cp /tmp/nsenter /usr/local/bin/; sudo chmod +x /usr/local/bin/nsenter; which nsenter
    echo -en 'travis_fold:end:install_requirements\\r'
    printf "\n"
}

function lint_apb() {
    printf ${green}"Linting apb.yml"${neutral}"\n"
    echo -en 'travis_fold:start:lint.1\\r'
    yamllint apb.yml
    echo -en 'travis_fold:end:lint.1\\r'
    printf "\n"
}

function build_apb() {
    printf ${green}"Building apb"${neutral}"\n"
    echo -en 'travis_fold:start:build.1\\r'
    encoded_apb=$(base64 -w 0 apb.yml)
    encoded_apb_from_dockerfile=$(sed -e :a -e '/\\$/N; s/\\\n//; ta' target/image/Dockerfile | grep LABEL | sed 's/[[:blank:]]\+/ /g' | tr ' ' '\n' | grep 'com.redhat.apb.spec' | sed -e 's/^com.redhat.apb.spec=//' -e 's/"//g')

    if [ "${encoded_apb}" != "${encoded_apb_from_dockerfile}" ]; then
        printf ${red}"Committed APB spec differs from built apb.yml spec"${neutral}"\n"
        exit 1
    fi

    echo -en 'travis_fold:end:build.1\\r'
    printf "\n"
}

function lint_playbooks() {
    printf ${green}"Linting playbooks"${neutral}"\n"
    echo -en 'travis_fold:start:lint.2\\r'
    playbooks=$(find playbooks/ -maxdepth 1 -type f -printf "%f\n" -name '*.yml' -o -name '*.yaml')
    if [ -z "$playbooks" ]; then
        printf ${red}"No playbooks"${neutral}"\n"
        exit 1
    fi
    for playbook in $playbooks; do
        docker run --entrypoint ansible-playbook $apb_image /opt/apb/project/$playbook --syntax-check
    done
    echo -en 'travis_fold:end:lint.2\\r'
    printf "\n"
}

function setup_cluster() {
    if [ -n "$OPENSHIFT_VERSION" ]; then
        setup_openshift
    elif [ -n "$KUBERNETES_VERSION" ]; then
        setup_kubernetes
    else
        printf ${red}"No cluster environment variables set"${neutral}"\n"
        exit 1
    fi
}

function create_apb_namespace() {
    if [ -n "$OPENSHIFT_VERSION" ]; then
        oc new-project $apb_name
        oc get is -n openshift
        oc create -f $image_stream -n $apb_name
    elif [ -n "$KUBERNETES_VERSION" ]; then
        kubectl create namespace $apb_name
    else
        printf ${red}"No cluster environment variables set"${neutral}"\n"
        exit 1
    fi
    $CMD get namespace $apb_name -o yaml
}

function create_sa() {
    printf ${yellow}"Get enough permissions for APB to run"${neutral}"\n"
    $CMD create serviceaccount $apb_name --namespace=$apb_name
    $CMD create $binding $apb_name \
        --namespace=$apb_name \
        --clusterrole=$cluster_role \
        --serviceaccount=$apb_name:$apb_name
    $CMD get serviceaccount $apb_name --namespace=$apb_name -o yaml
    $CMD get $binding $apb_name --namespace=$apb_name -o yaml
    sleep 5
    printf "\n"
}

# Run the test
function test_apb() {
    requirements
    lint_apb
    build_apb
    lint_playbooks
    #setup_cluster
    #create_apb_namespace
    #create_sa
    #run_apb "test"
}

# Allow the functions to be loaded, skipping the test run
if [ -z $SOURCE_ONLY ]; then
    test_apb
fi