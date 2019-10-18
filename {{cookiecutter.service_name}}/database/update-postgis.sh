#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

POSTGIS_VERSION="${POSTGIS_VERSION%%+*}"

# Load PostGIS into both template_database and $POSTGRES_DB
for DB in spectra "${@}"; do
    echo "Updating PostGIS extensions '$DB' to $POSTGIS_VERSION"
    psql --dbname="$DB" -c "
        -- Create extensions schema
        CREATE SCHEMA IF NOT EXISTS {{cookiecutter.schema_name}};
        GRANT USAGE ON SCHEMA {{cookiecutter.schema_name}} TO public;
        grant CREATE on schema {{cookiecutter.schema_name}} TO public;
	    CREATE SCHEMA IF NOT EXISTS extensions;
	    GRANT USAGE ON SCHEMA extensions TO public;
	    GRANT EXECUTE ON all FUNCTIONS IN SCHEMA extensions TO public;
	    ALTER DEFAULT PRIVILEGES IN SCHEMA extensions GRANT EXECUTE ON FUNCTIONS TO public;
        ALTER DEFAULT PRIVILEGES IN SCHEMA extensions GRANT USAGE ON TYPES TO public;
        -- Upgrade PostGIS (includes raster)
        CREATE EXTENSION IF NOT EXISTS postgis VERSION '$POSTGIS_VERSION' SCHEMA extensions;
        ALTER EXTENSION postgis UPDATE TO '$POSTGIS_VERSION';
        -- Upgrade Topology
#        CREATE EXTENSION IF NOT EXISTS postgis_topology VERSION '$POSTGIS_VERSION';
#        ALTER EXTENSION postgis_topology UPDATE TO '$POSTGIS_VERSION';
#        -- Install Tiger dependencies in case not already installed
#        CREATE EXTENSION IF NOT EXISTS fuzzystrmatch SCHEMA extensions;
#        -- Upgrade US Tiger Geocoder
#        CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder VERSION '$POSTGIS_VERSION';
#        ALTER EXTENSION postgis_tiger_geocoder UPDATE TO '$POSTGIS_VERSION';
    "
done