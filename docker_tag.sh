#!/bin/bash
semver_file_name=$1
release_version=v`cat $semver_file_name | grep '^\s*\"*version' | grep -oE "\d*\.\d*\.\d*"`
if [[ "$CI_COMMIT_BRANCH" != 'main' && "$CI_COMMIT_BRANCH" != 'master' ]]; then release_version="$release_version-$CI_COMMIT_BRANCH"; fi;
echo "$release_version"