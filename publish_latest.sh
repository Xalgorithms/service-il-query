#!/bin/bash
echo "publishing $1 as latest"
docker tag xalgorithms/service-il-query:$1 xalgorithms/service-il-query:latest-development
docker push xalgorithms/service-il-query:latest-development
