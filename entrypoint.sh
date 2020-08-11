#!/usr/bin/env bash
set -e

INPUT_TAG=${INPUT_PUSH_TAG:-${GITHUB_SHA}}
INPUT_DOCKERFILE=${INPUT_DOCKERFILE:-Dockerfile}

if [ -z "${INPUT_GITHUB_ACCESS_TOKEN}" ]
then
  GITHUB_URL=https://github.com
else
  GITHUB_URL=https://${INPUT_GITHUB_ACCESS_TOKEN}@github.com
fi

if [ -z "${INPUT_UPDATE_LATEST}" || "${INPUT_TAG}" == "latest" ]
then
  BUILD_FILE=/build.yaml
else
  BUILD_FILE=/build_latest.yaml
fi

az login --service-principal -u ${INPUT_SERVICE_PRINCIPAL} -p ${INPUT_SERVICE_PRINCIPAL_PASSWORD} --tenant ${INPUT_TENANT}

az acr run -f ${BUILD_FILE} \
  -r ${INPUT_REGISTRY} \
  --set BUILD_IMAGE=${INPUT_IMAGE} \
  --set BUILD_TAG=${INPUT_TAG} \
  --set BUILD_DOCKERFILE=${INPUT_DOCKERFILE} \
  --set BUILD_CONTEXT=${GITHUB_URL}/${GITHUB_REPOSITORY}.git#${INPUT_BRANCH}:${INPUT_BUILD_CONTEXT} \
  /dev/null
