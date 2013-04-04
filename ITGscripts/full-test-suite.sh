#!/bin/bash
#
# TEST SUITE SCRIPT
#
# NEEDS: sudo apt-get install sshpass -y
#
# ssh's automatically into each machine, starting everything.
# how or if this terminates, only god will ever know.
#
###########################################################################
#currently unneeded:
##ip section
#cl1="10.0.0.1"
#cl2="10.0.0.2"
#log="10.0.0.3"
#srv1="10.0.0.4"
#srv2="10.0.0.5"
rate1="25"
rate2="50"
rate3="75"
rate4="100"
rate5="125"
rate6="150"

echo '***** log server'
bash -i -l -c 'sshpass -p mininet \
ssh -oStrictHostKeyChecking=no mininet@10.0.0.3 "sudo D-ITG/D-ITG-2.8.0-rc1/bin/ITGLog 0>/dev/null" &'

echo '***** client 1'
bash -i -l -c 'sshpass -p mininet \
ssh -oStrictHostKeyChecking=no mininet@10.0.0.1 "sudo D-ITG/D-ITG-2.8.0-rc1/bin/ITGRecv 0>/dev/null" &'
echo '***** client 2'
bash -i -l -c 'sshpass -p mininet \
ssh -oStrictHostKeyChecking=no mininet@10.0.0.2 "sudo D-ITG/D-ITG-2.8.0-rc1/bin/ITGRecv 0>/dev/null" &'

echo 'UDP TESTS'
echo '***** server 1'
bash -i -l -c 'sshpass -p mininet ssh -oStrictHostKeyChecking=no mininet@10.0.0.4 "sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3 $rate6 20000 0>/dev/null" &'
#echo '***** server 2'
#bash -i -l -c 'sshpass -p mininet 
#ssh -oStrictHostKeyChecking=no mininet@10.0.0.5 "
#sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3 $rate1 10000 0>/dev/null && 
#sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3 $rate2 10000 0>/dev/null && 
#sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3 $rate3 10000 0>/dev/null && 
#sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3 $rate4 10000 0>/dev/null 
#" &'

#echo 'TCP TESTS'
#echo 'server 1'
#bash -i -l -c 'sshpass -p mininet \
#ssh -oStrictHostKeyChecking=no mininet@10.0.0.4 "sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3 tcp1_25cbr 25 0>/dev/null" &'
#echo 'server 2'
#bash -i -l -c 'sshpass -p mininet \
#ssh -oStrictHostKeyChecking=no mininet@10.0.0.5 "sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3 tcp2_25cbr 25 0>/dev/null" &'
