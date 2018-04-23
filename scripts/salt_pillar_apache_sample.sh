#!/bin/sh

# Author: Pekka Helenius (~Fincer), 2018
#
# - This script creates two different apache configurations for two minions: minion_1 & minion_2
# - This script is meant to be run on Salt master
#
# Default site contents for all minions is: Nothing interesting here
# minion_2 gets contents of 'uname -a' command into the index.html page
#

if [ $(id -u) -eq 0 ]; then

  mkdir -p /srv/{pillar,salt/apache}

if [ ! -f /srv/pillar/top.sls ]; then
tee /srv/pillar/top.sls <<PILLAR_TOP
base:
PILLAR_TOP
fi

if [ $(grep "\- apache" /srv/pillar/top.sls | wc -l) -eq 0 ]; then
tee -a /srv/pillar/top.sls <<PILLAR_TOP_ADD
  '*':
    - apache_site_data
PILLAR_TOP_ADD
fi

tee /srv/pillar/apache_site_data.sls <<SITE_DATA
{% if grains['id'] == 'minion_2' %}
site_data: '{{ salt['cmd.run']('uname -a') }}'
{% endif %}
SITE_DATA

tee /srv/salt/apache/samplesite.conf <<SAMPLE_SITE
<VirtualHost *:80>
    ServerName {{ servername }}
    ServerAlias {{ serveralias }}
    ServerAdmin webmaster@localhost
    DocumentRoot {{ ('/var/www/html/' + grains['id'] + '/') }}
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
SAMPLE_SITE

tee /srv/salt/apache/sampleindex.html <<SAMPLE_HTML
{{ pillar.get('site_data','Nothing interesting here') }}
SAMPLE_HTML

tee /srv/salt/apache/init.sls <<APACHE_DATA

{% set servername = grains['os'].lower() + '.' + grains['id'] + '.com' %}
{% set serveralias = 'www.' + grains['os'].lower() + '.' + grains['id'] + '.com' %}

apache_install:
  pkg.installed:
    - pkgs:
      - apache2
      - curl

sample_page_conf:
  file.managed:
    - name: /etc/apache2/sites-available/{{ grains['id'] }}.conf
    - source: salt://apache/samplesite.conf
    - mode: 0644
    - user: root
    - group: root
    - template: jinja
    - context:
      servername: {{ servername }}
      serveralias: {{ serveralias }}
    - require:
      - pkg: apache_install

enable_sample_page:
  cmd.run:
    - name: 'a2ensite {{ grains['id'] }}.conf'
    - require:
      - file: sample_page_conf
      
sample_page_content:
  file.managed:
    - mode: 0644
    - user: root
    - group: root
    - makedirs: True
    - template: jinja
    - name: {{ ('/var/www/html/' + grains['id'] + '/index.html') }}
    - source: salt://apache/sampleindex.html
    - require:
      - cmd: enable_sample_page

add_vhost_domain:
  file.append:
    - name: /etc/hosts
    - text: 127.0.0.1 {{ servername }}
    - require:
      - file: sample_page_content
      
restart_httpd:
  service.running:
    - name: apache2.service
    - watch:
      - file: add_vhost_domain
      - cmd: enable_sample_page

test_page:
  cmd.run:
    - name: 'curl -s {{ servername }}'
    - require:
      - service: restart_httpd

APACHE_DATA

    if [ ! -f /srv/pillar/apache_site_data.sls ] || \
    [ ! -f /srv/salt/apache/init.sls ] || \
    [ ! -f /srv/pillar/top.sls ] || \
    [ ! -f /srv/salt/apache/samplesite.conf ] || \
    [ ! -f /srv/salt/apache/sampleindex.html ]; then
        echo "Salt files missing. Aborting."
        exit 1
    else
        echo -e "\e[1m\n**Salt -- pillar.items output**\n\e[0m"
        salt '*' pillar.items
        echo -e "\e[1m\n**Salt -- state.apply output**\n\e[0m"
        salt '*' state.apply apache
    fi
else
    echo "Run this script as root (or with sudo)"
fi
