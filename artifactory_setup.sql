DO
$$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_database WHERE datname = 'artifactory'
   ) THEN
      CREATE DATABASE artifactory;
   END IF;
END
$$;

\connect artifactory

DO
$$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_roles WHERE rolname = 'artifactory_user'
   ) THEN
      EXECUTE format('CREATE USER artifactory_user WITH PASSWORD %L', :'artifactory_password');
   END IF;
END
$$;

GRANT ALL PRIVILEGES ON DATABASE artifactory TO artifactory_user;
