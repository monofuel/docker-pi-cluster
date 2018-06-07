# TODO i'm sure more of these could be written as playbooks

.PHONY: setup-docker
setup-docker:
	cp ~/.ssh/id_rsa.pub docker/
	cp ~/.ssh/id_rsa.pub docker/grafana-arm

	# run playbooks to setup cluster
	ansible-playbook all-playbooks/hosts.yml
	ansible-playbook cluster-playbooks/glusterfs.yml
	ansible-playbook cluster-playbooks/docker.yml

.PHONY: docker-pull
docker-pull:
	docker pull 127.0.0.1:5000/mono-influxdb

.PHONY: docker-build
docker-build: docker-influx docker-grafana

.PHONY: docker-deploy
docker-deploy:
	docker service rm influxdb
	docker service create --name influxdb --mount type=bind,src=/mnt/gluster/home/influxdb/var/,dst=/var/lib/influxdb/ --publish published=8086,target=8086 127.0.0.1:5000/mono-influxdb:2
	docker service create --name grafana  --mount type=bind,src=/mnt/gluster/home/grafana/var/,dst=/var/lib/grafana/ --mount type=bind,src=/mnt/gluster/home/grafana/etc/,dst=/etc/grafana --publish published=3000,target=3000 127.0.0.1:5000/mono-grafana
	# docker service create --name snips --privileged --network host 127.0.0.1:5000/mono-snips

.PHONY:  docker-influx
docker-influx:
	docker build --build-arg playbook=influxdb -t mono-influxdb -t 127.0.0.1:5000/mono-influxdb:2 .
	docker push 127.0.0.1:5000/mono-influxdb:2

.PHONY:  docker-snips
docker-snips:
	docker build --build-arg playbook=snips -t mono-snips -t 127.0.0.1:5000/mono-snips .
	docker push 127.0.0.1:5000/mono-snips

.PHONY: docker-grafana
docker-grafana:
	docker build --build-arg playbook=grafana -t mono-grafana -t 127.0.0.1:5000/mono-grafana ./docker/grafana-arm
	docker push 127.0.0.1:5000/mono-grafana

.PHONY: registry
registry:
	docker service create --name registry --mount type=bind,src=/mnt/gluster/home/registry/var,dst=/var/lib/registry --publish published=5000,target=5000 budry/registry-arm:latest

.PHONY: setup-vagrant
setup-vagrant:
	echo ---
	echo Make sure you have vagrant set to use the provider you want
	echo VAGRANT_DEFAULT_PROVIDER=${VAGRANT_DEFAULT_PROVIDER}
	echo ---
	sleep 5s
	cd vagrant/monitoring && vagrant up
	cd vagrant/homeAutomation && vagrant up

.PHONY: check
check:
	ansible-playbook --syntax-check cluster-playbooks/*.yaml
