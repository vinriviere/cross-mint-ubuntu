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
  echo "$0: Be sure to run \". .github/init_ppa.sh ...\" before this script." >&2
  exit 1
fi

echo "# Deploying $PACKAGE for $DIST to $PPA"

cd $PACKAGE

# Update the changelog with new version
# Because each package in PPA must have a unique version
# and because PPA can't share source packages across distributions.
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
PACKAGE_PREFIX=${PACKAGE}_$(echo $NEW_VERSION | sed 's/^[^:]://')
CHANGES_FILE=${PACKAGE_PREFIX}_source.changes
echo "\$ cat $CHANGES_FILE"
cat $CHANGES_FILE
echo "\$ dput -d -d $DPUT_PROFILE $CHANGES_FILE"
dput -d -d $DPUT_PROFILE $CHANGES_FILE

# Delete uploaded packages
echo "\$ rm $PACKAGE_PREFIX*"
rm $PACKAGE_PREFIX*

# Cancel temporary changes made in changelog
echo "\$ git reset --hard"
git reset --hard
