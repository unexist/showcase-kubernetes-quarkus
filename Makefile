LATEST := $(shell docker images --format "{{ .Repository}}:{{ .Tag }}" | head -n1)
TOKENNAME := $(shell kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $$1}')

build:
	mvn clean package -Dquarkus.container-image.build=true #-Dquarkus.container-image.push=true

load:
	kind load docker-image --name vanderlande ${LATEST}

apply:
	kubectl apply -f target/kubernetes/kubernetes.yml 

delete:
	kubectl delete -f target/kubernetes/kubernetes.yml

cluster-images:
	docker exec -it vanderlande-control-plane crictl images

docker-images:
	docker images

token:
	kubectl -n kubernetes-dashboard describe secret ${TOKENNAME}

all: delete build load apply
