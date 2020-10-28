mvn io.quarkus:quarkus-maven-plugin:1.7.3.Final:create \
-DprojectGroupId=dev.unexist.showcase \
-DprojectArtifactId=quarkus-kind-mp-showcase \
-DprojectVersion=0.1 \
-DclassName="dev.unexist.showcase.todo.TodoResource" \
-Dextension="health smyllrye-metrics quarkus-smallrye-opentracing quarkus-smallrye-openapi"
