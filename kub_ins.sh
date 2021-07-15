#!/bin/bash
set -e

echo "### Install kubectl (kubernetes client) ###"
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo "### Install azure cli ###"
curl -L https://aka.ms/InstallAzureCli | bash
source ~/.bashrc

echo "### Login to azure ###"
echo "Log in to azure with your Skype/Microsoft account"
az login

echo "### Create kubernetes cluster on azure ###"
read -p "Press Enter if you have already created the kubernetes cluster on azure, otherwise skip"

echo "### Login to kubernetes cluster ###"
echo 'export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config' >> ~/.bashrc
source ~/.bashrc
if ! which jq 2< /dev/null; then
  echo "Need to install jq"
  sudo apt-get install jq
fi
resourceGroup=`az aks list | jq '.[].resourceGroup' | tr -d '"'`
clusterName=`az aks list | jq '.[].name' | tr -d '"'`
az aks get-credentials --name $clusterName --resource-group $resourceGroup

echo "### Create persistent volume claim ###"
kubectl create -f azure-pvc-disk.yaml

echo "### Install helm ###"
cd /tmp
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > install-helm.sh
chmod u+x install-helm.sh
./install-helm.sh

echo "### Configure tiller on kubernetes ###"
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller

echo "The .bashrc was updated, don't forget to load it"
