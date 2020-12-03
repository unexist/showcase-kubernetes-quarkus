CLUSTER := "vanderlande"

# Quarkus
quarkus-build:
	cd .. && mvn clean package -Dquarkus.container-image.build=true #-Dquarkus.container-image.push=true

quarkus-install:
	kubectl apply -f ../target/kubernetes/kubernetes.yml

quarkus-uninstall:
	kubectl delete -f ../target/kubernetes/kubernetes.yml

# Kind
kind-create:
	kind create cluster --name $(CLUSTER) --config=./manifests/cluster-install.yml

kind-delete:
	kind delete cluster --name $(CLUSTER)

kind-load:
	$(eval LATEST := $(shell docker images --format "{{ .Repository}}:{{ .Tag }}" | head -n1))
	
	kind load docker-image --name $(CLUSTER) $(LATEST)

# Dashboard
dashboard-install:
	kubectl apply -f ./manifests/dashboard-install.yml
	kubectl apply -f ./manifests/dashboard-users.yml

dashboard-uninstall:
	kubectl delete -f ./manifests/dashboard-install.yml
	kubectl delete -f ./manifests/dashboard-users.yml

dashboard-token:
	$(eval TOKENNAME := $(shell kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $$1}'))
	
	kubectl -n kubernetes-dashboard describe secret $(TOKENNAME)

dashboard-open:
	open "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"

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

ingress-quarkus:
	kubectl apply -f ./manifests/quarkus-ingress.yml

ingress-dashboard:
	kubectl apply -f ./manifests/dashboard-ingress.yml
	
ingress-prom:
	kubectl apply -f ./manifests/prom-ingress.yml
		
# Docker
docker-cricr-images:
	docker exec -it $(CLUSTER)-control-plane crictl images

docker-images:
	docker images

docker-labels:
	$(eval LATEST := $(shell docker images --format "{{ .Repository}}:{{ .Tag }}" | head -n1))

	docker image inspect $(LATEST) | jq -r ".[0].Config.Labels"
