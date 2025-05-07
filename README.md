# PG documentation

## Connecting to Server
1. The db master user and password are provided (either through tfvars or from environment variables). They are used to create the postrges instance, and for connecting subsequently. 
2. TF can't pass a db name - the default pne created is called ```postgres```. 
3. Connecting to the DB: 
```
# environment variables
export PGUSER=pgadmin
export PGPASSWORD='Admin!123' # single quote to escape weird chars
export PGHOST=artifactory-postgres.crco86gkgsng.us-east-2.rds.amazonaws.com

# connect to the default db
psql -h $PGHOST -U $PGUSER -d postgres
```
4. To run a script, e.g., to create the artifactory db:
```
psql -h $PGHOST -U $PGUSER -d postgres -f setup.sql
```

5. You can pass variables to the sql script by using the `-v` flag:
```
export ARTIFACTORY_PASSWORD='Admin!123' # make sure to single quote
psql -h $PGHOST -U $PGUSER -f setup.sql -v artifactory_password="'$ARTIFACTORY_PASSWORD'" -d postgres
```
