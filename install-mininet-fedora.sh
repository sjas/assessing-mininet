#!/bin/bash

# sjas: cleanup bullshit, needed for testing purposes
sudo rm -rf mininet openflow openvswitch oftest pox oflops

# This script is intended to install Mininet into
# a brand-new Ubuntu virtual machine,
# to create a fully usable "tutorial" VM.
set -e
echo `whoami` ALL=NOPASSWD: ALL | sudo tee -a /etc/sudoers
sudo sed -i -e 's/Default/#Default/' /etc/sudoers
sudo sed -i -e 's/ubuntu/sjas-mininet-vm/' /etc/sysconfig/network
sudo sed -i -e 's/ubuntu/sjas-mininet-vm/g' /etc/hosts
sudo hostname `cat /etc/sysconfig/network | grep -i 'hostname' | sed -e 's/HOSTNAME//g' | sed -e 's/=//g'`
sudo sed -i -e 's/quiet/text/' /etc/default/grub
sudo grub2-mkconfig -o /etc/grub2.cfg
#sudo sed -i -e 's/us.archive.ubuntu.com/mirrors.kernel.org/' /etc/apt/sources.list
sudo yum -y update

# sjas: is this here still needed?
# Clean up vmware easy install junk if present
#if [ -e /etc/issue.backup ]; then
    #sudo mv /etc/issue.backup /etc/issue
#fi
#if [ -e /etc/rc.local.backup ]; then
    #sudo mv /etc/rc.local.backup /etc/rc.local
#fi

# Install Mininet
sudo yum -y install git openssh-server
git clone git://github.com/sjas/mininet
cd mininet
cd
time mininet/util/installfedora.sh
# sjas: lets give nox a shot
# Ignoring this since NOX classic is deprecated
if ! grep NOX_CORE_DIR .bashrc; then
  echo "export NOX_CORE_DIR=~/noxcore/build/src/" >> .bashrc
fi
echo <<EOF
sjas: THIS IS ONLY NEEDED ON DEBIAN INSTALLS! NO NEED ON FEDORA...

You may need to reboot and then:
sudo dpkg-reconfigure openvswitch-datapath-dkms
sudo service openvswitch-switch start
EOF


