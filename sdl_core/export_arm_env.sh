#!/bin/bash 

export CMAKE_SYSROOT="/opt/poky-agl/3.0.0+snapshot/sysroots/cortexa7hf-neon-vfpv4-agl-linux-gnueabi/"
export CFLAGS='-mfloat-abi=hard'
export CXXFLAGS='-mfloat-abi=hard'
export LDFLAGS=" -L$CMAKE_SYSROOT/usr/lib/ -L$CMAKE_SYSROOT/lib/"
LD_LIBRARY_PATH="$CMAKE_SYSROOT/usr/lib:$CMAKE_SYSROOT/lib:"$LD_LIBRARY_PATH
export LD_LIBRARY_PATH
