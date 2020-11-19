CLUSTER := "vanderlande"

# Quarkus
quarkus-build:
	cd .. && mvn clean package -Dquarkus.container-image.build=true #-Dquarkus.container-image.push=true

# Kind	
kind-create:
	kind create cluster --name $(CLUSTER) --config=./manifests/cluster-install.yml

kind-delete:
	kind delete cluster --name $(CLUSTER)

kind-load:
	$(eval LATEST := $(shell docker images --format "{{ .Repository}}:{{ .Tag }}" | head -n1))
	
	kind load docker-image --name $(CLUSTER) $(LATEST)

# Kubernetes
k8s-deploy:
	kubectl apply -f ../target/kubernetes/kubernetes.yml 

k8s-undeploy:
	kubectl delete -f ../target/kubernetes/kubernetes.yml

k8s-redeploy: k8s-undeploy k8s-deploy

k8s-dashboard:
	kubectl apply -f ./manifests/dashboard-install.yml
	kubectl apply -f ./manifests/dashboard-users.yml

k8s-token:
	$(eval TOKENNAME := $(shell kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $$1}'))
	
	kubectl -n kubernetes-dashboard describe secret $(TOKENNAME)
	
# Prometheus
prom-install:
	docker pull prom/prometheus
	
	kubectl apply -f ./manifests/prom-install.yml
	kubectl apply -f ./manifests/prom-configmap.yml
		
prom-uninstall:
	kubectl delete -f ./manifests/prom-install.yml	
		kubectl delete -f ./manifests/prom-configmap.yml	

# Ingress
ingress-install:
	kubectl apply -f ./manifests/ingress-install.yml
	
ingress-helm-install:
	helm install --generate-name nginx-stable/nginx-ingress
	
ingress-configure:
	kubectl wait --namespace ingress-nginx \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=controller \
		--timeout=90s
	
ingress-todo:
	kubectl apply -f ./manifests/todo-ingress.yml

ingress-dashboard:
	kubectl apply -f ./manifests/dashboard-ingress.yml
	
ingress-prom:
	kubectl apply -f ./manifests/prom-ingress.yml
		
# Docker
docker-cricr-images:
	docker exec -it $(CLUSTER)-control-plane crictl images

docker-images:
	docker images
	
# Compund
install: kind-create k8s-dashboard ingress-install ingress-configure ingress-dashboard
	
uninstall: kind-delete	
