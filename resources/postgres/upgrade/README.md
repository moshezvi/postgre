# General notes on the blue-green deployment
Create a backup snapshot
~~~sh
aws rds create-db-snapshot --db-instance-identifier pg-12-tf --db-snapshot-identifier pre-upgrade-snapshot
~~~

Find which versions you can upgrade to
~~~sh
export CURR_VERSION="12.22-rds.20250220"
$ aws rds describe-db-engine-versions \
  --engine postgres \
  --engine-version $CURR_VERSION \
  --query "DBEngineVersions[*].ValidUpgradeTarget[*].{EngineVersion:EngineVersion}" --output text
 
13.20
14.17
15.12
16.8
17.4
~~~

Create a target parameter group:
~~~sh
# create
aws rds create-db-parameter-group \
    --db-parameter-group-name pg-15-custom \
    --db-parameter-group-family postgres15 \
    --description "Custom parameter group for PostgreSQL 15 upgrade"

# Modify
aws rds modify-db-parameter-group \
    --db-parameter-group-name pg-15-custom \
    --parameters "ParameterName=rds.logical_replication,ParameterValue=1,ApplyMethod=pending-reboot"
~~~

Create the blue-green deployment:
~~~sh
aws rds create-blue-green-deployment \
    --blue-green-deployment-name bg-12-15-deployment \
    --source arn:aws:rds:us-east-2:490004655840:db:pg-12-tf \
    --target-engine-version 15.12 \
    --target-db-parameter-group-name pg-15-custom
~~~

Once the green cluster is up, run validations/verifications 
~~~sh
# check status is "active"
aws rds describe-db-cluster --db-cluster-identifier pg-12-tf-green-1qrikp

# view the bg deployment
aws rds describe-blue-green-deployments --filters Name=blue-green-deployment-name,Values=bg-12-15-deployment
~~~

Run the switchover
~~~sh
aws rds switchover-blue-green-deployment \
    --blue-green-deployment-identifier bg-12-15-deployment
~~~

