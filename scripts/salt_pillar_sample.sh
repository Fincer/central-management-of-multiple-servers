#!/bin/sh

# Author: Pekka Helenius (~Fincer), 2018
#
# - This script creates two different text strings for two minions: minion_1 & minion_2
# - This script is meant to be run on Salt master
#
# - This script creates the following files on master:
# /srv/pillar/top.sls
# /srv/pillar/minion-1.sls
# /srv/pillar/minion-2.sls
# /srv/salt/files/pillarfile
# /srv/salt/myfirstpillar.sls

if [ $(id -u) -eq 0 ]; then
    mkdir -p /srv/pillar
    
tee /srv/pillar/top.sls <<PILLAR_TOP
base:
  'minion_1':
    - minion-1
  'minion_2':
    - minion-2
PILLAR_TOP

tee /srv/pillar/minion-1.sls <<MINION_1_DATA
test_variable: 'secret like coffee shop wants to say hello to the world'
MINION_1_DATA

tee /srv/pillar/minion-2.sls <<MINION_2_DATA
test_variable: 'hidden miniart: superman vs. hulk figures'
MINION_2_DATA

    mkdir -p /srv/salt/files
    
tee /srv/salt/files/pillarfile << PILLARFILE_CONTENT
This is my pillarfile which has the following content:

{{ pillar['test_variable'] }}
PILLARFILE_CONTENT

tee /srv/salt/myfirstpillar.sls <<GENERIC_PILLAR
pillar_file:
  file.managed:
    - user: 1000
    - group: 1000
    - name: /tmp/pillarfile_for_{{ grains['id'] }}
    - source: salt://files/pillarfile
    - makedirs: True
    - template: jinja

GENERIC_PILLAR

    if [ ! -f /srv/salt/myfirstpillar.sls ] || \
    [ ! -f /srv/salt/files/pillarfile ] || \
    [ ! -f /srv/pillar/top.sls ]; then
        echo "Salt files missing. Aborting."
        exit 1
    else
        salt 'minion_*' test.ping
        if [ $? -eq 0 ]; then
            echo -e "\e[1m\n**Salt -- pillar.items output**\n\e[0m"
            salt 'minion_*' pillar.items
            echo -e "\e[1m\n**Salt -- saltutil.refresh_pillar output**\n\e[0m"
            salt 'minion_*' saltutil.refresh_pillar
            echo -e "\e[1m\n**Salt -- state.apply output**\n\e[0m"
            salt 'minion_*' state.apply myfirstpillar
            echo -e "\e[1m\n**Salt -- get file output with head command**\n\e[0m"
            salt 'minion_*' cmd.run 'head /tmp/pillarfile_for*'
        fi

    fi

else
    echo "Run this script as root (or with sudo)"
fi
