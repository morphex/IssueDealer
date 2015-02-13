#!/bin/bash

echo "Preparing Zope setup.."
echo
echo "Will now download and install SSL certificates"
echo "for wget so that bootstrap.py doesn't fail."
echo
echo "Will also create a wrapper for wget so that"
echo "it doesn't fail when SSL certificate common name"
echo "for pypi.python.org is www.python.org"
echo
echo "If you have a custom Python installation, add"
echo "the path to the bin directory as an argument"
echo "to this script, for example"
echo
echo "    ./bootstrap.sh /opt/python/bin"
echo
echo "Press enter to continue, Ctrl-C to quit"
echo
read input
# Used to download known certificates
wget --no-check-certificate -O - https://raw.githubusercontent.com/bagder/curl/master/lib/mk-ca-bundle.pl | perl -
mkdir -p ~/.ssl
mv ca-bundle.crt ~/.ssl
echo "ca_certificate = ~/.ssl/ca-bundle.crt" >> ~/.wgetrc
echo
cat <<EOF > wget
#!/bin/bash
/usr/bin/wget --no-check-certificate \$@
EOF
chmod +x wget
hash -r
declare -x PATH
if [ -n "$1" ]
then
  PATH=`pwd`:$1:$PATH
else
  PATH=`pwd`:$PATH
fi
echo "This script has now installed different SSL"
echo "certificates which will be used by wget also"
echo "in the future, and they are located in ~/.ssl"
echo
echo "Press enter to continue and run bootstrap.py, Ctrl-C to quit"
echo
read input
echo $PATH
python bootstrap.py #--allow-site-packages
