sudo systemctl stop ufw
sudo systemctl disable ufw
touch /etc/iptables_rules.ipv4
echo "*filter
:INPUT ACCEPT [90:8713]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [54:7429]
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
COMMIT
*nat
:PREROUTING ACCEPT [1:44]
:INPUT ACCEPT [1:44]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING ! -d 192.168.0.0/16 -o eth0 -j MASQUERADE
COMMIT" >> /etc/iptables_rules.ipv4
touch /etc/network/if-pre-up.d/iptables
echo "#!/bin/sh
/sbin/iptables-restore < /etc/iptables_rules.ipv4" >> /etc/network/if-pre-up.d/iptables
sudo chmod +x /etc/network/if-pre-up.d/iptables
echo "net.ipv4.conf.all.forwarding = 1" >> /etc/sysctl.conf
sysctl -p
sudo chmod 700 /etc/netplan/00-installer-config.yaml
sudo chmod 700 /etc/netplan/50-vagrant.yaml
sudo chmod 700 /etc/netplan/01-netcfg.yaml
sudo apt-get install openvswitch-switch-dpdk -y
touch inetRouter.txt
echo "#
      routes:
      - to: 192.168.255.0/24
        via: 192.168.255.2
      - to: 192.168.0.0/24
        via: 192.168.255.2
      - to: 192.168.1.0/24
        via: 192.168.255.2
      - to: 192.168.2.0/24      
        via: 192.168.255.2" >> inetRouter.txt
sudo sed -i '/192.168.255.1/r inetRouter.txt' /etc/netplan/50-vagrant.yaml
sudo systemctl daemon-reload
sudo netplan apply
sudo reboot

