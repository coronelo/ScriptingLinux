# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
  version: 2
  renderer: networkd
  ethernets:
#    enp0s3:
    nombreint:
      addresses: [IP/24]
#     dhcp4: true
#     addresses: [192.168.1.222/24]
#     gateway4: 192.168.1.1
#     nameservers:
#       addresses: [8.8.8.8,8.8.4.4]