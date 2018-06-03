FROM arm32v7/debian:stretch
# FROM debian:stretch
# setup SSH and add our public key to the image

RUN apt-get update
RUN apt-get install -y build-essential libssl-dev libffi-dev openssh-server python make python-pip
RUN pip install ansible

RUN mkdir /root/.ssh && chmod 700 /root/.ssh
ADD docker/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 400 /root/.ssh/authorized_keys && chown root. /root/.ssh/authorized_keys

RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN mkdir /root/ansible
WORKDIR /root/ansible
ADD ansible.cfg .
ADD hosts.yml .
ADD roles .
ARG playbook=debian
RUN echo [${playbook}] > hosts
RUN echo localhost ansible_connection=local >> hosts
RUN mkdir log
RUN mkdir retry

RUN ansible-playbook hosts.yml

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]