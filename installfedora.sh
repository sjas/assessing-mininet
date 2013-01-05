#!/usr/bin/env bash

# Mininet install script for Ubuntu (and Debian Lenny) by:
# Brandon Heller (brandonh@stanford.edu)
# Fedora adaption made by:
# Stephan 'sjas' Schuberth (stephan_schuberth@web.de)

# Fail on error
set -e

# Fail on unset var usage
set -o nounset

# Location of CONFIG_NET_NS-enabled kernel(s)
KERNEL_LOC=http://www.openflow.org/downloads/mininet

# Attempt to identify Linux release
DIST=Unknown
RELEASE=Unknown
CODENAME=Unknown
ARCH=`uname -m`

if [ "$ARCH" = "x86_64" ]; then ARCH="amd64"; fi
if [ "$ARCH" = "i686" ]; then ARCH="i386"; fi

grep Fedora /etc/redhat-release &> /dev/null && DIST="Fedora"
if [ "$DIST" = "Fedora" ]; then
    install='sudo yum -y install'
    remove='sudo yum -y remove'
    pkginst='sudo rpm -q'
    ## Prereqs for this script
    if ! which lsb_release &> /dev/null; then
        $install redhat-lsb
    fi
    if ! which bc &> /dev/null; then
        install bc
    fi
fi
if which lsb_release &> /dev/null; then
    DIST=`lsb_release -is`
    RELEASE=`lsb_release -rs`
    CODENAME=`lsb_release -cs`
fi
echo "Detected Linux distribution: $DIST $RELEASE $CODENAME $ARCH"

# Kernel params

if [ "$DIST" = "Fedora" ] && [ "$ARCH" = "i386" ]; then
    KERNEL_NAME=`uname -r`
    KERNEL_HEADERS=linux-headers-${KERNEL_NAME}
else
    echo "Installcentos.sh currently only supports Fedora i386."
    exit 1
fi

# More distribution info
DIST_LC=`echo $DIST | tr [A-Z] [a-z]` # as lower case

# Kernel pkg to be removed:
# sjas: get the old kernel image to be referenced here...
KERNEL_IMAGE_OLD=linux-image-2.6.26-33-generic

DRIVERS_DIR=/lib/modules/${KERNEL_NAME}/kernel/drivers/net

OVS_RELEASE=1.4.0
OVS_PACKAGE_LOC=https://github.com/downloads/mininet/mininet
OVS_BUILDSUFFIX=-ignore # was -2
OVS_PACKAGE_NAME=ovs-$OVS_RELEASE-core-$DIST_LC-$RELEASE-$ARCH$OVS_BUILDSUFFIX.tar
OVS_SRC=~/openvswitch
OVS_TAG=v$OVS_RELEASE
OVS_BUILD=$OVS_SRC/build-$KERNEL_NAME
OVS_KMODS=($OVS_BUILD/datapath/linux/{openvswitch_mod.ko,brcompat_mod.ko})

#function kernel {
    # sjas: disabled kernel check for fedora, it runs 3.3 anyway
    #echo "Install Mininet-compatible kernel if necessary"

    # sjas: does this work at all?
    #sudo yum -y update
    #$install linux-image-$KERNEL_NAME

        #sudo apt-get update
        ## The easy approach: download pre-built linux-image and linux-headers packages:
        #wget -c $KERNEL_LOC/$KERNEL_HEADERS
        #wget -c $KERNEL_LOC/$KERNEL_IMAGE

        # sjas: this is still debian code
        # Install custom linux headers and image:
        #$pkginst $KERNEL_IMAGE $KERNEL_HEADERS

        # The next two steps are to work around a bug in newer versions of
        # kernel-package, which fails to add initrd images with the latest kernels.
        # See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=525032
        # Generate initrd image if the .deb didn't install it:

        #if ! test -e /boot/initrd.img-${KERNEL_NAME}; then
            #sudo update-initramfs -c -k ${KERNEL_NAME}
        #fi

        # Ensure /boot/grub/menu.lst boots with initrd image:
        # sjas: see other install file for working code
        # sjas: update-grub no longer works
        #sudo update-grub

        # The default should be the new kernel. Otherwise, you may need to modify
        # /boot/grub/menu.lst to set the default to the entry corresponding to the
        # kernel you just installed.
    #if [ "$DIST" = "Fedora" ]; then
        #sudo yum check-update
        #$install linux-image-$KERNEL_NAME
    #echo "updating kernel"
    #fi
