#!/bin/sh

set -xeu

while getopts ':t:h' args; do
  case "$args" in
    t)
      tablename="$OPTARG"
      table_path="table/${tablename}"
      ;;
    h)
      usage
      exit 0
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

aws application-autoscaling register-scalable-target \
  --service-namespace dynamodb \
  --resource-id "$table_path" \
  --scalable-dimension "dynamodb:table:ReadCapacityUnits" \
  --min-capacity 5 \
  --max-capacity 100

aws application-autoscaling register-scalable-target \
  --service-namespace dynamodb \
  --resource-id "$table_path" \
  --scalable-dimension "dynamodb:table:WriteCapacityUnits" \
  --min-capacity 5 \
  --max-capacity 100

aws application-autoscaling put-scaling-policy \
  --service-namespace dynamodb \
  --resource-id "$table_path" \
  --scalable-dimension "dynamodb:table:ReadCapacityUnits" \
  --policy-name "DynamoDBScalingPolicy" \
  --policy-type "TargetTrackingScaling" \
  --target-tracking-scaling-policy-configuration file://read-capacity.json

aws application-autoscaling put-scaling-policy \
  --service-namespace dynamodb \
  --resource-id "$table_path" \
  --scalable-dimension "dynamodb:table:WriteCapacityUnits" \
  --policy-name "DynamoDBScalingPolicy" \
  --policy-type "TargetTrackingScaling" \
  --target-tracking-scaling-policy-configuration file://write-capacity.json
