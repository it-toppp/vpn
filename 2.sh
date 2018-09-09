#SELINUX
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config || true
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux || true
sudo setenforce 0

#docker
curl -fsSL https://get.docker.com/ | sh
systemctl start docker
systemctl enable docker

sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Enable Firewall
firewall-cmd --permanent --add-port={80,443}/tcp
firewall-cmd --permanent--add-port={1194,1195}/udp
firewall-cmd --reload
pritunl setup-key

mkdir -p /var/lib/openvpn/mongodb
docker run \
    --name openvpn \
    --privileged \
    --detach \
    --privileged \
    --network=host \
    --restart=always \
    -p 1194:1194/udp \
    -p 1194:1194/tcp \
    -p 80:80/tcp \
    -p 443:443/tcp \
    -v /var/lib/openvpn/mongodb:/var/lib/mongodb\
    jippi/pritunl
    
