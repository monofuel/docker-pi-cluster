# TODO i'm sure more of these could be written as playbooks

.PHONY: setup-docker
setup-docker:
	cp ~/.ssh/id_rsa.pub docker/
	cp ~/.ssh/id_rsa.pub docker/grafana-arm

	# run playbooks to setup cluster
	ansible-playbook all-playbooks/hosts.yml
	ansible-playbook cluster-playbooks/glusterfs.yml
	ansible-playbook cluster-playbooks/docker.yml


.PHONY: docker-build
docker-build: docker-influx docker-grafana

.PHONY: docker-deploy
docker-deploy:
	docker service create --name influxdb -v /mnt/gluster/home/influxdb/var/:/var/lib/influxdb/ --publish published=8086,target=8086 127.0.0.1:5000/mono-influxdb
	docker service create --name grafana  -v /mnt/gluster/home/grafana/etc/:/etc/grafana/ -v /mnt/gluster/home/grafana/var/:/var/lib/grafana/ --publish published=3000,target=3000 127.0.0.1:5000/mono-grafana

.PHONY:  docker-influx
docker-influx:
	docker build --build-arg playbook=influxdb -t mono-influxdb -t 127.0.0.1:5000/mono-influxdb .
	docker push 127.0.0.1:5000/mono-influxdb

.PHONY: docker-grafana
docker-grafana:
	docker build --build-arg playbook=grafana -t mono-grafana -t 127.0.0.1:5000/mono-grafana ./docker/grafana-arm
	docker push 127.0.0.1:5000/mono-grafana

.PHONY: registry
registry:
	docker service create --name registry --publish published=5000,target=5000 budry/registry-arm:latest

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
