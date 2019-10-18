#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Create the 'spectra' template db
"${psql[@]}" <<- 'EOSQL'
CREATE DATABASE spectra;
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'spectra';
EOSQL

# create schema extensions and Load PostGIS into spectra database
for DB in spectra "$POSTGRES_DB"; do
	echo "Loading PostGIS extensions into $DB"
	"${psql[@]}" --dbname="$DB" <<-'EOSQL'
	    CREATE SCHEMA IF NOT EXISTS {{cookiecutter.schema_name}};
	    CREATE SCHEMA IF NOT EXISTS extensions;
	    GRANT USAGE ON SCHEMA extensions TO public;
	    GRANT EXECUTE ON all FUNCTIONS IN SCHEMA extensions TO public;
	    ALTER DEFAULT PRIVILEGES IN SCHEMA extensions GRANT EXECUTE ON FUNCTIONS TO public;
        ALTER DEFAULT PRIVILEGES IN SCHEMA extensions GRANT USAGE ON TYPES TO public;
		CREATE EXTENSION IF NOT EXISTS postgis schema extensions;
EOSQL
done