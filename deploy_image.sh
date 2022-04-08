#!/bin/bash
cluster_name=$1
service_name=$2
task_def_family_name=$3
new_image=$4
TASK_ARN=$(aws ecs describe-services --service $service_name --cluster $cluster_name | jq ".services[].taskDefinition" | sed -e 's/^"//' -e 's/"$//')
aws ecs describe-task-definition --task-definition $TASK_ARN>describe-task.json
sed -i -e "s|\"image\".*|\"image\":\"$new_image\"\,|g" describe-task.json
CONTAINER_DEFS=$(cat describe-task.json | jq ".taskDefinition.containerDefinitions")
echo "{\"containerDefinitions\":$CONTAINER_DEFS}" | cat>container-def.json
NEW_TASK_DEF_VERSION=$(aws ecs register-task-definition --family $task_def_family_name --cli-input-json file://container-def.json | jq ".taskDefinition.revision")
aws ecs update-service --cluster $cluster_name --service $service_name --task-definition "$task_def_family_name:$NEW_TASK_DEF_VERSION" --force-new-deployment