#!/bin/bash
semver_file_name=$1
release_version=v`cat $semver_file_name | grep '^\s*\"*version' | grep -oE "\d*\.\d*\.\d*"`
if [[ "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" != 'main' && "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" != 'master' ]]; then release_version="$release_version-$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"; fi;
echo "$release_version"