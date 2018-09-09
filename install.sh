#selinux
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux || true
sudo setenforce 0

# Enable Firewall
firewall-cmd --permanent --add-port={80,443}/tcp
firewall-cmd --permanent--add-port={1194,1195}/udp
firewall-cmd --reload
pritunl setup-key

#prinunl
sudo tee -a /etc/yum.repos.d/mongodb-org-3.6.repo << EOF
[mongodb-org-3.6]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.6/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc
EOF

sudo tee -a /etc/yum.repos.d/pritunl.repo << EOF
[pritunl]
name=Pritunl Repository
baseurl=https://repo.pritunl.com/stable/yum/centos/7/
gpgcheck=1
enabled=1
EOF

sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A > key.tmp; sudo rpm --import key.tmp; rm -f key.tmp
sudo yum -y install pritunl mongodb-org
sudo systemctl start mongod pritunl
sudo systemctl enable mongod pritunl

echo "Pritunl    :  https://$MYIP"
echo "Please Copy Code Go To Installer"
pritunl setup-key

MYIP=$(curl -4 https://icanhazip.com/);
echo "Pritunl    :  https://$MYIP"
echo "Please Copy Code Go To Installer"
pritunl setup-key
