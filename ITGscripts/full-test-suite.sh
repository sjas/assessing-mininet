#!/bin/bash
#
# TEST SUITE SCRIPT
#
# NEEDS: sudo apt-get install sshpass -y
#
# ssh's automatically into each machine, starting everything
# <CTRL-D> a lot after the flow is sent completely to get out of all shells
#
###########################################################################
#currently unneeded:
##ip section
#cl1="10.0.0.1"
#cl2="10.0.0.2"
#log="10.0.0.3"
#srv1="10.0.0.4"
#srv2="10.0.0.5"

#log server
sshpass -p 'mininet' ssh mininet@10.0.0.3 && sudo ITGLog &

#client 1
sshpass -p 'mininet' ssh mininet@10.0.0.1 && sudo ITGRecv &
#client 2
sshpass -p 'mininet' ssh mininet@10.0.0.2 && sudo ITGRecv &

#server 1
sshpass -p 'mininet' ssh mininet@10.0.0.4 && sudo ktr/ITGscripts/ITGSendUDP 10.0.0.1 1 10.0.0.3 &
#server 2
sshpass -p 'mininet' ssh mininet@10.0.0.5 && sudo ktr/ITGscripts/ITGSendUDP 10.0.0.2 1 10.0.0.3 &
