#!/bin/bash

# use with floodlight running on host

sudo mn --link tc --custom /home/mininet/ktr/parser/raw-material/Dfn.graphml-generated-Mininet-Topo.py --topo generated --test iperf

