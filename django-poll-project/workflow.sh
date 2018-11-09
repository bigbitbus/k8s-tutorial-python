#!/bin/bash
echo "Original git head revision at: "
git rev-parse --short HEAD

# Commit changes - FIX THIS - you probably want
# to make the commit manually and put a proper
# commit message.
git commit -a -m "Made a small change"
echo "New git head revision at: "
git rev-parse --short HEAD

# Build new image
NEW_IMAGE_HASH=`git rev-parse --short HEAD`
docker build --tag kubernetes101/django_image:$NEW_IMAGE_HASH .

# Replace old image by new image
sed -i -e "s/kubernetes101\/django_image.*/kubernetes101\/django_image:$NEW_IMAGE_HASH/g" ../kubecode/deployment_django.yaml


# Apply (current context, namespace) in development/test
kubectl apply -f ../kubecode/deployment_django.yaml

#Run tests here

# Optional - push your docker image to the registry, not needed for minikube
# docker login
# docker push kubernetes101/django_image:$NEW_IMAGE_HASH

# Optional - push your code to git
# git push

read -p "Press any key to continue... " -n1 -s