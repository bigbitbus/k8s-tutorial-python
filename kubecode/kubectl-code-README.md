
# What is this?
This directory contains a walk through of commands to get you started using  k8s with your application.

## Starting K8s Cluster(s)

Start the minikube cluster on your laptop (post [installation](https://kubernetes.io/docs/tasks/tools/install-minikube/)
```bash
# May take a bit - a VM is spun up
minikube start
```

Point your local host [docker client installation](https://docs.docker.com/install/) to the minikube VM's docker runtime. This helps you avoid the step of pushing to the docker registry every time you make a code change - K8s will find the image locally in the minikube docker runtime.
```bash
# Linux
eval $(minikube docker-env)
``` 

After you make any changes to the [application code](/django-poll-project) you will need to create a new container and push it to the docker registry if you want to use the image on a remote k8s cluster (such as the AWS EKS cluster we [setup](/aws-k8s-pgdb-with-terraform/aws-kubernetes/aws-k8s-README.md)). More details on creating and pushing local docker images in a related README: [poll-app-README.md](/django-poll-project/poll-app-README.md).

## Default namespaces
We want a namespace called "development" in our minikube cluster and a namespace called "production" in our aws eks cluster to be the default namespaces.

```bash
# Development
kubectl config use-context minikube
kubectl create namespace development
kubectl config set-context minikube --namespace=development

 #Production
kubectl config use-context aws
kubectl create namespace production
kubectl config set-context aws --namespace=production
```

## Storing secrets
Secrets that show up as environment variables inside pods need to be set using k8s secrets.
For the development namespace we have
```bash
# Development - note the NA value for the s3 credentials (not needed for development)
kubectl config use-context minikube
kubectl  create secret generic db-password --from-literal=db-password=superSecret
kubectl create secret generic s3-secrets --from-literal=s3bucket=NA --from-literal=s3accesskey=NA --from-literal=s3secretkey=NA
```

For production
```bash
# Production - We need S3 secrets to store Django static files in AWS S3 for our example.
kubectl config use-context production
kubectl create secret generic s3-secrets --from-literal=s3bucket=bucket_name --from-literal=s3accesskey=substitute_access_key --from-literal=s3secretkey=substitute_secret_key
kubectl create secret generic db-password --from-literal=db-password=substitute_password
```
We can use the same secret names (db-password, s3-secrets) since they are being inserted into different namespaces (virtual k8s clusters).

## Configmaps for environment variables
We use [development](configmap_development.yaml) and [production](configmap_production) configmaps; their keys become environment variables inside of pods.

```bash
kubectl apply -f configmap_development.yaml

kubectl apply -f configmap_production.yaml
```

Note that if the correct kubectl context is set then we don't have to specify the namespace since the namespace key is stored in the metadata key inside these yaml files.

## Postgres Database
Postgres runs as a container in the development namespace and as a external service (AWS RDS database) in the production namespace. 

### Development
For development we run the postgres deployment and expose the service via a cluster-ip -- dns mapping as in [service_db_deployment.yaml](service_db_deployment.yaml).
```bash
# (after setting up the environment variables via secrets and configmap above)
kubectl config use-context minikube
kubectl apply -f deployment_postgres_development.yaml
kubectl apply -f service_db_development.yaml
kubectl  get svc
```
The "pghost" hostname defined by the service can be used in the application code (Django's [setup.py](/django-poll-project/kube101/kube101/settings.py) in our example).

### Production
For production we create an external service dns record mapping to "pghost" as in [ext_service_db_production.yaml](/kubecode/ext_service_db_production.yaml).
```bash
kubectl config use-context aws
kubectl apply -f ext_service_db_production.yaml
kubectl  get svc
```

## Django Deployment
Finally we create the Django deployment ([same deployment file](deployment_django.yaml) for both development and production)
```bash
# Development
kubectl config use-context minikube
kubectl --namespace development apply -f deployment_django.yaml

# Production
kubectl config use-context aws
kubectl --namespace production apply -f deployment_django.yaml
```
K8s will apply the appropriate configmap/secret environment variables to correctly deploy the django application for the given environment.

Finally, we need to expose the django service
```bash
# Development
kubectl config use-context minikube
kubectl --namespace development apply expose_service_django.yaml
# use the url obtained below to get access to the django server
minikube service -n development django-service --url

# Production
kubectl config use-context aws
kubectl apply expose_service_django.yaml
# AWS will create a load-balancer (at an extra cost) to expose the service. Please wait for ~5 minutes before the AWS loadbalancer becomes available.

```

## Useful commands
```bash
# Get nodes in the k8s cluster
kubectl get nodes

# Get details of a node
kubectl get nodes <node-name> -o yaml

# Get pods for the current namespace
kubectl get pods

# Get pods for a specified namespace
kubectl --namespace production get pods

# Get logs for a pod
kubectl logs <pod-name>

# Get details for a pod
kubectl get pods <pod-name> -o yaml

# Log into a container
kubectl exec -it <pod-name> bash

# Scale a deployment
kubectl scale  --replicas=5 deployment/django-deployment

# rollout history
kubectl rollout history deployment.v1.apps/django-deployment

# Go to a specific revision

kubectl rollout history deployment.v1.apps/django-deployment --revision=2

# Rollback to last revision
kubectl rollout undo deployments  deployment.v1.apps/django-deployment
```
