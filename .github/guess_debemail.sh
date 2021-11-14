# This script fragment must be sourced by the main script file
# in order to define the DEBEMAIL variable
# . .github/guess_debemail.sh

# Unset variables which might interfere
# https://manpages.debian.org/jessie/devscripts/debchange.1.fr.html#DESCRIPTION
unset DEBFULLNAME EMAIL

# Guess maintainer name and e-mail from GPG key
export DEBEMAIL=$(gpg --list-secret-keys | sed -n 's/^uid *//p' | sed 's/.*] *//')

echo "DEBEMAIL=$DEBEMAIL"
