# 👾 Create a kubernetes cluster 
----------
This repository will show you on how to create kubernetes cluster quickly in codespace from github. 

- Create the codespace from this repository 
![alt text](img/codespace.png)
- Open the terimal 
- Run this command to create the k8s cluster
```shell
k3d cluster create dev --servers 1 --agents 1 -p "8080:3000@loadbalancer" 
```
- To check/verify : 
```shell
# verify
kubectl get nodes
kubectl get pods -A
```
- To install kubernetes for Grafana Cloud please use <b>helm</b> 
- To view your kubernetes cluster please use k9s 
```shell
#run this command 
k9s
```
![alt text](img/k9s.png)
- ⚠️ Due to the limited resource allocated to codespace be mindful on adding multiple nodes 


# 👾 Deploy the application to kubernetes
- Build the image from Dockerfile on app folder 
- Export image to k3d cluster
```shell
k3d image import workspace:latest -c dev
```