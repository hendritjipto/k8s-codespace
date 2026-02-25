# 👾 Create a kubernetes cluster 
----------
This repository will show you on how to create kubernetes cluster quickly in codespace from github. 

- Create the codespace from this repository 
![alt text](img/codespace.png)
- Open the terimal 
- Run this command to create the k8s cluster
```shell
k3d cluster create k8s1 --servers 1 --agents 1 -p "8080:3000@loadbalancer" 
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

- Build the image from Dockerfile on app folder, specify the image name 

    ```nodeapp:latest```

- Export image to k3d cluster 

    ```k3d image import nodeapp:latest -c dev```

- Create a production namespace on kubernetes 

    ```kubectl create namespace production```

- Install the appplication to kubernetes. 
    - Run this command ```kubectl apply -f app/express-app.yaml```

- Install kubernetes helm monitoring
    - Please change the ```<<REPLACE WITH GC TOKEN>>``` with the Grafana Cloud token

```
helm upgrade --install --rollback-on-failure --timeout 300s grafana-k8s-monitoring grafana/k8s-monitoring \
  --namespace grafanacloud --create-namespace \
  --values helm/definition.yaml
```