#!/bin/bash

sudo mn --controller remote --ip 10.0.2.2 --custom mininet/custom/seminartest.py --topo seminartest --test iperf