#}

function kernel_clean {
    echo "Cleaning kernel..."

    # To save disk space, remove previous kernel
    if ! $remove $KERNEL_IMAGE_OLD; then
        echo $KERNEL_IMAGE_OLD not installed.
    fi

    # sjas: does this work?
    # Also remove downloaded packages:
    rm -f ~/linux-headers-* ~/linux-image-*
}

# Install Mininet deps
function mn_deps {
    echo "Installing Mininet dependencies"
    $install gcc make screen psmisc xterm openssh iperf iproute telnet \
        python-setuptools python-networkx libcgroup ethtool help2man \
        pyflakes pylint python-pep8

    # sjas: this should work with all types of distrubutions?
    # sjas: removed it because things hung here
    #if [ "$DIST" = "Ubuntu" ] && [ "$RELEASE" = "10.04" ]; then
        #echo "Upgrading networkx to avoid deprecation warning"
        #sudo easy_install --upgrade networkx
    #fi

    # Add sysctl parameters as noted in the INSTALL file to increase kernel
    # limits to support larger setups:
    sudo su -c "cat $HOME/mininet/util/sysctl_addon >> /etc/sysctl.conf"

    # Load new sysctl settings:
    sudo sysctl -p \
        && \
    echo "Installing Mininet core"
    pushd ~/mininet
    sudo make install
    popd
}

# The following will cause a full OF install, covering:
# -user switch
# The instructions below are an abbreviated version from
# http://www.openflowswitch.org/wk/index.php/Debian_Install
# ... modified to use Debian Lenny rather than unstable.
function of {
    echo "Installing OpenFlow reference implementation..."
    cd ~/
    $install git autoconf automake pkgconfig \
        make gcc libtool
    git clone git://openflowswitch.org/openflow.git
    cd ~/openflow

    # Patch controller to handle more than 16 switches
    patch -p1 < ~/mininet/util/openflow-patches/controller.patch

    # Resume the install:
    ./boot.sh
    ./configure
    # sjas: added sudo here
    make
    sudo make install

    # Remove avahi-daemon, which may cause unwanted discovery packets to be
    # sent during tests, near link status changes:
    $remove avahi-daemon

    # Disable IPv6.  Add to /etc/modprobe.d/blacklist:
    BLACKLIST=/etc/modprobe.d/blacklist.conf

    sudo sh -c "echo 'blacklist net-pf-10\nblacklist ipv6' >> $BLACKLIST"
    cd ~
}

function wireshark {
    echo "Installing Wireshark dissector..."

    # sjas: check wireshark package stuff
    sudo yum groupinstall "X Window System"
    sudo yum install -y wireshark wireshark-gnome glib2-devel
    cd ~/openflow/utilities/wireshark_dissectors/openflow
    make
    sudo make install

    # Copy coloring rules: OF is white-on-blue:
    mkdir -p ~/.wireshark
    cp ~/mininet/util/colorfilters ~/.wireshark
}


# Install Open vSwitch
# Instructions derived from OVS INSTALL, INSTALL.OpenFlow and README files.

function ovs {
    echo "Installing Open vSwitch..."

    # sjas: fedora equivalent of 'dpkg --get-selections':
    # sjas: rpm -qa --qf '%{NAME}\n' | grep <<find term to grep>>; then

    $install openvswitch openvswitch-controller python-openvswitch
    ## Otherwise attempt to install from source
    #$install git pkgconfig gcc make python-devel openssl-devel libtool
    ## Install OVS from release
    #cd ~/
    #git clone git://openvswitch.org/openvswitch $OVS_SRC
    #cd $OVS_SRC
    #git checkout $OVS_TAG
    #./boot.sh
    #BUILDDIR=/lib/modules/${KERNEL_NAME}/build
    #if [ ! -e $BUILDDIR ]; then
        #echo "Creating build sdirectory $BUILDDIR"
        #sudo mkdir -p $BUILDDIR
    #fi
    #opts="--with-linux=$BUILDDIR"
    #mkdir -p $OVS_BUILD
    #cd $OVS_BUILD
    #../configure $opts
    #make
    #sudo make install

    #modprobe

}

