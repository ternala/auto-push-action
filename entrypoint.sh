#!/bin/sh -l

set -e  # if a command fails it stops the execution
set -u  # script fails if trying to access to an undefined variable

echo "Starts"
SOURCE_GITHUB_USERNAME="$1"
SOURCE_REPOSITORY_NAME="$2"
SOURCE_BRANCH_NAME="$3"
DESTINATION_GITHUB_USERNAME="$4"
DESTINATION_REPOSITORY_NAME="$5"
DESTINATION_BRANCH_NAME="$6"
USER_EMAIL="$7"
USER_NAME="$8"
COMMIT_MESSAGE="$9"

echo "Cloning destination git repository"
# Setup git
git config --global user.email $USER_EMAIL
git config --global user.name $USER_NAME


echo "Cloning source repository"
SOURCE_CLONE_DIR=$(mktemp -d)
git clone --single-branch --branch $SOURCE_BRANCH_NAME "https://$API_TOKEN_GITHUB@github.com/$SOURCE_GITHUB_USERNAME/$SOURCE_REPOSITORY_NAME.git" "$SOURCE_CLONE_DIR"
ls -la "$SOURCE_CLONE_DIR"

cd "$SOURCE_CLONE_DIR"

git remote add server "https://$API_TOKEN_GITHUB@github.com/$DESTINATION_GITHUB_USERNAME/$DESTINATION_REPOSITORY_NAME.git"

echo "Files that will be pushed"
ls -la

echo "Adding git commit"
git add .
git status

ORIGIN_COMMIT="https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"
COMMIT_MESSAGE="${COMMIT_MESSAGE/ORIGIN_COMMIT/$ORIGIN_COMMIT}"

git diff-index --quiet HEAD || git commit --message "$COMMIT_MESSAGE"

git push -f server "$DESTINATION_BRANCH_NAME"