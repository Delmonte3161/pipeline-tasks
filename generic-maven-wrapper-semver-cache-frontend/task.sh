#!/bin/bash
# This script assumes Maven Wrapper is used with Maven v3.5.0 or higher.
#   see: https://maven.apache.org/maven-ci-friendly.html
#
# All UPPERCASE variables are provided externally from this script

set -o errexit
set -o nounset
set -o pipefail

[ 'true' = "${DEBUG:-}" ] && set -o xtrace

version=$(cat version/"$VERSION_FILE")

cd project

args="-Drevision=$version"
[ -n "$MAVEN_PROJECTS" ] && args="$args --projects $MAVEN_PROJECTS"
[ -n "$MAVEN_REPO_MIRROR" ] && args="$args -Drepository.url=$MAVEN_REPO_MIRROR";
[ -n "$MAVEN_REPO_USERNAME" ] && args="$args -Drepository.username=$MAVEN_REPO_USERNAME";
[ -n "$MAVEN_REPO_PASSWORD" ] && args="$args -Drepository.password=$MAVEN_REPO_PASSWORD";
[ "true" = "$MAVEN_REPO_CACHE_ENABLE" ] && args="$args -Dmaven.repo.local=$PWD/.m2repository";

./mvnw $CMD $args

cd ..

cp -R project/* task-output/.