# Little Busters! 

Home Page: http://tlwiki.org/index.php?title=Little_Busters!  
IRC: [#fluffy@irc.synirc.net](irc://irc.synirc.net/fluffy)

## Getting Started

This procedure is only tested in Linux (with 32-bit completely problem free).
I recommend using virtualisation, as it gets messy.

On windows, I recommend getting PuTTY instead of using the virtual machine's
window, and also getting WinSCP or filezilla for transfers to and from the VM.

### Setup your environment

#### Virtualisation
##### On Windows

* [VirtualBox](https://www.virtualbox.org/) (Recommended)
* [VMWare Player](http://www.vmware.com/products/player/overview.html)

##### On Linux

* [Virt-manager](http://virt-manager.org/), [libvirt](http://libvirt.org/)
  and/or [KVM](http://www.linux-kvm.org)
* [Xen](http://xen.org)

##### Guest
Any 32 bit Linux distro. Grab a live CD.

[Ubuntu](http://www.ubuntu.com/) is a good choice if you want no hassle, even
if you decide to run it permanantly on bare metal.

However, I prefer [Fedora](http://fedoraproject.org/).

Whatever you choose, boot the live CD and install it to the virtual disk.

#### Cygwin
[Cygwin](http://cygwin.org/)

You need to pick quite a few packages from the installer. Don't worry, the
installer is designed be run multiple times.

#### Distro packages
These packages, of any version, are available in Ubuntu, Fedora and Cygwin.
Each might have subtlely different names, and may be hidden in very different
categories.
Install them.

* gcc
* gcc-c++
* make
* unzip
* git
* subversion
* git-svn
* libpng-devel
* wget


#### OCaml
You need OCaml 3.09 (or any later 3.09 point release) and a few dependancies.
OCaml is notoriously bad at keeping backwards compatibility, so pay attention
to version numbers.

The exact numbers are in the rldev INSTALL file, and exact download URLs can be
found in the kickstart file.

As per usual, the standard procedure for installing each is:
>	./configure  
>	make  
>	make install

However, some OCaml packages also have "opt" targets which are also required
for rldev. Generally, it is safe to use:
>	make opt

or  
>	make all.opt  

on all of the packages. Only good things will come from that command; despite
some giving off errors, nothing bad has happened.

If you don't want all this hassle, but can boot CentOS kickstart files, take a
look at fluffy-ks.cfg that should be accompanying this readme.

### Get rldev

https://github.com/theappleman/rldev.git

Rldev is stored in a git repository. Clone it, configure it and build:
>	git clone git://github.com/theappleman/rldev.git  
>	cd rldev/src  
>	./configure  
>	omake  
>	omake install

Check your PATH for the new commands
>	command -v rlc  
>	rlc --version


### Grab the translation
Our translation is stored in subversion:
>	svn co svn://vndb.org/lb/applehq Scripts

To build exerything, do:
>	cd Scripts  
>	make  
>	make ex me

To update the scripts after someone has worked on it:
>	svn up  
>	make  
>	for i in ex me; do cd $i; make pclean; cd ..; done  
>	make ex me

### Grab the images
Either grab the premade ones from the installer (open it with 7z) or remake
your own.

The vaconv utility in rldev doesn't seem to work on 64-bit systems, though.

Edit up g00-gen.rb and it will plop the images into the right places.

If grabbing the premade ones, be extra careful with the G00 and EG00
directories. Take a look at the NSIS script for more info on why.

### Package it all up
Get NSIS. You can either do that in the virtual machine or get the parts onto
your windows box and run it there.

If using it from linux, I recommend using wine and nsis for windows, rather than
distribution packages for mingw32-nsis.


## TODO
* Things missing from the installer that were lost
  * Fonts (FontReg.nsh; needs work)
  * Shortcuts (I'd like shortcuts to be off by default)
* Resource picking from the DVD

