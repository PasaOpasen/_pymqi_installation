#!/bin/bash
#
# installs pymqi python package and system deps for it
# 
# Notes:
#   run this script from its parent dir with already activated python venv
#

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

whl="$(find * -name 'pymqi-*.whl')"
echo "installing $whl"
pip install $whl

