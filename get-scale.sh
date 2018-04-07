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

aws application-autoscaling describe-scalable-targets \
  --service-namespace dynamodb \
  --resource-id "$table_path"
