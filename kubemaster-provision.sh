#!/bin/bash
kubeadm init
USER_HOME=/home/vagrant
USER_GROUP_IDS=$(id vagrant -u):$(id vagrant -g)
mkdir -p $USER_HOME/.kube
chown $USER_GROUP_IDS $USER_HOME/.kube
cp -i /etc/kubernetes/admin.conf $USER_HOME/.kube/config
chown $USER_GROUP_IDS $USER_HOME/.kube/config
# Install Flannel pod network
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml

