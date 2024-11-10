#!/bin/bash

chmod +x get_ips.sh

NAMESPACE="database"

echo "Fetching services from name space: $NAMESPACE..."

# shellcheck disable=SC1073
kubectl get svc -n $NAMESPACE -o jsonpath='{range .items[?(@.spec.type=="NodePort")]}{.metadata.name}{" "}{.spec.clusterIP}{" "}{.spec.ports[0].nodePort}{"\n"}{end}' | while read svc_name cluster_ip node_port
do
  # Check if external IP is <none> and set it to localhost if true
  if [ "$external_ip" == "<none>" ] || [ -z "$external_ip" ]; then
    external_ip="localhost"
  fi

  # Display service information
  echo "Service: $svc_name"
  echo "DNS Name (External IP): $external_ip"
  echo "NodePort: $node_port"
  echo "URL: http://$external_ip:$node_port"
  echo "-------------------------"
done