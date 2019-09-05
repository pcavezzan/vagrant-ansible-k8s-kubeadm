# Setup for a simple cluster using kubeadm (1 master et 3 workers) 

## Requirements

You need to have installed on your machine the following tools:
* [virtualbox](https://www.virtualbox.org/)
* [vagrant](https://www.vagrantup.com/)
* [ansible](https://www.ansible.com/)
* [kubectl](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/)

## Setup the cluster

### Clone the repo

```bash
$> git clone https://github.com/pcavezzan/vagrant-ansible-k8s-kubeadm.git
$> cd vagrant-ansible-k8s-kubeadm
```

## Provision the infra on virtualbox using vagrant

```bash
$ vagrant-ansible-k8s-kubeadm> vagrant up
```

## Install k8s with ansible and kubeadm

```bash
$ vagrant-ansible-k8s-kubeadm> vagrant ssh-config > ansible/ssh.config
$ vagrant-ansible-k8s-kubeadm> cd ansible 
$ ansible> ansible all -m ping
$ ansible> ansible-playbook install.yml
$ ansible> kubectl --kubeconfig=admin-local-cluster.yaml get node -o wide
```

## Install addons (networkplugin/calico, heapster, metric-server, dashboard)

```bash
$ ansible> export KUBECONFIG=$(pwd)/admin-local-cluster.yaml
$ ansible> kubectl apply -f ../addons/networkplugin/calico.yaml
$ ansible> watch kubectl -n kube-system get po -o wide
```

When all pods are running and ready, you can finish with the other addons:

```bash
$ ansible> kubectl apply -f ../addons/heapster
$ ansible> kubectl apply -f ../addons/metrics-server
$ ansible> kubectl apply -f ../addons/dashboard
$ ansible> watch kubectl -n kube-system get po -o wide
```

You're good to go :)


## What else

Either you can import your admin connection to this local cluster into your personal kubeconfig ($HOME/.kube/config) ; either you can easily setup a mini bash script to setup this env variable:

```bash
$ ansible> cat << EOF > env.sh
#!/bin/bash

export KUBECONFIG=$(pwd)/admin-local-cluster.yaml 
EOF
```


## References

* [Official installation guide for a single master kubernetes with kubeadm](https://kubernetes.io/fr/docs/setup/independent/create-cluster-kubeadm/)
* [Ansible Role - Kubernetes](https://galaxy.ansible.com/geerlingguy/kubernetes)
