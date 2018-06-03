FROM fg2it/grafana-armhf:v5.1.3
# FROM debian:stretch
# setup SSH and add our public key to the image

USER root

RUN apt-get update
RUN apt-get install -y openssh-server
RUN mkdir /root/.ssh && chmod 700 /root/.ssh
ADD id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 400 /root/.ssh/authorized_keys && chown root. /root/.ssh/authorized_keys

RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# setup python for ansible
RUN apt-get install -y python

RUN apt-get install -y supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22

ENTRYPOINT ["/usr/bin/supervisord"]
