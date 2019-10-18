# This is a multi-stage docker file

# Stage: 1
FROM python:3.6

# Upgrade pip
RUN pip install --upgrade pip

# Install project dependencies
RUN pip install Django==2.1.5
RUN pip install django-cors-headers==2.4.0
RUN pip install django-leaflet==0.24.0
RUN pip install django-simple-history==2.7.0
RUN pip install djangorestframework==3.9.1
RUN pip install djangorestframework-gis==0.14
RUN pip install docker==3.7.0
RUN pip install docker-compose==1.23.2
RUN pip install gunicorn==19.9.0
RUN pip install psycopg2-binary==2.7.6.1
RUN pip install python-decouple==3.1
RUN pip install djangorestframework-jwt==1.11.0
RUN pip install coreapi==2.3.3
RUN pip install sphinx==1.8.4

# Stage: 2
FROM python:3.6

# Set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# get files from first stage
COPY --from=0 /usr/local/lib /usr/local/lib

# Set work directory
WORKDIR /code

RUN apt-get update && apt-get install -y --fix-missing --no-install-recommends \
apt-utils \
binutils \
libproj-dev \
gdal-bin

# Copy project
COPY . /code/

# Install updated dependencies
RUN pip install -r requirements.txt

# listen on this port
EXPOSE 8000

CMD python manage.py runserver 0.0.0.0:8000
