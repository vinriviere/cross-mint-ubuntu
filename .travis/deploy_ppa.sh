#!/bin/bash -eu
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.

if [ $# != 3 ]
then
  echo "usage: $0 <package> <suffix> <distribution>" >&2
  exit 1
fi

PACKAGE=$1
SUFFIX=$2
DIST=$3

if [ -z ${DPUT_PROFILE+x} ]
then
  echo "$0: error: DPUT_PROFILE variable must be set." >&2
  echo "$0: Be sure to run \". .travis/init_ppa.sh ...\" before this script." >&2
  exit 1
fi

echo "# Deploying $PACKAGE for $DIST to $PPA"

cd $PACKAGE

# Update the changelog with new version
OLD_VERSION=$(dpkg-parsechangelog -S Version)
NEW_VERSION=$OLD_VERSION$SUFFIX~$DIST
dch --force-distribution -D $DIST -v $NEW_VERSION "Create PPA source package for $DIST".

echo "\$ dpkg-parsechangelog"
dpkg-parsechangelog

# Build the source package
echo "\$ dpkg-buildpackage -S -d"
dpkg-buildpackage -S -d

cd ..
echo "\$ ls -l"
ls -l

# Upload the source package
echo "\$ dput -d -d $DPUT_PROFILE ${PACKAGE}_${NEW_VERSION}_source.changes"
dput -d -d $DPUT_PROFILE ${PACKAGE}_${NEW_VERSION}_source.changes

# Delete uploaded packages
echo "\$ rm ${PACKAGE}_$NEW_VERSION*"
rm  ${PACKAGE}_$NEW_VERSION*

# Cancel temporary changes made in changelog
echo "\$ git reset --hard"
git reset --hard
