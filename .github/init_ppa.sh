# This script fragment must be sourced by the main script file
# in order to define the PPA_* and DPUT_* variables
# . .github/init_ppa.sh ppa:<user>/<ppa>

if [ $# != 1 ]
then
  echo "usage: $0 <ppa>" >&2
  exit 1
fi

export PPA=$1

PPA_HOST=ppa.launchpad.net
PPA_LOGIN=$(echo $PPA | sed 's|^[^:]*:\([^/]*\)/.*|\1|')
PPA_NAME=$(echo $PPA | sed 's|^[^:]*:[^/]*/\(.*\)|\1|')
PPA_URL=https://launchpad.net/~$PPA_LOGIN/+archive/ubuntu/$PPA_NAME

echo "PPA=$PPA"
#echo "PPA_HOST=$PPA_HOST"
#echo "PPA_LOGIN=$PPA_LOGIN"
#echo "PPA_NAME=$PPA_NAME"
#echo "PPA_URL=$PPA_URL"


# Set up a dput configuration to enable SFTP

DPUT_CONFIG_FILE=~/.dput.cf
export DPUT_PROFILE=$(echo $PPA | sed 's/[^a-zA-Z]/_/g')

cat >$DPUT_CONFIG_FILE <<EOF
[$DPUT_PROFILE]
fqdn = $PPA_HOST
method = sftp
incoming = ~$PPA_LOGIN/ubuntu/$PPA_NAME/
login = $PPA_LOGIN
allow_unsigned_uploads = 0
EOF

echo
echo "# $DPUT_CONFIG_FILE"
cat $DPUT_CONFIG_FILE

# Avoid blocking message
# The authenticity of host ... can't be established.

KNOWN_HOSTS_FILE=~/.ssh/known_hosts

echo
ssh-keyscan $PPA_HOST >> $KNOWN_HOSTS_FILE

echo
echo "# $KNOWN_HOSTS_FILE"
cat $KNOWN_HOSTS_FILE
