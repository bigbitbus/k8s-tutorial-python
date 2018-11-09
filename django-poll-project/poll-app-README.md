# What is this?

The simple [Django poll app](https://docs.djangoproject.com/en/2.1/intro/tutorial01/) example used in the Django beginner tutorial. Code adapted graciously from [here](https://github.com/divio/django-polls). 


## Docker Commands

In order to effectively use Docker with k8s you will need a Docker registry account. A docker registry is a remote file server that contains docker images stored in your repository. For this tutorial we are using the free [DockerHub account](https://hub.docker.com/), which only allows public repositories. This means that anyone else can search and use the docker images you have uploaded. This is great for learning k8s best practices of __never__ baking credentials into your images!

### Setup

We assume you have a functional local minikube [installation](README.md) for development. So the Docker runtime is running within the minikube VM. You can point your host Docker client installation to control the Docker runtime inside the VM (instead of controlling the Docker runtime on the host machine itself).

 ```bash
minikube docker-env
#output:
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.39.134:2376"
export DOCKER_CERT_PATH="/home/myuseraccount/.minikube/certs"
export DOCKER_API_VERSION="1.35"
# Run this command to configure your shell:
# eval $(minikube docker-env)

#See comment above: this command is host-OS dependent.
$ eval $(minikube docker-env)

```

You should check that docker commands now run on the minikube VM:
```bash

docker ps 
# You should see many docker containers running k8s internals - dns, etcd, controllers etc.
```

Commit the application code in this directory (to git). We will use the git hash to create tags for our docker images so that we have a way to get from the docker image tag to the application code version hash at a later time.
```bash
git commit -a -m "My awesome application update"
```
Build the docker file and tag it with a short git hash
```bash
docker build --tag kubernetes101/django_image:`git rev-parse --short HEAD` .
```
You can run your container using docker (only for quick debugging):
```bash
 docker run -it -p 8000:8000 kubernetes101/django_image:`git rev-parse --short HEAD`
# Hit ^C thrice (number of gunicorn processes) to exit
```

If you want to use the container on your production k8s cluster, you will need to put this image into the docker registry. Log into your docker registry account 
```bash
docker login
#Enter your docker registry credentials
docker push kubernetes101/django_image:`git rev-parse --short HEAD`
#May take a bit to upload
```
Note the repository,name and tag of the container (kubernetes101/django_image:`git rev-parse --short HEAD`) - you will need this when telling k8s which container to run.

The [workflow.sh](django-poll-project/workflow.sh) implements a simple workflow of updating the code, building a new container image, and updating the deployment (the steps discussed above). Read through the comments in the script and try running it in your development environment.
```
./workflow.sh
``` 

## Storing static files in S3

Static files are collected and stored in an S3 bucket in production, as discussed [here](https://www.caktusgroup.com/blog/2014/11/10/Using-Amazon-S3-to-store-your-Django-sites-static-and-media-files/).

## Running Django Management Commands
Log into a running pod to run manage.py comands. For example:
```bash
kubectl get pods
kubectl  exec django-deployment-xxxxxx bash
cd kube101
python manage.py createsuperuser
exit
```