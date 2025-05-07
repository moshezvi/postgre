-- setup.sql

\connect artifactory

-- Create a temporary table to store the password
CREATE TEMP TABLE temp_vars (pwd TEXT);
-- Insert the password value
INSERT INTO temp_vars VALUES (:artifactory_password);

-- Create the Artifactory user (if not exists check is done manually since CREATE USER IF NOT EXISTS is not supported)
DO $$
DECLARE stored_pwd TEXT;

BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'artifactory_user'
   ) THEN
      --CREATE ROLE artifactory_user WITH LOGIN PASSWORD :pwd;
          -- Retrieve the password from the temporary table
      SELECT pwd INTO stored_pwd FROM temp_vars;
      EXECUTE FORMAT('CREATE ROLE artifactory_user WITH LOGIN PASSWORD %L', stored_pwd);
   END IF;
END
$$;

-- Cleanup: Drop the temporary table
DROP TABLE temp_vars;

-- --GRANT ALL PRIVILEGES ON DATABASE artifactory TO artifactory_user;
