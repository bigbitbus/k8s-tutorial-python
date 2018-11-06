

Pushing to docker registry
```
docker build --tag kubernetes101/django_image:`git rev-parse --short HEAD` .
docker login
# Username (not email address), password
docker push kubernetes101/django_image:`git rev-parse --short HEAD`
#May take a bit to upload

```

Create a ssh forwarding tunnel to see the Django output in the minikube VM's host
minikube ip
```
ssh -i  .\.minikube\machines\minikube\id_rsa -L 8000:localhost:8000 docker@192.168.99.100
```
Starting the container
```
 docker run -it -p 8000:8000 kubernetes101/django_image
```
Hit ^C thrice (number of gunicorn processes) to exit



```
Postgres database

```SQL
CREATE DATABASE kubetutorial;
CREATE USER  ktuser WITH PASSWORD 'password';
ALTER ROLE ktuser SET client_encoding TO 'utf8';
ALTER ROLE ktuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE ktuser SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE kubetutorial TO ktuser;
```


EKS
Remember you need 2 subnets in your VPC in 2 different zones.
Role ARN
https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html

aws configure #enter credentials
KUBECONFIG=~/.kube/config kubectl version
kubectl cluster-info
~/.kube$ kubectl apply -f config-map-aws-auth.yaml

# run a simple ubuntu client
kubectl run my-shell --rm -i --tty --image ubuntu -- bash

# connect to db
apt-get install postgresql-client -y
psql -h terraform-***.us-west-2.rds.amazonaws.com kubernetes101db kubetutorial101
Then enter dbpassword


# Working with Minikube
```
# Create namespace for development
kubectl create namespace development
# Apply configmap with environment variables
kubectl apply -f configmap_db_development.yaml
kubectl apply -f deployment_django_development.yaml 
kubectl get pods --namespace development
kubectl apply -f service_django.yaml --namespace development
kubectl get svc --namespace development
minikube service -n development django-service
```

# ONe-off login pod (e.g. createsuperuser)
kubectl --namespace development exec -it django-deployment-55d757dd79-rd9b9 bash


# AWS EKS

```   
kubectl --namespace production apply -f secret_production.yaml 
kubectl --namespace production apply -f deployment_django_production.yaml 
kubectl --namespace production exec -it django-deployment-688658b75b-5gxjt bash
< setup superuser password, for example>
kubectl --namespace production apply -f service_django.yaml 
kubectl --namespace production get svc -o wide
kubectl --namespace production delete svc django-service
 ```
Storing static files:
https://www.caktusgroup.com/blog/2014/11/10/Using-Amazon-S3-to-store-your-Django-sites-static-and-media-files/

Storing secrets
kubectl create secret generic s3-secrets --from-file=./s3accesskey.txt --from-file=./s3secretkey.txt --from-file=./s3bucket.txt
