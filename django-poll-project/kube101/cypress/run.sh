#!/bin/bash

if [[ "$#" -ne 2 ]]; then
    echo "Usage: run.sh base_url spec"
    exit -1
fi

echo "base_url=$1"
echo "spec=$2"

export CYPRESS_BASE_URL="$1"

# see https://docs.cypress.io/guides/guides/command-line.html#cypress-run-record-key-lt-record-key-gt
# If you set the Record Key as the environment variable CYPRESS_RECORD_KEY, you can omit the --key flag.
# You’d typically set this environment variable when running in Continuous Integration.
if [[ -z "${CYPRESS_RECORD_KEY}" ]]; then
  npx cypress run --spec ${2}
else
  npx cypress run --spec ${2} --record
fi
