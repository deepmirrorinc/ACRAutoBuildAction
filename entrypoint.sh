#!/usr/bin/env bash
set -e

INPUT_PUSH_TAG=${INPUT_PUSH_TAG:-${GITHUB_SHA}}
INPUT_DOCKERFILE=${INPUT_DOCKERFILE:-Dockerfile}

if [ -z "${INPUT_GITHUB_ACCESS_TOKEN}" ]
then
  GITHUB_URL=https://github.com
else
  GITHUB_URL=https://${INPUT_GITHUB_ACCESS_TOKEN}@github.com
fi

az login --service-principal -u ${INPUT_SERVICE_PRINCIPAL} -p ${INPUT_SERVICE_PRINCIPAL_PASSWORD} --tenant ${INPUT_TENANT}

az acr run -f build.yaml \
  -r ${INPUT_BUILDX_REGISTRY} \
  --set BUILD_TARGET=${INPUT_PUSH_TARGET}:${INPUT_PUSH_TAG} \
  --set BUILD_DOCKERFILE=${INPUT_DOCKERFILE} \
  --set BUILDX_ARGS="" \
  --set BUILD_CONTEXT=${GITHUB_URL}/${GITHUB_REPOSITORY}.git#${INPUT_BRANCH}:${INPUT_BUILD_CONTEXT} \
  /dev/null
