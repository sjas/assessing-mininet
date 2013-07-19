# Assessing Mininet

## What is this good for?

Working with the Mininet Network Simulator ( http://mininet.org/ ). Creating runnable Topologies for it, 
doing automated measurements via D-ITG (Distributed Internet Traffic Generator, http://traffic.comics.unina.it/software/ITG/)
 on it, using MATLAB to parse the results and produce usable output. 
(Samples can be found under https://github.com/sjas/assessing-mininet-results ).

So this project contains three different Frameworks/Generators:

    1. Python parser for Internet Topology Zoo's .graphml files to be converted into Mininet python-based topologies.
    2. D-ITG scripts for distributed traffic generation being used in a script framework.
    3. MATLAB code for evaluation of the D-ITG logs.
    
The parser is simply to ease the creation of larger real world topologies. Parse the .graphml file, add your hosts by
hand into the topo, and you have a directly executable/runnable topology for use with mininet 2.x with SSH access enabled.

The D-ITG scripts usually have to be tediously started by hand, thus a lot (though not all, sadly) of the tasks were 
automated through bash scripts. Two hosts and a log server are i.e. a setup used for measurements.
This means three extra SSH sessions by hand, to be repeated as often as you wish... My test setup consisted of four different setups consisting of five hosts each, repeated about ~25 times. Do the math, you won't stand this without scripting.

After running the test sets, a lot of data was generated, which was transferred directly to the MATLAB workstation after
decoding, a single test setup was done with test rows, result data averaged at 350 to 400 MB for one-minute-tests.

Currently these scripts need a lot of customizing due to hardcoded IP's and setting switches not being usable through a central config, and thus are a little like italian pasta. But every other approach would have rendered the work impossible.

The make sense of the data, the aforementioned MATLAB was used, but here also extensive scripting was needed, due to the 
size and the amount of log files.

## project contents:

    D-ITG-Setup         -   install file (install ITG from internet) and D-ITG-Patch
    ITGscripts          -   testscripts to be used with mininet
    parser              -   topo parser for .graphml files to executable mininet topologies
                            also an ant buildfile exists if jenkins is put to use, but may be outdated
    parser/topologies   -   .grapml samples and executable mininet topologies
    README.md           -   self-explanatory

## install

After the installation/setup of a Mininet VM, clone this repository to the mininet user's /home (usually /home/mininet on the pre-installed VM, as of Mininet 2.0.0) and name it 'ktr'. Install D-ITG (here 2.8.0 was used, version 2.8.1 is available by now at least.). **D-ITG** and **ktr** must reside in the homefolder, if you do not set the path's differently.

For easier handling symlinks like 

    $ ln -s /home/mininet/ktr/parser/topologies/Crosstraffic-Benchmark-without-node-4.py simple-topo
    $ ln -s /home/mininet/ktr/parser/topologies/Crosstraffic-Benchmark.py meshed-topo
    $ ln -s /home/mininet/ktr/ITGscripts/full-test-suite.sh fulltest
    $ ln -s /home/mininet/ktr/ITGscripts/full-test-suite-crosstraffic.sh fulltestcross
    $ ln -s /home/mininet/ktr/ITGscripts/ITGDecALL decode
    
should be created.

## workflow

At least that was the one I used usually: (Change to fit your needs, being careful...)

    0. ssh into machine running your SDN controller, if you use a remote one like me, and start it.
    1. ssh into mininet VM (define host entry in ~/.ssh/config for convenience).
    2. $ sudo ./simple-topo # to start test topology with ssh access.
    3. ssh into mininet VM with another console to run the test suite.
    4. $ sudo ./fulltest # starts the test suite which will start all needed ssh connections for D-ITG and start the measurements.
    5. $ sudo ./decode # will convert the binary logs to octave/matlab and text format, plus SCP'ing them to the MATLAB workstation I used for data analysis. Change the IP in the ITGDecAll file.
    6. Use the MATLAB scripts on the .dat data files with the given scripts.

Test setups for me were

    simple-topo + fulltest
    simple-topo + fulltestcross
    meshed-topo + fulltest
    meshed-topo + fulltestcross
    
A word on the SDN controller:
Here 'Floodlight' was used, because it supports topologies that has loops in it. Others did NOT work.
Keep that in mind before starting hourlong debugging sessions. (By the way 'Thou shalt subcribe to the mininet mailing list...' if you plan on doing anything with it. Freshest source of information you can find with highly active developers, and informations are up to date. If you ever use Mininet 1.x documentation, you will understand.)

A lot of filename creation takes place within these scripts, be careful when changing to a deviating naming scheme.
Also the MATLAB code WILL break. If you don't care, you will be fine. If not, fear the consequences. =)

## TODO

- [ ] An overhaul of the scripting setup is neccessary, to avoid the hardlinked folder/file paths.
- [x] Supply sources/links of technologies used.
- [ ] Check parser after last update for correctness.
- [x] Cleanup D-ITG code.
- [x] Cleanup MATLAB code.
- [x] Automate MATLAB for all current test scenarios.
    
## context / future

Since at the time being a bigger overhaul using different tools than when this was written was discussed, 
no steps were taken into that direction. 

Automatically provisioned Mininet VM's, controller restarts and running all 4 predefined test-setups automated 
are the goals to be strived for. But likely a lot of these further efforts being put into the bash scripts 
would be wasted, so you have to stick with what is implemented.

## software's versions being currently used

- Mininet 2.0.0 
- D-ITG 2.8.0-rc1
- MATLAB R2012a 7.14.0.739
- Floodlight SDN controller (cloned git repository at April 3rd 2013, changeset aca7e5943c7d8f8b299b5f91618286d325212b29)
- VirtualBox 4.2.10 rc84104
