DynamoDBAutoscalingTest
===

# Set Autoscaling

## Check

```bash
$ for f in $(cat tables.txt); do echo "$f"; sh get-scale --t "$f"; done
```

## Apply

```bash
$ for f in $(cat tables.txt); do echo "$f"; sh set-auto-scale --t "$f"; done
```

# TEST

## YCSB

- [YCSB](https://github.com/brianfrankcooper/YCSB)

### Install

```bash
$ curl -O --location https://github.com/brianfrankcooper/YCSB/releases/download/0.12.0/ycsb-0.12.0.tar.gz
$ tar xfvz ycsb-0.12.0.tar.gz
$ cd ycsb-0.12.0
```

### Setup

- dynamodb/conf/dynamodb.properties

```
dynamodb.awsCredentialsFile = dynamodb/conf/AWSCredentials.properties
dynamodb.primaryKey = firstname
dynamodb.endpoint = http://dynamodb.ap-northeast-1.amazonaws.com
```

- dynamodb/conf/AWSCredentials.properties

```
accessKey = <YOUR_AWS_ACCESS_KEY>
secretKey = <YOUR_AWS_SECRET_KEY>
```

- workloads/first_attack

```
workload=com.yahoo.ycsb.workloads.CoreWorkload

recordcount=1000
operationcount=2000000

insertstart=0
fieldcount=10
fieldlength=100

readallfields=true
writeallfields=false

table=Test

fieldlengthdistribution=constant

readproportion=0.8
updateproportion=0.15
insertproportion=0.05

readmodifywriteproportion=0
scanproportion=0
maxscanlength=1000
scanlengthdistribution=uniform
insertorder=hashed
requestdistribution=zipfian
hotspotdatafraction=0.2
hotspotopnfraction=0.8

measurementtype=histogram
histogram.buckets=1000
timeseries.granularity=1000
```

### Initailize

```bash
$ ./bin/ycsb load dynamodb -P workloads/first_attack -P dynamodb/conf/dynamodb.properties
```

### Run

```bash
$ ./bin/ycsb run dynamodb -P workloads/first_attack -P dynamodb/conf/dynamodb.properties
```