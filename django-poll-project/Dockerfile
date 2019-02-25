# Base image from Docker hub
FROM python:3.6.7-stretch

# Image labels
LABEL author="bigbitbus"
LABEL email="contact@bigbitbus.com"

# Environment variable - make stderr/stdout unbuffered
ENV PYTHONUNBUFFERED 1

# Handle requirements install first - this speeds up docker image creation
COPY requirements.txt .
# Install python requirements
RUN pip install -r requirements.txt
RUN rm requirements.txt

#Copy the Django code of the pollproject
COPY . . 
# EXPOSE port 8000 to allow communication to/from server
EXPOSE 8000

RUN chmod +x gunicornrun.sh
CMD ["./gunicornrun.sh"]