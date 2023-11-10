#!/bin/bash
#
# installs pymqi python package and system deps for it
# 
# Notes:
#   run this script from its parent dir with already activated python venv
#

set -e

d="$PWD"

echo 'license accepting...'
(
    cd MQServer/
    sudo ./mqlicense.sh -text_only -accept
)

echo 'repo initiation'
sudo bash -c "sed "s@REPODIRPLACEHOLDER@$d/MQServer@" $d/IBM-MQ.repo > /etc/yum.repos.d/IBM-MQ.repo"

echo 'installing MQ services'
sudo dnf install -y MQSeriesSDK MQSeriesClient

echo 'updating ldconfig'

sudo tee <<EOF /etc/ld.so.conf.d/mq.conf >/dev/null
/opt/mqm/lib64 
/opt/mqm/lib 
EOF


# need to exclude some libs cuz dnf can be broken after ldconfig them
t=/opt/mqm/lib64
sudo mv $t/libcurl.so /tmp
sudo ldconfig -v
sudo mv /tmp/libcurl.so $t


whl="$(find * -name 'pymqi-*.whl')"
echo "installing $whl"
pip install $whl

echo -n "testing pymqi works... "
python3 -c 'import pymqi; print("OK")'

