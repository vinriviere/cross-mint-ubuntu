#!/bin/bash -eu
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.

if [ $# != 3 ]
then
  echo "usage: $0 <package> <distribution> <ppa>" >&2
  exit 1
fi

PACKAGE=$1
DIST=$2
PPA=$3

echo "# Deploying $PACKAGE for $DIST to $PPA"

cd $PACKAGE

# Update the changelog with new version
OLD_VERSION=$(dpkg-parsechangelog | sed -n 's/^Version: *//p')
NEW_VERSION=${OLD_VERSION}ppa$(date -u +%Y%m%d%H%M%S)~$DIST
dch --force-distribution -D $DIST -v $NEW_VERSION "Create PPA source package for $DIST".

echo "\$ dpkg-parsechangelog"
dpkg-parsechangelog

# Build the source package
echo "\$ dpkg-buildpackage -S"
dpkg-buildpackage -S

cd ..
echo "\$ ls -l"
ls -l

# Upload the source package
echo "\$ dput -f $PPA ${PACKAGE}_${NEW_VERSION}_source.changes"
dput -f $PPA ${PACKAGE}_${NEW_VERSION}_source.changes | cat

# Delete uploaded packages
echo "\$ rm ${PACKAGE}_$NEW_VERSION*"
rm  ${PACKAGE}_$NEW_VERSION*

# Cancel temporary changes made in changelog
echo "\$ git reset --hard"
git reset --hard
