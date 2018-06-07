# Ansible Playbook Collection

The goal is to have a set of playbooks that can apply to x86_64 or armhf hosts that can
use either docker or libvirt to provide hosts that are provisioned with ansible.

## playbooks

cluster-playbooks are for setting up the pi cluster itself. containers or VMs are defined with roles

## options
- deploy with vagrant
  - should support different providers: docker, libvirt, virtualbox
- create docker images
  - create a docker image and run playbook inside container
  - images can then be deployed to a docker swarm

## Useful Links
- https://medium.com/@petey5000/monitoring-your-home-network-with-influxdb-on-raspberry-pi-with-docker-78a23559ffea
- http://jinja.pocoo.org/docs/2.10/templates/
- https://medium.com/snips-ai/build-a-weather-assistant-with-snips-4253541f1684
- https://snips.gitbook.io/documentation/advanced-configuration/wakeword/personal-wakeword

## TODO

- add vagrantfile to setup gitlab server
- add snips ai playbook
- get snips setup with bluetooth speaker?
