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


# first clean up all old binary logs
rm -rf log_*

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
#bash -i -l -c 'sshpass -p mininet ssh -oStrictHostKeyChecking=no mininet@10.0.0.4 "sudo ~/ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3 150 20000 0>/dev/null" &'
bash -i -l -c 'sshpass -p mininet \
ssh -oStrictHostKeyChecking=no mininet@10.0.0.5 "\
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    8000 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    8100 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    8200 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    8300 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    8400 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    8500 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    8600 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    8700 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    8800 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    8900 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    9000 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    9100 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    9200 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    9300 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    9400 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    9500 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    9600 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    9700 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    9800 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3    9900 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   10000 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   10100 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   10200 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   10300 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   10400 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   10500 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   10600 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   10700 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   10800 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   10900 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   11000 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   11100 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   11200 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   11300 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   11400 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   11500 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   11600 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   11700 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   11800 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   11900 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   12000 300000 0>/dev/null && \
\
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    8000 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    8100 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    8200 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    8300 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    8400 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    8500 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    8600 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    8700 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    8800 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    8900 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    9000 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    9100 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    9200 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    9300 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    9400 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    9500 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    9600 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    9700 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    9800 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3    9900 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   10000 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   10100 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   10200 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   10300 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   10400 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   10500 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   10600 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   10700 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   10800 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   10900 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   11000 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   11100 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   11200 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   11300 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   11400 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   11500 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   11600 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   11700 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   11800 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   11900 300000 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   12000 300000 0>/dev/null && \
\
date && echo ***** ... FINISHED"&'

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
