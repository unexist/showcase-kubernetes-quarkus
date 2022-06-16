.DEFAULT_GOAL := jib

clean:
	mvn clean

build: clean
	mvn build

run: clean
	mvn quarkus:dev

jib: clean
	mvn package -Dquarkus.container-image.build=true

docker: clean
	mvn package -Dquarkus.container-image.build=true -Dquarkus.container-image.push=true

manifest:
	@csplit -k --suppress-matched -z --prefix=MANIFEST target/kubernetes/kubernetes.yml "/^---$$/" "{*}"

	@mv -f MANIFEST00 deployment/helm/quarkus/templates/service.yaml
	@mv -f MANIFEST01 deployment/helm/quarkus/templates/deployment.yaml

helm: jib manifest
	mvn helm:package

# Env
env-testcontainers:
	launchctl setenv TESTCONTAINERS_CHECKS_DISABLE true
	launchctl setenv TESTCONTAINERS_RYUK_DISABLED true
	launchctl setenv TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE unix://${HOME}/.local/share/containers/podman/machine/podman-machine-default/podman.sock

env-podman:
	launchctl setenv DOCKER_HOST unix://${HOME}/.local/share/containers/podman/machine/podman-machine-default/podman.sock


.PHONY: docs
docs:
	mvn -f docs/pom.xml generate-resources

	@echo
	@echo "******************************************************"
	@echo "*                                                    *"
	@echo "* Documentation can be found here:                   *"
	@echo "* docs/target/generated-docs/1.0-SNAPSHOT/index.html *"
	@echo "*                                                    *"
	@echo "******************************************************"
	@echo
