# PG documentation

## Connecting to Server
1. The db master user and password are provided (either through tfvars or from environment variables). They are used to create the postrges instance, and for connecting subsequently. 
2. TF can't pass a db name - the default one created is called ```postgres```. 
3. Connecting to the DB through a Bastion: 
```
# connect to the bastion
ssh -i ~/.ssh/mozvi_key.pem ubuntu@3.148.219.242

# from bastion, run psql, using the databases endpoint
export PGUSER=pgadmin
export PGPASSWORD='Admin!123' # single quote to escape weird chars
export PGHOST=artifactory-postgres.crco86gkgsng.us-east-2.rds.amazonaws.com

# connect to the default db
psql -h $PGHOST -U $PGUSER -d postgres
```
4. Connecting to the DB with a SSH tunnel:
```
# setup a SSH tunnel through the bastion
ssh -i ~/.ssh/mozvi_key.pem -L 5433:artifactory-pg-12.crco86gkgsng.us-east-2.rds.amazonaws.com:5432 ubuntu@3.148.219.242 -fN

# Where: -fN causes the ssh server to run in the background. 

# use localhost as the HOST, and the forwarded port (5433) for connecting 
psql -h localhost -p 5433 -U $PGUSER -d postgres
```

4. To run a script, e.g., to create the artifactory db:
```
psql -h $PGHOST -U $PGUSER -d postgres -f setup_artifactory.sql
```

5. You can pass variables to the sql script by using the `-v` flag:
```
export ARTIFACTORY_PASSWORD='Admin!123' # make sure to single quote
psql -h $PGHOST -U $PGUSER -f setup.sql -v artifactory_password="'$ARTIFACTORY_PASSWORD'" -d postgres
```

## Setting up Artifactory
1. Run `setup_artifactory.sql` with a password:
```
export ARTIFACTORY_PASSWORD='some_password' # make sure to single quote
psql -h localhost -p 5433 -U $PGUSER -d postgres -f setup_artifactory.sql -v password="'$ARTIFACTORY_PASSWORD'" 

```
