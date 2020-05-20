# Spring Boot Hello World example

Build: `mvn install`

Test: `mvn test`

Test reports are in target/surefire-reports.

Start the app: `java -jar target/HelloWorld-0.0.1-SNAPSHOT.jar` or `mvn spring-boot:run`

Test the app: `curl http://localhost:8080/HelloWorldExample/hello`

## Build container

Containers are the way to package modern applications along with their dependencies. They can be deployed to different environments while not being affected by configuration differences. One way to build containers is using Dockerfile in which the application and its dependencies are described.

The provided Dockerfile assumes that the build was successful and the jar is available.

`docker build -t springboot-example .`

To push to a central registry like docker.io:
```
docker tag springboot-example davidlitest/springboot-example
docker push davidlitest/springboot-example
```

To test the app in the container:
```
docker run -d -p 8080:8080 davidlitest/springboot-example
curl http://localhost:8080/HelloWorldExample/hello
```

## Notes on podman
Podman is the new deamonless tool to run containers in Linux mostly promoted by Red Hat. 
It is installed by default on RHEL8 and CentOS8 while Docker is considered depricated and unrecommended due to security reasons.
Podman is supposed to provide a functionality and user experience similar to Docker. In practice it is not 100% the same, especially in rootless environments.
It is also a project under development and newer versions provide better set of features.

Podman commands:
```
podman build -t springboot-example .
podman tag springboot-example davidlitest/springboot-example
podman push davidlitest/springboot-example
podman run -d -P davidlitest/springboot-example
```
The last command maps ports randomly. Use `podman ps` or `podman port -l` to see the host port and use it in `curl` command.

## Kubernetes deployment
It is assumed that Kubernetes (minikube) is running, `kubectl` is available in the path and the context is setup. 

To deploy the container built and pushed to a registry create k8s resources in the current namespace:
```
kubectl -f k8s/deployment.yaml
kubectl -f k8s/service.yaml
```
The first command create a deployment from a pod template, the pod is pulled from a registry and defined number of replicas is created. 
The second command creates a service making the depoyment accessible under the service name. 
In real Kubernetes clusters an ingress controller could expose the service for access from outside of the cluster.
In case of minikube `minikube service springboot-example --url` allows the access using the browser with the displayed URL.

## CI/CD
During the cluster installation Jenkins instance was deployed in the cluster. It is configured to work with the cluster using Jenkins kubernetes plugin. 
The plugin allows to define container templates to be used as slaves for Jenkins.

The job is defined as a pipeline - a scripted sequence of stages triggered by changes in the code in which the code is built, tests are executed, an image is created, pushed to a central registry and changes are applied to the cluster so the latest deployment is rolled out.
The pipeline is managed as Jenkinsfile and Jenkins can pick it from a source repository. 