function remove_ovs {
    pkgs=`dpkg --get-selections | grep openvswitch | awk '{ print $1;}'`
    echo "Removing existing Open vSwitch packages:"
    echo $pkgs
    if ! $remove $pkgs; then
        echo "Not all packages removed correctly"
    fi
    # For some reason this doesn't happen
    if scripts=`ls /etc/init.d/*openvswitch* 2>/dev/null`; then
        echo $scripts
        for s in $scripts; do
            s=$(basename $s)
            echo SCRIPT $s
            sudo service $s stop
            sudo rm -f /etc/init.d/$s
            sudo update-rc.d -f $s remove
        done
    fi
    echo "Done removing OVS"
}

# Install NOX with tutorial files
function nox {
    echo "Installing NOX w/tutorial files..."

    # Install NOX deps:
    $install autoconf automake g++ libtool python python-twisted \
        swig libssl-dev make
    if [ "$DIST" = "Debian" ]; then
        $install libboost1.35-dev
    elif [ "$DIST" = "Ubuntu" ]; then
        $install python-dev libboost-dev
        $install libboost-filesystem-dev
        $install libboost-test-dev
    fi
    # Install NOX optional deps:
    $install libsqlite3-dev python-simplejson

    # Fetch NOX destiny
    cd ~/
    git clone https://github.com/noxrepo/nox-classic.git noxcore
    cd noxcore
    if ! git checkout -b destiny remotes/origin/destiny ; then
        echo "Did not check out a new destiny branch - assuming current branch is destiny"
    fi

    # Apply patches
    git checkout -b tutorial-destiny
    git am ~/mininet/util/nox-patches/*tutorial-port-nox-destiny*.patch
    if [ "$DIST" = "Ubuntu" ] && [ `expr $RELEASE '>=' 12.04` = 1 ]; then
        git am ~/mininet/util/nox-patches/*nox-ubuntu12-hacks.patch
    fi

    # Build
    ./boot.sh
    mkdir build
    cd build
    ../configure
    make -j3
    #make check

    # sjas: on ubuntu this was broken when running things through sudo IIRC
    # Add NOX_CORE_DIR env var:
    sed -i -e 's|# for examples$|&\nexport NOX_CORE_DIR=~/noxcore/build/src|' ~/.bashrc

    # To verify this install:
    #cd ~/noxcore/build/src
    #./nox_core -v -i ptcp:
}

# "Install" POX
function pox {
    echo "Installing POX into $HOME/pox..."
    cd ~
    git clone https://github.com/noxrepo/pox.git
}

# Install OFtest
function oftest {
    echo "Installing oftest..."

    # Install deps:
    $install tcpdump scapy

    # Install oftest:
    cd ~/
    git clone git://github.com/floodlight/oftest
    cd oftest
    cd tools/munger
    sudo make install
}

# Install cbench
function cbench {
    echo "Installing cbench..."

    $install net-snmp net-snmp-devel net-snmp-libs libconfig libconfig-devel libpcap-devel

    cd ~/
    git clone git://openflow.org/oflops.git
    cd oflops
    sh boot.sh || true # possible error in autoreconf, so run twice
    sh boot.sh
    ./configure --with-openflow-src-dir=$HOME/openflow
    make
    # sjas: the next line made me laugh, hard :D
    #sudo make install || true # make install fails; force past this
}

function other {
    echo "Doing other setup tasks..."

    # Enable command auto completion using sudo; modify ~/.bashrc:
    sed -i -e 's|# for examples$|&\ncomplete -cf sudo|' ~/.bashrc

    # Install tcpdump and tshark, cmd-line packet dump tools.  Also install gitk,
    # a graphical git history viewer.
    $install tcpdump tshark gitk

    # Install common text editors
    $install vim nano emacs
    $install vim-enhanced

    # Install NTP
    $install ntp

    # Set git to colorize everything.
    git config --global color.diff auto
    git config --global color.status auto
    git config --global color.branch auto

    # Reduce boot screen opt-out delay. Modify timeout in /boot/grub/menu.lst to 1:
    if [ "$DIST" = "Debian" ]; then
        sudo sed -i -e 's/^timeout.*$/timeout         1/' /boot/grub/menu.lst
    fi

    # sjas: centos has good kernel
    # Clean unneeded debs:
    #rm -f ~/linux-headers-* ~/linux-image-*
}

# Script to copy built OVS kernel module to where modprobe will
# find them automatically.  Removes the need to keep an environment variable
# for insmod usage, and works nicely with multiple kernel versions.
#
# The downside is that after each recompilation of OVS you'll need to
# re-run this script.  If you're using only one kernel version, then it may be
# a good idea to use a symbolic link in place of the copy below.
function modprobe {
    echo "Setting up modprobe for OVS kmod..."

    sudo cp $OVS_KMODS $DRIVERS_DIR
    sudo depmod -a ${KERNEL_NAME}
}

function all {
    echo "Running all commands..."
    #kernel
    mn_deps
    of
    wireshark
    ovs
    # sjas: TODO check nox 
    # NOX-classic is deprecated, but you can install it manually if desired.
    # nox
    pox
    oftest
    cbench
    other
    echo "Please reboot, then run ./mininet/util/install.sh -c to remove unneeded packages."
    echo "Enjoy Mininet!"
}

# Restore disk space and remove sensitive files before shipping a VM.
function vm_clean {

    echo "Cleaning VM..."
    if [ "$DIST" = "Fedora" ]; then
        sudo yum clean
    fi
    sudo rm -rf /tmp/*
    sudo rm -rf openvswitch*.tar.gz

    # Remove sensitive files
    history -c  # note this won't work if you have multiple bash sessions
    rm -f ~/.bash_history  # need to clear in memory and remove on disk
    rm -f ~/.ssh/id_rsa* ~/.ssh/known_hosts
    sudo rm -f ~/.ssh/authorized_keys*

    # sjas: TODO is this still needed?
    # Remove Mininet files
    #sudo rm -f /lib/modules/python2.5/site-packages/mininet*
    #sudo rm -f /usr/bin/mnexec

    # Clear optional dev script for SSH keychain load on boot
    rm -f ~/.bash_profile

    # Clear git changes
    git config --global user.name "None"
    git config --global user.email "None"

    # Remove mininet install script
    rm -f install-mininet.sh
}

function usage {
    printf 'Usage: %s [-acdfhkmntvxy]\n\n' $(basename $0) >&2

    printf 'This install script attempts to install useful packages\n' >&2
    printf 'for Mininet. It should (hopefully) work on Fedora 17! :D\n' >&2
    printf 'If you run into trouble, try\n' >&2
    printf 'installing one thing at a time, and looking at the \n' >&2
    printf 'specific installation function in this script.\n\n' >&2

    printf 'options:\n' >&2
    printf -- ' -a: (default) install (A)ll packages - good luck!\n' >&2
    printf -- ' -b: install controller (B)enchmark (oflops)\n' >&2
    printf -- ' -c: (C)lean up after kernel install\n' >&2
    printf -- ' -d: (D)elete some sensitive files from a VM image\n' >&2
    printf -- ' -f: install open(F)low\n' >&2
    printf -- ' -h: print this (H)elp message\n' >&2
    printf -- ' -k: install new (K)ernel\n' >&2
    printf -- ' -m: install Open vSwitch kernel (M)odule from source dir\n' >&2
    printf -- ' -n: install mini(N)et dependencies + core files\n' >&2
    printf -- ' -r: remove existing Open vSwitch packages\n' >&2
    printf -- ' -t: install o(T)her stuff\n' >&2
    printf -- ' -v: install open (V)switch\n' >&2
    printf -- ' -w: install OpenFlow (w)ireshark dissector\n' >&2
    printf -- ' -x: install NO(X) OpenFlow controller\n' >&2
    printf -- ' -y: install (A)ll packages\n' >&2

    exit 2
}

if [ $# -eq 0 ]
then
    all
else
    while getopts 'abcdfhkmnprtvwx' OPTION
    do
      case $OPTION in
      a)    all;;
      b)    cbench;;
      c)    kernel_clean;;
      d)    vm_clean;;
      f)    of;;
      h)    usage;;
      k)    kernel;;
      m)    modprobe;;
      n)    mn_deps;;
      p)    pox;;
      r)    remove_ovs;;
      t)    other;;
      v)    ovs;;
      w)    wireshark;;
      x)    nox;;
      ?)    usage;;
      esac
    done
    shift $(($OPTIND - 1))
fi
