#!/bin/bash

cd /tmp || exit

chmod 0600 ~ubuntu/.ssh/id_rsa

sudo apt update && sudo apt install -y ansible

APACHE_IP=$(cat /tmp/apache.txt)
HAPROXY_IP=$(cat /tmp/haproxy.txt)

# build ansible hosts here:
#sed -r -i "s/APACHE_IP/${APACHE_IP}/g"   hosts.yaml
#sed -r -i "s/HAPROXY_IP/${HAPROXY_IP}/g" hosts.yaml

# reachability test
ansible -m ping -i hosts.yaml apache_hosts
ansible -m ping -i hosts.yaml haproxy_hosts

# run ansible playbook for apache:
ansible-playbook -i hosts.yaml apache.yaml apache_hosts
# run haproxy playbook for haproxy:
ansible-playbook -i hosts.yaml haproxy.yaml haproxy_hosts

# done
