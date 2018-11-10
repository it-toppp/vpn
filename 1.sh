#!/bin/bash

###################
rm -R /root/doublevpn &> /dev/null
rm -R /root/1.sh &> /dev/null
###################
# Install ansible #
if ! grep -q "ansible/ansible" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding Ansible PPA"
    apt-add-repository ppa:ansible/ansible -y
fi

if ! hash ansible >/dev/null 2>&1; then
    echo "Installing Ansible..."
    apt-get update
    apt-get install software-properties-common ansible git python-apt -y
else
    echo "Ansible already installed"
fi

git clone https://github.com/it-toppp/doublevpn.git && cd /root/doublevpn/

ansible-playbook gen_conf.yml
echo "Please wait..."
ansible-playbook main.yml &> /dev/null
CNF=$(cat  /root/doublevpn/wg-client.conf);

MYIP=$(curl -4 https://icanhazip.com/);

#SELINUX
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config || true
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux || true
sudo setenforce 0

#docker
curl -fsSL https://get.docker.com/ | sh
sudo systemctl start docker
sudo systemctl enable docker

#sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#sudo chmod +x /usr/local/bin/docker-compose

sudo mkdir -p /var/lib/openvpn/mongodb
sudo docker rm -f openvpn &> /dev/null
sudo docker run \
    --name openvpn \
    --privileged \
    --detach \
    --privileged \
    --restart=always \
    --net=host \
    -v /var/lib/openvpn/mongodb:/var/lib/mongodb\
    -v /var/lib/openvpn:/var/lib/pritunl \
      jippi/pritunl

echo "#####################################################################################################################"

echo "open in web browser    :  https://$MYIP"
echo "Enter login/password   :  pritunl/pritunl"

#docker exec -it openvpn /bin/bash | pritunl reset-password
rm -R /root/doublevpn &> /dev/null
rm -R /root/1.sh &> /dev/null
