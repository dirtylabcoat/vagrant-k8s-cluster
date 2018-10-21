#!/bin/bash
KUBEINITLOG=/vagrant/kubeinit.log
KUBENODEJOIN=/vagrant/kubenodejoin.sh
kubeadm init --apiserver-advertise-address=192.168.1.240 --apiserver-cert-extra-sans=localhost,localhost.localdomain,127.0.0.1 --pod-network-cidr 10.244.0.0/16 | tee $KUBEINITLOG
echo '#!/bin/bash' > $KUBENODEJOIN
grep "kubeadm join" $KUBEINITLOG >> $KUBENODEJOIN
chmod +x $KUBENODEJOIN
USER_HOME=/home/vagrant
USER_GROUP_IDS=$(id vagrant -u):$(id vagrant -g)
mkdir -p $USER_HOME/.kube
chown $USER_GROUP_IDS $USER_HOME/.kube
cp -i /etc/kubernetes/admin.conf $USER_HOME/.kube/config
chown $USER_GROUP_IDS $USER_HOME/.kube/config
export KUBECONFIG=$USER_HOME/.kube/config
# Install Flannel pod network
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml
