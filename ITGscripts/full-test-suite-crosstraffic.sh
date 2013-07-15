#!/bin/bash
#
# TEST SUITE SCRIPT, crosstraffic (srv1 -> cl1 && srv2 -> cl2)
#             cumulated throughputs equal the single test run
#
# NEEDS: sudo apt-get install sshpass -y
#
# ssh's automatically into each machine, starting everything.
# how or if this terminates, only god will ever know.
# I just resorted to restarting mininet after each test run,
# just to be on the safe side.
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

# now start the actual tests
##########################################################################################################################################
echo '***** log server'
bash -i -l -c 'sshpass -p mininet \
ssh -oStrictHostKeyChecking=no mininet@10.0.0.3 "sudo D-ITG/D-ITG-2.8.0-rc1/bin/ITGLog 0>/dev/null" &'
##########################################################################################################################################
echo '***** client 1'
bash -i -l -c 'sshpass -p mininet \
ssh -oStrictHostKeyChecking=no mininet@10.0.0.1 "sudo D-ITG/D-ITG-2.8.0-rc1/bin/ITGRecv 0>/dev/null" &'
##########################################################################################################################################
echo '***** client 2'
bash -i -l -c 'sshpass -p mininet \
ssh -oStrictHostKeyChecking=no mininet@10.0.0.2 "sudo D-ITG/D-ITG-2.8.0-rc1/bin/ITGRecv 0>/dev/null" &'
##########################################################################################################################################
echo '***** server 1'
bash -i -l -c 'sshpass -p mininet \
ssh -oStrictHostKeyChecking=no mininet@10.0.0.4 "\
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   08000 60000 667 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   08500 60000 708 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   09000 60000 750 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   09500 60000 792 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   10000 60000 833 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   10500 60000 875 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   11000 60000 917 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   11500 60000 958 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   12000 60000 1000 0>/dev/null && \
\
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   08000 60000 667 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   08500 60000 708 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   09000 60000 750 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   09500 60000 792 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   10000 60000 833 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   10500 60000 875 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   11000 60000 917 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   11500 60000 958 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   12000 60000 1000 0>/dev/null && \
\
date && echo ***** ... FINISHED"&'


echo '***** server 2'
bash -i -l -c 'sshpass -p mininet \
ssh -oStrictHostKeyChecking=no mininet@10.0.0.5 "\
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   08000 60000 667 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   08500 60000 708 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   09000 60000 750 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   09500 60000 792 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   10000 60000 833 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   10500 60000 875 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   11000 60000 917 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   11500 60000 958 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   12000 60000 1000 0>/dev/null && \
\
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   08000 60000 667 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   08500 60000 708 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   09000 60000 750 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   09500 60000 792 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   10000 60000 833 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   10500 60000 875 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   11000 60000 917 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   11500 60000 958 0>/dev/null && \
echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   12000 60000 1000 0>/dev/null && \
\
date && echo ***** ... FINISHED"&'
#echo '***** server 1'
#bash -i -l -c 'sshpass -p mininet \
#ssh -oStrictHostKeyChecking=no mininet@10.0.0.4 "\
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   04000 60000 334 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   04250 60000 354 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   04500 60000 375 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   04750 60000 396 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   05000 60000 416 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   05250 60000 437 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   05500 60000 458 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   05750 60000 479 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.1 10.0.0.3   06000 60000 500 0>/dev/null && \
#\
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   04000 60000 334 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   04250 60000 354 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   04500 60000 375 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   04750 60000 396 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   05000 60000 416 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   05250 60000 437 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   05500 60000 458 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   05750 60000 479 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.1 10.0.0.3   06000 60000 500 0>/dev/null && \
#\
#date && echo ***** ... FINISHED"&'


#echo '***** server 2'
#bash -i -l -c 'sshpass -p mininet \
#ssh -oStrictHostKeyChecking=no mininet@10.0.0.5 "\
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   04000 60000 334 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   04250 60000 354 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   04500 60000 375 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   04750 60000 396 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   05000 60000 416 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   05250 60000 437 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   05500 60000 458 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   05750 60000 479 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendUDP_cbr 10.0.0.2 10.0.0.3   06000 60000 500 0>/dev/null && \
#\
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   04000 60000 334 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   04250 60000 354 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   04500 60000 375 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   04750 60000 396 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   05000 60000 416 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   05250 60000 437 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   05500 60000 458 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   05750 60000 479 0>/dev/null && \
#echo '\n' && date && sudo ktr/ITGscripts/ITGSendTCP_cbr 10.0.0.2 10.0.0.3   06000 60000 500 0>/dev/null && \
#\
#date && echo ***** ... FINISHED"&'
