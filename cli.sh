#!/bin/bash

# check if the the user has sed command
if ! command -v sed >/dev/null 2>&1; then
  echo "sed command not found"
  exit 1
fi

# if $2 is passed set PACKAGE_JSON to $2 otherwise set to package.json in current directory
if [ -z "$2" ]; then
  PACKAGE_JSON="package.json"
else
  PACKAGE_JSON="$2"
fi

# check if PACKAGE_JSON file exists
if [ ! -f $PACKAGE_JSON ]; then
  echo "'$PACKAGE_JSON' file not found"
  exit 1
fi

# check if $1 is passed
if [ -z "$1" ]; then
  echo "Please you must epecify the version. Run with --help."
  exit 1
fi

# Display help
function help() {
  echo ""
  echo "Usage: cpv [version] [optional: path to package.json]"
  echo ""
  echo "  -h, --help       Display this help message"
  echo "  -v, --version    Display the version"
  echo ""
  echo "Examples:"
  echo "  cpv 1.0.0"
  echo "  cpv 1.2.0 path/to/package.json"
  echo ""
  exit 0
}

# Print version from package.json without using jq
function version() {
  cat package.json | sed -n 's/^.*"version": "\(.*\)".*$/\1/p'
  exit 0
}

# Validate version
# TODO: allow versions like 1.2.3-beta.1
function validate_version() {
  if [[ ! $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid version format"
    exit 1
  fi
}

# change package.json version
function change_version() {
  if ! sed -i '' "s/\"version\": \"\(.*\)\"/\"version\": \"$1\"/g" $PACKAGE_JSON 2>/dev/null; then
    echo "Failed to change version"
    exit 1
  fi
}

case $1 in
-h | --help)
  help
  ;;
-v | --version)
  version
  ;;
*)
  validate_version $1
  change_version $1
  ;;
esac
