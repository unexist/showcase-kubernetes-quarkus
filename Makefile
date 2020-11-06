LATEST := $(shell docker images --format "{{ .Repository}}:{{ .Tag }}" | head -n1)
TOKENNAME := $(shell kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $$1}')

define INGRESS
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    app.quarkus.io/build-timestamp: 2020-11-05 - 11:39:43 +0000
    nginx.ingress.kubernetes.io/rewrite-target: /$2
  labels:
    app.kubernetes.io/name: quarkus-kind-mp-showcase
    app.kubernetes.io/version: "0.5"
  name: quarkus-kind-mp-showcase
spec:
  rules:
    - host: ""
      http:
        paths:
          - backend:
              serviceName: quarkus-kind-mp-showcase
              servicePort: 8080
            path: /todo(/|$)(.*)
endef

build:
	mvn clean package -Dquarkus.container-image.build=true #-Dquarkus.container-image.push=true

load:
	kind load docker-image --name vanderlande $(LATEST)

deploy:
	kubectl apply -f target/kubernetes/kubernetes.yml 

undeploy:
	kubectl delete -f target/kubernetes/kubernetes.yml

redeploy: undeploy deploy

ingress:
	#kubectl apply -f - $(shell echo $INGRESS | jq)

cluster-images:
	docker exec -it vanderlande-control-plane crictl images

docker-images:
	docker images

token:
	kubectl -n kubernetes-dashboard describe secret $(TOKENNAME)

all: delete build load apply
