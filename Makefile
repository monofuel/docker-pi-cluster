
all: check setup-cluster stack-deploy

.PHONY: stack-deploy
stack-deploy:
	docker stack deploy  -c ./docker-compose.yml pi-services

.PHONY: setup-cluster
setup-cluster:
	ansible-playbook all-playbooks/hosts.yml
	ansible-playbook cluster-playbooks/glusterfs.yml
	ansible-playbook cluster-playbooks/docker.yml
	ansible-playbook all-playbooks/telegraf.yml

.PHONY: check
check:
	ansible-playbook --syntax-check $(wildcard all-playbooks/*.yml)
	ansible-playbook --syntax-check $(wildcard cluster-playbooks/*.yml)
