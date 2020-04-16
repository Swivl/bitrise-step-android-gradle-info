#!/bin/bash

# exit if a command fails
set -e

#
# Required parameters
if [[ -z "${gradle_file}" ]] ; then
  echo " [!] Missing required input: build.gradle file"
  exit 1
fi
if [[ ! -f "${gradle_file}" ]] ; then
  echo " [!] File doesn't exist at specified build.gradle file path: ${gradle_file}"
  exit 1
fi

# ---------------------
# --- Configs:

echo " (i) Provided build.gradle file path: ${gradle_file}"
echo

# ---------------------
# --- Main

VERSION_CODE=`grep versionCode ${gradle_file} | sed -e 's/[^.0-9]//g'`
VERSION_NAME=`grep versionName ${gradle_file} | head -n 1 | sed -e 's/[^.0-9]//g'`
APPLICATION_ID=`grep applicationId ${gradle_file} | head -n 1 | awk '{ print $2 }' | sed 's/"//g'`
MIN_SDK_VERSION=`grep minSdkVersion ${gradle_file} | sed -e 's/[^.0-9]//g'`
TARGET_SDK_VERSION=`grep targetSdkVersion ${gradle_file} | sed -e 's/[^.0-9]//g'`

if [[ -z "${VERSION_CODE}" ]] ; then
  echo " [!] Could not find version code!"
  exit 1
fi

envman add --key GRADLE_VERSION_CODE --value "${VERSION_CODE}"
echo " (i) Version Code: ${VERSION_CODE} -> Saved to \$GRADLE_VERSION_CODE environment variable."

if [[ -z "${VERSION_NAME}" ]] ; then
  echo " [!] Could not find version name!"
  exit 1
fi

envman add --key GRADLE_VERSION_NAME --value "${VERSION_NAME}"
echo " (i) Version Name: ${VERSION_NAME} -> Saved to \$GRADLE_VERSION_NAME environment variable."

if [[ -z "${APPLICATION_ID}" ]] ; then
  echo " [!] Could not find application id!"
  exit 1
fi

envman add --key GRADLE_APPLICATION_ID --value "${APPLICATION_ID}"
echo " (i) Application ID: ${APPLICATION_ID} -> Saved to \$GRADLE_APPLICATION_ID environment variable."

if [[ -z "${MIN_SDK_VERSION}" ]] ; then
  echo " No minimum SDK version found in build.gradle file"
else
  envman add --key GRADLE_MIN_SDK_VERSION --value "${MIN_SDK_VERSION}"
  echo " (i) Minimum SDK version: ${MIN_SDK_VERSION} -> Saved to \$GRADLE_MIN_SDK_VERSION environment variable."
fi

if [[ -z "${TARGET_SDK_VERSION}" ]] ; then
  echo " No target SDK version found in build.gradle file"
else
  envman add --key GRADLE_TARGET_SDK_VERSION --value "${TARGET_SDK_VERSION}"
  echo " (i) Target SDK version: ${TARGET_SDK_VERSION} -> Saved to \$GRADLE_TARGET_SDK_VERSION environment variable."
fi
