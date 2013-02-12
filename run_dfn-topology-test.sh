#!/bin/bash

# use with floodlight running on host

sudo mn --controller remote --ip 10.0.2.2 --custom mininet/custom/Dfn.graphml-generated-Mininet-Topo.py --topo generated --test iperf

