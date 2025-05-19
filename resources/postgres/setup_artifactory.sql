-- setup script for artifactory
CREATE USER artifactory WITH PASSWORD :'password';
CREATE DATABASE artifactory WITH OWNER=artifactory ENCODING='UTF8';
GRANT ALL PRIVILEGES ON DATABASE artifactory TO artifactory;
