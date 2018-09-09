SSL_PORT=8081;
VPN_PORT=1194;
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

# Enable Firewall
sudo firewall-cmd --permanent --add-port={80,443,$SSL_PORT,8080}/tcp
sudo firewall-cmd --permanent --add-port=$VPN_PORT/udp
sudo firewall-cmd --reload

sudo mkdir -p /var/lib/openvpn/mongodb
sudo docker rm -f openvpn
sudo docker run \
    --name openvpn \
    --privileged \
    --detach \
    --privileged \
    --restart=always \
    -p 1194:1194/udp \
    -p 1194:1194/tcp \
    -p 8080:80/tcp \
    -p 8081:443/tcp \
    -v /var/lib/openvpn/mongodb:/var/lib/mongodb\
    -v /var/lib/openvpn:/var/lib/pritunl \
      jippi/pritunl

echo "open in web browser    :  https://$MYIP:$SSL_PORT"
echo "Enter login/password   :  pritunl/pritunl"
#docker exec -it openvpn /bin/bash | pritunl reset-password
    
