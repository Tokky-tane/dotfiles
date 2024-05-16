#!/bin/bash

read -p 'desired-task-count?: ' desired_count

cluster=$(
  aws ecs list-clusters |
    jq -r '.clusterArns[]' |
    awk -F '/' '{ print $2 }' |
    fzf --select-1
)

aws ecs list-services --cluster $cluster |
  jq -r '.serviceArns[]' |
  fzf -m --select-1 | 
  xargs -n1 -I{} aws ecs update-service --cluster $cluster --service {} --desired-count "${desired_count}"
