#!/bin/bash -eu
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.

if [ $# != 1 ]
then
  echo "usage: $0 <suffix>" >&2
  exit 1
fi

PACKAGES_SUFFIX=$1

git fetch --unshallow origin $COMMIT_BEFORE $COMMIT_AFTER
COMMIT_RANGE=$COMMIT_BEFORE..$COMMIT_AFTER
MODIFIED_PACKAGES=$(git log $COMMIT_RANGE --name-status | sed -n "s,^[AM]\t\(\(.*-m68k-atari-mint\|cross-mint-essential\)\)/.*,\1,p" | sort | uniq)
echo "MODIFIED_PACKAGES=$MODIFIED_PACKAGES"

for PACKAGE in $MODIFIED_PACKAGES
do
  .github/deploy_ppa_all_dists.sh $PACKAGE
done
