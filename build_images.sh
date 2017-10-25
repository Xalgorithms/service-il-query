ENVIRONMENT="development"
if [[ -n "$TRAVIS_BRANCH" && "$TRAVIS_BRANCH" == "production" ]]; then
   ENVIRONMENT=$TRAVIS_BRANCH
fi

VERSION=`cat .version`

docker build -t "xalgorithms/xadf-query-service:latest-$ENVIRONMENT" -t "xalgorithms/xadf-query-service:$VERSION-$ENVIRONMENT" -f "Dockerfile.$ENVIRONMENT" .
docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
docker push "xalgorithms/xadf-query-service:latest-$ENVIRONMENT"
docker push "xalgorithms/xadf-query-service:$VERSION-$ENVIRONMENT"
