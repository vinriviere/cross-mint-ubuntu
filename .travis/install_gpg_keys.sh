#!/bin/bash -eu
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.

# This installs a GnuPG private/public key pair on the build system,
# so gpg can sign the source packages.

# Our private key is the critical security component, it must remain secret.
# We store it in the GPG_KEYS environment variable in Travis CI project settings.
# As environment variables can only contain text, our keys are transformed
# like this: xz, base64. Then they can be decoded here. This is safe as
# Travis CI never shows the contents of secure variables.

# To generate the contents of the GPG_KEYS variable:
# Be sure to rename your normal ~/.gnupg to something else, to start with a
# clean state.
#
# Generate a new key pair, with empty passphrase.
# gpg --gen-key
#
# Export the resulting privte/public key
# gpg --export-secret-key --armor | xz | base64 -w 0
#
# Select the resulting encoded text (several lines) to copy it to the clipboard.
# Then go to the Travis CI project settings:
# https://travis-ci.org/vinriviere/cross-mint-ubuntu/settings
# Create a new environment variable named GPG_KEYS, and paste the value.
# The script below will import the keys from that variable contents.

if [ -z ${GPG_KEYS+x} ]
then
  echo "error: GPG_KEYS is undefined" >&2
  exit 1
fi

echo $GPG_KEYS | base64 -d | unxz | gpg --import

# Ultimately trust our own public key
# This avoids warnings with dput
MY_PUBKEY_ID=$(gpg --list-secret-keys | sed -n 's|^sec *[^/]*/\([^ ]*\).*|\1|p')
MY_PUBKEY_FINGERPRINT=$(LANG= gpg --fingerprint $MY_PUBKEY_ID | sed -n 's/.*fingerprint = \(.*\)/\1/p' |sed 's/ //g')
echo $MY_PUBKEY_FINGERPRINT:6: | gpg --import-ownertrust

# Display our key details and trust level
echo quit | gpg --command-fd 0 --edit-key $MY_PUBKEY_ID
