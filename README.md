[![Slack Status](http://sdlslack.herokuapp.com/badge.svg)](http://slack.smartdevicelink.com)

[![Build Status](https://travis-ci.org/smartdevicelink/sdl_core.svg?branch=master)](https://travis-ci.org/smartdevicelink/sdl_core)

 [![codecov.io](https://codecov.io/github/smartdevicelink/sdl_core/coverage.svg?branch=develop)](https://codecov.io/github/smartdevicelink/sdl_core?branch=develop)

# SmartDeviceLink (SDL)

SmartDeviceLink (SDL) is a standard set of protocols and messages that connect applications on a smartphone to a vehicle head unit. This messaging enables a consumer to interact with their application using common in-vehicle interfaces such as a touch screen display, embedded voice recognition, steering wheel controls and various vehicle knobs and buttons. There are three main components that make up the SDL ecosystem.

  * The [Core](https://github.com/smartdevicelink/sdl_core) component is the software which Vehicle Manufacturers (OEMs)  implement in their vehicle head units. Integrating this component into their head unit and HMI based on a set of guidelines and templates enables access to various smartphone applications.
  * The optional [SDL Server](https://github.com/smartdevicelink/sdl_server) can be used by Vehicle OEMs to update application policies and gather usage information for connected applications.
  * The [iOS](https://github.com/smartdevicelink/sdl_ios) and [Android](https://github.com/smartdevicelink/sdl_android) libraries are implemented by app developers into their applications to enable command and control via the connected head unit.

Pull Requests Welcome!

## Documentation

  * [Software Architecture Document](https://smartdevicelink.com/en/guides/core/software-architecture-document/table-of-contents/)
  * [Transport Manager Programming Guide](https://smartdevicelink.com/en/guides/core/transport-manager-programming/)
  * [Software Detailed Design](https://app.box.com/s/ohgrvemtx39f8hfea1ab676xxrzvyx1y)
  * [Integration Guidelines](https://smartdevicelink.com/en/docs/hmi/master/overview/)

## SDL Core

The Core component of SDL runs on a vehicle's computing system (head unit). Core’s primary responsibility is to pass messages between connected smartphone applications and the vehicle HMI, and pass notifications from the vehicle to those applications. It can connect a smartphone to a vehicle's head unit via a variety of transport protocols such as Bluetooth, USB, Android AOA, and TCP. Once a connection is established, Core discovers compatible applications and displays them to the driver for interaction via voice or display. The core component is implemented into the vehicle HMI based on the integration guidelines above. The core component is configured to follow a set of policies defined in a policy database and updated by a [policy server](https://www.github.com/smartdevicelink/sdl_server). The messaging between a connected application and core is defined by the [Mobile API](https://github.com/smartdevicelink/sdl_core/blob/master/src/components/interfaces/MOBILE_API.xml) and the messaging between sdl core and the vehicle is defined by the [HMI API](https://github.com/smartdevicelink/sdl_core/blob/master/src/components/interfaces/HMI_API.xml).

## Project Status
We're ramping up our efforts to get SmartDeviceLink developed and maintained directly in the open. For the Mobile libraries, we're expecting better integration soon, SDL Core is slightly more complicated. We are currently working on generating documentation, creating a developer portal, an open forum, Mobile validation, and everything else that we've been asked for to renew the community's interest in this project. From a technical standpoint, SDL is stable, and the most work is being put into making it a more robust solution for app connectivity. We are, however, definitely looking for and interested in other people and company's contributions to SDL whether it be feature based, bug fixes, healthy conversation, or even just suggestions for improvement.



## COMPILATION FOR ARM/AUTOMOTIVE GRADE LINUX
This is an extensive guide on compilation, installation, and configuration of
an instance of SDL Core on Automotive Grade Linux (AGL) running on a raspberrypi3.

# Overview of steps:
   1. Setup development environment (Dev VM or native Ubuntu 14.04)
   2. Create and install AGL image (if not already created)
   3. Create and install AGL cross sdk 
   4. Clone and build SDL
   5. Clone and build the bluez tools repository 


# Detailed steps:
Note: Anything that begins with the character '$' indicates that the following is to be entered into a linux terminal

1. Setup development environment (Dev VM of Ubuntu 14.04 is assumed, modify as needed if running natively)
   1. Download and install Virtual Box (https://www.virtualbox.org/wiki/Downloads)
   2. Download Ubuntu 14.04 64 bit image (http://releases.ubuntu.com/14.04/)
   3. Create a new virtual machine in VBox (basically the virtual hardware your Ubuntu will ‘live’ in)
   4. You’ll need to set the number of processors it has, how much RAM to allocate, and create a virtual hard drive
      2. RAM: 4 gigs (4098MB) is preferable
      3. Disk size: 140 GB (You actually cannot have less than 90 or the
         compilation will fail when building AGL. You need 120 for AGL and the
         Cross SDK. If you add 'INHERIT += "rm_work"' To the AGL yocto build's
         local.conf after sourcing the aglsetup.sh script it will delete
         artifacts after a recipe is built meaning you can have a smaller
         Virtual Machine)
      4. Number of processors: more than 1 (4 is preferable)
      5. Video memory: I found at least 64 to be preferable
   5. In the VM’s Settings->Storage->Controller: IDE->Empty click on the DVD icon next to CD/DVD Drive underneath the “Attributes” section.
      1. Select your downloaded Ubuntu 14.04 iso
   6. Start the Virtual Machine
   7. Go through the install process, selecting the appropriate city/time zone. Otherwise default settings should be fine.
   8. Reboot; Should have a working Ubuntu Linux VM now
   9. Install VBOX guest addtions
      1. From VM's virtualbox options: Devices->Insert Guest Additions CD Image
      2. Should have a popup asking you to run the CD. If not, navigate to /media/[your username]/VBOXADDITIONS_[version] and run the install script
      3. Enable clipboard: Devices->Shared Clipboard->Bidirectional
      4. Enable drag and drop: Devices->Drag and Drop->Bidirectional
      5. Enable Shared folders:
         1. Devices->Shared Folders->Shared Folders Settings
         2.  Click the "add folder" icon on the right-top of the settings window
         3. Folder path dropdown->Other ...->Select your desired host folder (I normally choose "Documents")
         4. A name should be automatically filled in for "Folder Name", remember your "Folder Name".
         5. Click auto-mount and make permanent
         6. Click ok
         7. Click ok
         8. make a folder ~/s ($ mkdir ~/s). "~" is Linux shorthand for /home/[username]
         9. With root permissions (sudo) create a script "setup_share" at /usr/local/bin containing the following text:
            1. #!/bin/bash
            2. mount -t vboxsf [your "Folder Name"] ~/s
         10. make setup_share executable: $ sudo chmod+x /usr/local/bin/setup_share
         11. Run setup_share: $ sudo setup_share
         12. ~/s should now be symlinked to Documents, meaning you can do any normal terminal commands (cd, cp, rm) in your Documents folder from there. Gui should also work
         13. Rerun "$ sudo setup_share" if your shared folder stops working
   10. Install lighter gui. Ubuntu's standard gui can make doing tasks (especially cpu intensive ones like compiling) really slow. We'll replace it with something lighter
         1. $ sudo apt update
         2. $ sudo apt install lxde lxsession openbox lxsession-logout
         3. Reboot your VM. During the next login select the new circular icon in the login box and select LXDE
   11. Install missing programs: sudo apt install make cmake gcc git gawk wget git-core diffstat
   unzip texinfo gcc-multilib build-essential chrpath socat libsdl1.2-dev xterm cpio curl autoconf


2. Create and install AGL image (if not already created)
   1. $ mkdir ~/bin 
   2. $ export PATH=~/bin:$PATH 
   3. $ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
   4. $ chmod a+x ~/bin/repo 
   5. Select which source to download. See http://docs.automotivelinux.org/docs/getting_started/en/dev/reference/source-code.html for more options. To download the master source do the following:
      1. $ repo init -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo 
   6. $ repo sync
   7. $ source meta-agl/scripts/aglsetup.sh -m raspberrypi3 agl-demo agl-netboot agl-appfw-smack
   8. If you add 'INHERIT += "rm_work"' To the AGL yocto build's local.conf after sourcing the aglsetup.sh script it will delete artifacts after a recipe is built meaning you can have a smaller Virtual Machine hard disk. Rerunning aglsetup.sh can overwrite this value so make sure you check it after resourcing the script.
   9. $ bitbake agl-demo-platform
      1. This command will take a LOOOONG time. On a decent laptop it takes 5 1/2 hours+
   10. attach sdcard usb reader (with sdcard inside)
   11. from VirtualBox->Devices->USB->USB Settings: add sdcard reader
   12. View details about attached sd card via $ dmesg
   13. Make sure all sd card partitions are unmonted:
      1. $ sudo umount /dev/sdb1 
      2. $ sudo umount /dev/sdb 
      3. Repeat as necessary based on $ dmesg 
   14. $ sudo dd
   if=/home/duran/build/tmp/deploy/images/raspberrypi3/agl-demo-platform-raspberrypi3.rpi-sdimg of=/dev/sdX bs=4M
   15. $ sync
   16. To watch the progress of the command do the following in a *different* terminal: $ watch grep -e Dirty: -e Writeback: /proc/meminfo
   17. Add partition to mount unused space on sd card (it's also possible to expand the current partition to use up the free space, this is only one method to deal with the problem)
   18. $ fdisk /dev/sdb 
   19. List *free* space on the card 
      1. $ F
      2. Make a note of the beginning of the large empty block (NOT the 2048 sector). This sector will be used later (OPEN_START_SECTOR)
   20. $ n
   21. $ p
   22. Hit enter for default partition number 
   23. $ OPEN_START_SECTOR 
   24. press enter till we are back at the main menu
   25. $ w
   26. We need to make file system for the new partition (probably /dev/sdb3, eject and replug/umount the card and use '$ dmesg' to recheck)
   27. $ mkfs -t ext4 /dev/sdb3 
   28. $ eject /dev/sdb 
   29. Remove sdcard reader and place sd card into raspberry pi3. 
   30. Plug in power to boot pi3 
   31. How to fix video: video doesn't always work. To fix, you'll need to a serial debug connection to the pi 
      1. You need a raspberry pi 3 serial debug cable (it connects the
      motherboard pins and the other end is a usb) 
      2. install package 'screen' if not installed (sudo apt install screen)
      3. Physically install serial debug cable to rasppi board (you have to
      connect wires to pins on the motherboard, refer to instructions that come
      with your cable)
      4. Connect usb end of serial debug cable to laptop
      5. from VirtualBox->Devices->USB->USB Settings: add serial device
      6. unplug and replug the serial debug cable usb
      7. use "$ dmesg" and verify that a new device was detected and assigned
      to /dev/ttyUSB0
      8. Connect screen to serial connection: 
      9. $ sudo screen /dev/ttyUSB0 115200  
      10. should just be a blinking cursor
      11. plug in power cable to rasppi
      12. you should see text in your "screen" terminal. It has become a terminal for the pi
      13. When it prompts for user just type "root" and hit enter
      14. If it stops eventually and you don't see the user prompt, try pressing enter to get it to repopulate
      15. Once logged in, log messages may pop up in the middle of whatever you're doing, you can disable these by: 
         1. $ vi /etc/sysctl.conf
         2. Uncomment the line beginning with "kernel.printk = "
         3. You may have to reboot to get it to activate
      16. If at some point the text in your terminal starts behaving strangely and messed up, a simple fix is to restart your VM.
      17. Mount new partition containing the sd card's free space 
         1. mkdir /home/rw
         2. $ vi /etc/fstab
         3. # insert new line after the other lines. replace "mmcblk0p3" with whatever your partition is:
            1. /dev/mmcblk0p3 /home/rw ext4 defaults 0 2
         4. # restart pi. /home/rw should have all that free space now
      18. To enable video to the hdmi display (in pi AGL serial debug terminal): 
         1. $ cp /etc/xdg/weston/weston.ini /etc/xdg/weston/weston.ini.bak
         2. $ vi /etc/xdg/weston/weston.ini
         3. //edit the file to be identical to below:
         4. /etc/xdg/weston/weston.ini:
            ```
            [core]

            backend=drm-backend.so

            shell=desktop-shell.so 

            [output] 

            name=HDMI-A-1

            transform=270

            ```


3. Create and install AGL cross sdk 
   1. Compile and install the AGL crosssdk 
      1. Note: text after a "$ " indicates the following text is a terminal command
      2. Create rasp pi image and AGL cross sdk 
   2. $ mkdir ~/bin
   3. $ export PATH=~/bin:$PATH
   4. $ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
   5. $ chmod a+x ~/bin/repo repo init -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo
   6. $ repo sync
   7. $ source meta-agl/scripts/aglsetup.sh -m raspberrypi3 agl-demo agl-netboot agl-appfw-smack
   8. If at any time the build fails due to a missing or extra yocto
   configuration file try using the '-f' flag to force a reconfiguration:
      1. $ source meta-agl/scripts/aglsetup.sh -f -m raspberrypi3 agl-demo agl-netboot agl-appfw-smack
   9. $ bitbake agl-demo-platform-crosssdk
      1. This command can take a LOOOONG time. On a decent laptop it can take 5 1/2 hours+
   10. $ cd ~/build/tmp/deploy/sdk
   11. $ sudo ./poky-agl-glibc-x86_64-agl-demo-platform-crosssdk-cortexa7hf-neon-vfpv4-toolchain-3.0.0+snapshot.sh
   12. Create a helpful sourcable script to the sdk
   13. $ gedit ~/qt-agl-cross:
      1. #!/bin/bash
      2. . /opt/poky-agl/3.0.0+snapshot/environment-setup-cortexa7hf-neon-vfpv4-agl-linux-gnueabi
   14. save and close ~/qt-agl-cross 
   15. To use the sdk from a terminal do '$ ~/qt-agl-cross' to setup your environment


4. Clone and build SDL
   1. move to another terminal tab and source the sdk (repeat this command if you open a new tab in order to build properly):  . /opt/poky-agl/3.0.0+snapshot/environment-setup-cortexa7hf-neon-vfpv4-agl-linux-gnueabi 
   2. Clone this repository: '$ cd ~; git clone https://github.com/pkeb/sdl_core'
      1. This repository is modified to compile for AGL from the mainline. 
   3. (will need to set git global username and email before this will work. Just attempt to clone this repository and git will error and it will tell you what to do, then rerun the command)
   4. Temporarily backup your /usr/local/lib and /usr/local/include folders: sudo mv /usr/local/lib /usr/local/lib_bak; sudo mv /usr/local/include /usr/local/include_bak; sudo mkdir -p /usr/local/lib; sudo mkdir -p /usr/local/include
   5. Create a folder for your build and run: cp ../run_cmake ./; ./run_cmake;
      make; make install 
   6. Copy the [your build folder]/bin folder to the target. This is the sdl core executable
   7. Copy the /usr/local/lib and /usr/local/include folders and contents to the target (Make sure they are placed in the same paths they were retrieved from. Some of the 3rd party libraries and headers install locally (log4cxx)). Delete your temporary /usr/local/lib and /usr/local/include directories and restore your backups.


5. Clone and build the bluez tools repository
   1. cd ~; git clone https://github.com/khvzak/bluez-tools.git 
   2. compile tools (make sure the sdk is sourced): cd ~/bluez-tools; ./autogen.sh; ./configure; make 
      1. Shouldn't need to 'make install'
   3. Copy the following programs to the target's /usr/local/bin folder (create one if it doesn't exist already) from the local src folder: cp bt-adapter, bt-agent, bt-device, bt-network, and bt-obex



## COMPILATION FOR X86_64 OR ARM/QNX
# Getting Started
A quick guide to installing, configuring, and running an instance of the SDL Core on a linux OS.

  1. Clone this repository
  2. Create a folder for your build and run `cmake ../sdl_core`
  3. If there are any dependency issues, install missing dependencies
  4. Run the following commands to compile and install smartdevicelink



```
%make
%make install
```

## Start SDL Core
Once SDL Core is compiled and installed you can start it from the executable in the bin folder

```
%cd bin/
%LD_LIBRARY_PATH=. ./smartDeviceLinkCore
```

## Start WEB HMI
Web HMI is separated from SDL Core and located in another repository. So to make it workable please do next steps.

  1. Clone http://github.com/smartdevicelink/sdl_hmi.git
  2. Follow the instruction from readme file in sdl_hmi repository.


## A quick note about dependencies
The dependencies for SDL Core vary based on the configuration. You can change SDL Core's configuration in the top level CMakeLists.txt. We have defaulted this file to a configuration which we believe is common for people who are interested in getting up and running quickly, generally on a Linux VM.

### Dependencies list

| Flag | Description | Dependencies |
|------|-------------|--------------|
|Web HMI|Use HTML5 HMI|chromium-browser|
|HMI2|Build with QT HMI|QT5, dbus-*dev|
|EXTENDED_MEDIA_MODE|Support Video and Audio Streaming|Opengl es2, gstreamer1.0*|
|Bluetooth|Enable bluetooth transport adapter|libbluetooth3, libbluetooth-dev, bluez-tools|
|Testing framework|Needed to support running unit tests|libgtest-dev|
|Cmake|Needed to configure SDL prior to compilation|cmake|

### Known Dependency Issues
  * log4cxx - We know that the version of log4cxx on a linux machine can conflict with the one used, which is why it is provided in the repository. To avoid the conflict, we recommend removing liblog4cxx*.
  * cmake - on some versions of linux, the included cmake package doesn't have the right version. If apt-get is your package manager, you can find the correct version using
```
sudo apt-get install cmake
sudo add-apt-repository ppa:kalakris/cmake
sudo apt-get update
sudo apt-get upgrade
```

## Required RPCs
There are several RPCs that are "required" to be implemented in order for SDL to work across vehicle manufacturers and applications, listed below.  The RPC specification can be found in the [Mobile API Spec](src/components/interfaces/MOBILE_API.xml).

  * RegisterAppInterface
  * UnregisterAppInterface
  * SetGlobalProperties
  * ResetGlobalProperties
  * AddCommand
  * DeleteCommand
  * AddSubMenu
  * DeleteSubMenu
  * CreateInteractionChoiceSet
  * PerformInteraction
  * DeleteInteractionChoiceSet
  * Alert
  * Show
  * SetMediaClockTimer
  * SubscribeButton
  * UnsubscribeButton
  * ChangeRegistration
  * GenericResponse
  * SystemRequest
  * OnHMIStatus
  * OnAppInterfaceUnregistered
  * OnButtonEvent
  * OnButtonPress
  * OnCommand
  * OnDriverDistraction
  * OnPermissionsChange
  * OnLanguageChange
  * OnSystemRequest
  * Speak

## App Launching

Below are instructions for testing app launching and query with a full system set up.

### SDL Server
The app querying specification defines an endpoint within Policies where sdl_core will reach out to receive a list of applications that can be launched. The SDL Server provides the back end functionality for app launching and querying.

You can find the SDL Server on [GitHub](https://github.com/smartdevicelink/sdl_server). The README contains detailed instructions for installing and launching the server. Launch the server on your local machine, and direct your browser to http://localhost:3000.

The [App Launching Server Specification](https://github.com/smartdevicelink/sdl_server/blob/master/docs/application_launching_v1.0.md) defines an endpoint `/applications/available/:moduleId.json` which return a list of applications available for launching to the handset for filtering.

To check if there is a module already available you can go to http://localhost:3000/modules.json. If there is a module available, there will be one or more objects in the response array. Keep this response, you'll need the "_id" field for later.

If there is not a module already available, go to http://localhost:3000/cars and define a new vehicle, then check http://localhost:3000/modules.json.

Next, you'll need to define applications that can be launched. Go to http://localhost:3000/apps and define some applications. Make sure that you define a url scheme under the iOS tab of the application. This is required for an application to be launched from SDL. A URL scheme has the format `someScheme://`. Save the URL Scheme you used for later steps.

You'll also need the local ip address of your machine

At the end of the SDL Server set up you should have
  1. SDL Server running on your local machine connected to mongo db
  2. Your machine's local IP Address
  3. The module id of your vehicle
  4. The URL Scheme of the app you want to launch

### Mobile
You need at least one app installed on the test device (presumably an iPhone), which we have built for you, the [V4Tester application](https://app.box.com/s/eeloquc0fhqfmxjjubw7kousf12f3pzg). This application implements SDL 4.0 and will respond to SDL Core's QUERY_APPS system request, as well as filter the response for available applications. If you do not have any other applications on the device, you can only test QUERY_APPS functionality, in which no applications will be sent to sdl core which can be launched.

In order to support the launching of an application, you'll have to create an additional app which responds to the URL Scheme of the application that you set up on the SDL Server. To do so, go to Xcode, select File>New>Project... and under ios/application create a Single View Application. Open the application's Info.plist file (under the Supporting Files section of the project explorer by default). Highlight the Information Property List item and click the plus button to add a new entry to the Property List. From the drop down menu, select URL Types as the key. In the Item 0 dictionary add a "URL Schemes" Array, and make Item 0 in the array the prefix to the URL you previously defined (So if you defined `someScheme://` then Item 0 should be "someScheme"). Make sure the URL identifier matches your application's identifier. When you're finished you should have something that looks like the following. Install this application on your test device. **Note** - this application will only launch during this process, since it is not SDL Connected it will not register with the head unit.

![Plist Example](http://i.imgur.com/AFyJlZQ.png)

At the end of the Mobile device set up you should have
  1. The V4 Tester Application installed on your device
  2. An application for launching that matches the application submitted to SDL Server
  3. Your iPhone should be on the same network as the machine running SDL Server

### SDL Core
Take the following steps to launch applications from sdl core.

  1. Install the [correct version of SDL Core](https://github.com/smartdevicelink/sdl_core/pull/39)
  2. Add the queryAppsUrl that you saved during sdl server set up in the src/appMain/preloaded_pt.json under the "endpoints" property in the format `http://[local machine ip]:3000/applications/available[moduleId].json`. For example `http://192.168.0.150:3000/applications/available/789b739c47c7490321058200.json`.
  3. Run SDL Core
  4. Launch the V4 Tester application on the iPhone
  5. Connect the application via wifi by entering the IP address of Core into the V4 tester
  6. Both applications should show up on the head unit for launching
  7. Select the other application, and you should see it launched and brought to the foreground on the phone

## Test Coverage
### Used technologies
  * GCOV - test coverage program.
  * LCOV - graphical front-end for GCC's coverage testing tool for gcov.
  * codecov.io - service for assembling code coverage and representing it in a clear for reading form.

### Excluded folders
_We test only sources written by us and we don`t need to test external sources(open source libraries)._
  * '/usr/\*' - local libraries shouldn`t be covered by tests.
  * '\*/test/\*' - we don`t need to cover tests.
  * '\*/src/3rd\*' - open source libraries shouldn`t be covered by tests.

### Current test coverage
You can find it in [Coverage report](https://codecov.io/gh/smartdevicelink/sdl_core/branch/develop)

### How to get Test Coverage locally
 1. Build project with enabled flag _-DBUILD_TESTS=on_
 2. Execute command 'make test'
 3. Execute './tools/Utils/collect_coverage.sh <path_to_build_directory>'

## Contributions

Conversation regarding the design and development of SmartDeviceLink technology should be directed at the [GENIVI mailing list](https://lists.genivi.org/mailman/listinfo/genivi-smartdevicelink), which anyone can join. Public conference calls regarding the SmartDeviceLink technology will be announced to the GENIVI mailing list, we expect to have conversations every other week. We also encourage interested parties to write issues against our software, and submit pull requests right here in the GitHub repository.
