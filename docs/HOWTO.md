# Quarkus

## Bootstrap project

```Bash
mvn io.quarkus:quarkus-maven-plugin:1.7.3.Final:create \
-DprojectGroupId=dev.unexist.showcase \
-DprojectArtifactId=quarkus-kind-mp-showcase \
-DprojectVersion=0.1 \
-DclassName="dev.unexist.showcase.todo.TodoResource" \
-Dextension="health smyllrye-metrics quarkus-smallrye-opentracing quarkus-smallrye-openapi container-image-docker"
```

## Build docker image

```Bash
mvn clean package -Dquarkus.container-image.build=true
```

# Kind

## Install on macOS

```Bash
brew install kind
kind create cluster --name vanderlande 
```

## Load docker image into kind

```Bash
kind load docker-image docker.io/unexist/quarkus-kind-mp-showcase:0.1 --name vanderlande
```

# Docker

## See running container

```Bash
docker ps -a
```

# Kubernetes

## Install dashboard and start proxy

```Bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
kubectl proxy
```

## Add user for dashboard

```Bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF
```

```Bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF
```

## Get bearer token for login

```Bash
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```

Copy token and log in
 [here](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login)

## See loaded images

```Shell
kubectl get nodes
docker exec -ti nodename bash
crictl images
```

## Get all pods

```Shell
kubectl get pods --all-namespaces
```

## Get all namespaces
```Shell
kubectl get namespace
```

## Get info about a pod

```Shell
kubectl describe pod quarkus-helm
```

## Forward local port to service

```Shell
kubectl port-forward --namespace default service/loki-grafana 3000:80
```

## Deploy image as pod

```Shell
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: quarkus-kind-mp-showcase
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      bb: web
  template:
    metadata:
      labels:
        bb: web
    spec:
      containers:
      - name: quarkus-kind-mp-showcase
        image: unexist/quarkus-kind-mp-showcase:0.1
---
apiVersion: v1
kind: Service
metadata:
  name: quarkus-kind-mp-showcase
  namespace: default
spec:
  type: NodePort
  selector:
    bb: web
  ports:
  - port: 8080
    targetPort: 8080
    nodePort: 30001
EOF
```

## Remove deployment

```
cat <<EOF | kubectl delete -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: quarkus-kind-mp-showcase
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      bb: web
  template:
    metadata:
      labels:
        bb: web
    spec:
      containers:
      - name: quarkus-kind-mp-showcase
        image: unexist/quarkus-kind-mp-showcase:0.1
---
apiVersion: v1
kind: Service
metadata:
  name: quarkus-kind-mp-showcase
  namespace: default
spec:
  type: NodePort
  selector:
    bb: web
  ports:
  - port: 8080
    targetPort: 8080
    nodePort: 30001
EOF
```

# Loki

## Add loki to helm

```Shell
helm repo add loki https://grafana.github.io/loki/charts
```

## Install loki

```Shell
helm upgrade --install loki loki/loki-stack
```

# Grafana

## Add grafana to helm

```Shell
helm repo add grafana https://grafana.github.io/helm-charts
```

## Install grafana

```Shell
gelm install loki-grafana grafana/grafana
```

## Get password for grafana

```Shell
kubectl get secret --namespace default loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

# Links

[https://quarkus.io/guides/container-image]
[https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md]
[https://github.com/grafana/helm-charts]


