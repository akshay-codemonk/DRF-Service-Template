# {{cookiecutter.service_name}}
This repository is home to the {{cookiecutter.service_name}} of  **Spectra** Platform and makes use of **PostgreSQL** for the database.

## Description
{{cookiecutter.description}}

## Build
Clone the repository and change to the project directory in the terminal and then use the below command to build the images
```
docker-compose up --no-start
```

## Run
Run the below command to start the containers
```
docker-compose up -d
```
Visit [127.0.0.1:8000](http://127.0.0.1:8000/admin/) to access the backend

## Stop
Run the below command to stop the containers
```
docker-compose down
```

## Apply fixtures 
Keep the containers running and use the below commands to insert master data (required only once)

Open a bash shell in the container running django
```
docker exec -it {{cookiecutter.service_name}}_web_1 bash
```
In the container's bash, run these commands to check that all migrations are generated and applied
```
python manage.py makemigrations
python manage.py migrate
```

Load data using the below commands
```
python manage.py loaddata apps/*/fixtures.json
```