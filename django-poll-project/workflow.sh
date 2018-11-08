#!/bin/bash
OLD_IMAGE_HASH=`git rev-parse --short HEAD`

# Commit changes
git commit -a -m "Made a small change"
echo "New git head revision at: "
git rev-parse --short HEAD

# Build new image
NEW_IMAGE_HASH=`git rev-parse --short HEAD`
docker build --tag kubernetes101/django_image:$NEW_IMAGE_HASH .

# Replace old image by new image
sed -i -e 's/$OLD_IMAGE_HASH/$NEW_IMAGE_HASH/g' ../kubecode/deployment_django.yaml

# Optional - push your code to git
# git push

# Optional - push your docker image to the registry, not needed for minikube
# docker login 
# docker push kubernetes101/django_image:$NEW_IMAGE_HASH

# Apply (current context, namespace)
kubectl apply -f ../kubecode/deployment_django.yaml

