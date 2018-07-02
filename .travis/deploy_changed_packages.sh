#!/bin/bash -eu
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.

if [ $# != 1 ]
then
  echo "usage: $0 <suffix>" >&2
  exit 1
fi

PACKAGES_SUFFIX=$1

MODIFIED_PACKAGES=$(git log $FIXED_TRAVIS_COMMIT_RANGE --name-status | sed -n "s,^[AM]\t\(\(.*-m68k-atari-mint\|cross-mint-essential\)\)/.*,\1,p" | sort | uniq)
echo "MODIFIED_PACKAGES=$MODIFIED_PACKAGES"

for PACKAGE in $MODIFIED_PACKAGES
do
  .travis/deploy_ppa_all_dists.sh $PACKAGE
done
