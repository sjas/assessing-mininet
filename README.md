# Asessing Mininet

This project contains three different system implementations:

    1. Python parser for Internet Topology Zoo's .graphml files to be converted into Mininet python-based topologies.
    2. D-ITG scripts for distributed traffic generation being used in a script framework.
    3. MATLAB code for evaluation of the D-ITG logs.

## project contents:

    D-ITG-Setup         -   install file (install ITG from internet) and D-ITG-Patch
    ITGscripts          -   testscripts to be used with mininet
    parser              -   topo parser for .graphml files to executable mininet topologies
                            also an ant buildfile exists if jenkins is put to use, but may be outdated
    parser/topologies   -   .grapml samples and executable mininet topologies
    README.md           -   self-explanatory

## install

After the installation/setup of a Mininet VM, clone this repository to the mininet user's /home (usually /home/mininet on the pre-installed VM, as of Mininet 2.0.0) and name it 'ktr'. Install D-ITG (here 2.8.0 was used, version 2.8.1 is available by now at least.). **D-ITG** and **ktr** must reside in the homefolder, if you do not set the path's differently.

For easier handling create symlinks like 
    $ ln -s /home/mininet/ktr/parser/topologies/Crosstraffic-Benchmark-without-node-4.py simple-topo
    $ ln -s /home/mininet/ktr/parser/topologies/Crosstraffic-Benchmark.py meshed-topo
    $ ln -s /home/mininet/ktr/ITGscripts/full-test-suite.sh fulltest
    $ ln -s /home/mininet/ktr/ITGscripts/full-test-suite-crosstraffic.sh fulltestcross
    $ ln -s /home/mininet/ktr/ITGscripts/ITGDecALL decode

## workflow

At least that was the one I used usually: (Change to fit your needs, being careful...)

    0. ssh into maching running your SDN controller, if you use a remote one like me, and start it.
    1. ssh into mininet VM (define host entry in ~/.ssh/config for convenience).
    2. *$ sudo ./simple-topo* to start test topology with ssh access.
    3. ssh into mininet VM with another console to run the test suite.
    4. *$ sudo ./fulltest* starts the test suite which will start all needed ssh connections for D-ITG and start the measurements.
    5. *$ sudo ./decode* will convert the binary logs to octave/matlab and text format, plus SCP'ing them to the MATLAB workstation I used for data analysis. Change the IP in the ITGDecAll file.
    6. Use the MATLAB scripts on the .dat data files with the given scripts.

A lot of filename creation takes place within these scripts, be careful when changing to a deviating naming scheme.

## TODO

An overhaul of the scripting setup is neccessary, to avoid the hardlinked folder/file paths.

## context / future

Since at the time being a bigger overhaul using different tools than when this was written was discussed, 
no steps were taken into that direction. 

Automatically provisioned Mininet VM's, controller restarts and running all 4 predefined test-setups automated 
are the goals to be strived for. But likely a lot of these further efforts being put into the bash scripts 
would be wasted, so you have to stick with what is implemented.
