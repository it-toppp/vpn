SSL_PORT=31337;
VPN_PORT=31337;
MYIP=$(curl -4 https://icanhazip.com/);

#SELINUX
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config || true
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux || true
sudo setenforce 0

#docker
curl -fsSL https://get.docker.com/ | sh
sudo systemctl start docker
sudo systemctl enable docker

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
    -p $VPN_PORT:$VPN_PORT/udp \
    -p 8080:80/tcp \
    -p $SSL_PORT:443/tcp \
    -v /var/lib/openvpn/mongodb:/var/lib/mongodb\
    -v /var/lib/openvpn:/var/lib/pritunl \
      jippi/pritunl

echo "open in web browser    :  https://$MYIP:$SSL_PORT"
echo "Enter login/password   :  pritunl/pritunl"
#docker exec -it openvpn /bin/bash | pritunl reset-password
