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
