setup:
	cp ~/.ssh/id_rsa.pub docker/
	cp ~/.ssh/id_rsa.pub docker/grafana-arm

check:
	ansible-playbook --syntax-check cluster-playbooks/*.yaml
