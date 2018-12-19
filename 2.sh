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
ansible-playbook main.yml
CNF=$(cat  /root/doublevpn/wg-client.conf);

MYIP=$(curl -4 https://icanhazip.com/);

echo "#####################################################################################################################"

cd /root
wget https://git.io/vpn -O openvpn-install.sh && bash openvpn-install.sh
rm -R /root/doublevpn &> /dev/null
rm -R /root/1.sh &> /dev/null
