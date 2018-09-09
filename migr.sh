
cd /var/lib/
tar -czvf /tmp/openvpn.tar.gz ./openvpn 
scp /tmp/openvpn.tar.gz remote_user@remote_host:/tmp
tar -xvzf openvpn.tar.gz -C /var/lib/openvpn
