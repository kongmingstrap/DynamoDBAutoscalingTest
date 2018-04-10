#!/bin/sh

set -xeu

while getopts ':t:s:m:h' args; do
  case "$args" in
    t)
      tablename="$OPTARG"
      table_path="table/${tablename}"
      ;;
    s)
      min="$OPTARG"
      ;;
    m)
      max="$OPTARG"
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
  --min-capacity $min \
  --max-capacity $max

aws application-autoscaling register-scalable-target \
  --service-namespace dynamodb \
  --resource-id "$table_path" \
  --scalable-dimension "dynamodb:table:WriteCapacityUnits" \
  --min-capacity $min \
  --max-capacity $max

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
