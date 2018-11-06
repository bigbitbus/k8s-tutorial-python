# Base image from Docker hub
FROM python:3.6.7-stretch

# Image labels
LABEL author="bigbitbus"
LABEL email="contact@bigbitbus.com"

# Environment variable - make stderr/stdout unbuffered
ENV PYTHONUNBUFFERED 1

# Copy code into container
COPY . .

# Install python requirements
RUN pip install -r requirements.txt

# EXPOSE port 8000 to allow communication to/from server
EXPOSE 8000

RUN chmod +x gunicornrun.sh
CMD ["./gunicornrun.sh"]