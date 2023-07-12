#!/bin/bash

metadata_url="http://169.254.169.254/latest/meta-data/"

cloud_metadata() {
  local metadata=$(curl -s "$metadata_url")
  local json="{"

  while IFS='=' read -r key value; do
    local trimmed_key="${key%%[[:space:]]}"
    local trimmed_value="${value%%[[:space:]]}"
    json+="\"$trimmed_key\": \"$trimmed_value\","
  done <<< "$metadata"

  json="${json%,}"
  json+="}"

  echo "$json"
}

instance_metadata=$(cloud_metadata)
echo "$instance_metadata"

