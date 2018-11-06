#!/usr/bin/env bash

# Start Gunicorn processes
cd kube101
python manage.py collectstatic --no-input
python manage.py makemigrations
python manage.py migrate
echo Starting Gunicorn.
exec gunicorn kube101.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3
#python manage.py runserver 0.0.0.0:8000