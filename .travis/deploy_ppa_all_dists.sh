#!/bin/bash -eu
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.

if [ $# != 2 ]
then
  echo "usage: $0 <package> <ppa>" >&2
  exit 1
fi

PACKAGE=$1
PPA=$2

# List of all active Ubuntu distributions
DISTS=
DISTS+=" trusty"
DISTS+=" xenial"
DISTS+=" yakkety"
DISTS+=" zesty"

for DIST in $DISTS
do
  .travis/deploy_ppa.sh $PACKAGE $DIST $PPA
done