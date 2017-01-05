# Copyright (c) 2014, Ford Motor Company
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following
# disclaimer in the documentation and/or other materials provided with the
# distribution.
#
# Neither the name of the Ford Motor Company nor the names of its contributors
# may be used to endorse or promote products derived from this software
# without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

set(APR_UTIL_SOURCE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../apr-util-1.5.3)
set(APR_UTIL_BUILD_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/../apr-util-build)

set(APR_UTIL_LIBS_DIRECTORY ${APR_UTIL_BUILD_DIRECTORY}/.libs)

file(MAKE_DIRECTORY
  ${APR_UTIL_BUILD_DIRECTORY}
)

set(EXPAT_SOURCE_DIRECTORY ${APR_UTIL_SOURCE_DIRECTORY}/../expat-2.1.0)
set(EXPAT_BUILD_DIRECTORY ${APR_UTIL_BUILD_DIRECTORY}/../expat-2.1.0)

set(COMMON_CONFIGURE_FLAGS
  "--with-apr=../apr-build"
  "--with-expat-source=${EXPAT_SOURCE_DIRECTORY}"
  "--with-expat-build=${EXPAT_BUILD_DIRECTORY}"
)

     #"--target=arm-agl-linux-gnueabi --host=arm-agl-linux-gnueabi --build=x86_64-linux --with-libtool-sysroot=/opt/poky-agl/3.0.0+snapshot/sysroots/cortexa7hf-neon-vfpv4-agl-linux-gnueabi "
if(CMAKE_SYSTEM_NAME STREQUAL "QNX")
  set(CONFIGURE_FLAGS "--host=${CMAKE_SYSTEM_PROCESSOR}-nto-qnx" ${COMMON_CONFIGURE_FLAGS})
else()
     #$ENV{CONFIGURE_FLAGS}
  set(CONFIGURE_FLAGS 
    "--host=arm-agl-linux-gnueabi"
     ${COMMON_CONFIGURE_FLAGS}
     )
    #"--target=arm-agl-linux-gnueabi"
    #"--build=x86_64-linux"
    #"-with-libtool-sysroot=/opt/poky-agl/3.0.0+snapshot/sysroots/cortexa7hf-neon-vfpv4-agl-linux-gnueabi"
    #"CFLAGS= --sysroot=/opt/poky-agl/3.0.0+snapshot/sysroots/cortexa7hf-neon-vfpv4-agl-linux-gnueabi -march=armv7ve -marm -mfpu=neon-vfpv4 -mfloat-abi=hard -mcpu=cortex-a7 --sysroot=/opt/poky-agl/3.0.0+snapshot/sysroots/cortexa7hf-neon-vfpv4-agl-linux-gnueabi -O2 -pipe -g -feliminate-unused-debug-types "
    #"LDFLAGS= -L${CMAKE_SYSROOT}/usr/lib/ -L${CMAKE_SYSROOT}/lib/ -I${CMAKE_SYSROOT}/usr/include --sysroot=/opt/poky-agl/3.0.0+snapshot/sysroots/cortexa7hf-neon-vfpv4-agl-linux-gnueabi -Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed "
endif()


add_custom_command(OUTPUT ${APR_UTIL_BUILD_DIRECTORY}/Makefile
   #COMMAND CC=${CMAKE_C_COMPILER} ${APR_UTIL_SOURCE_DIRECTORY}/configure ${CONFIGURE_FLAGS}
   COMMAND ${APR_UTIL_SOURCE_DIRECTORY}/configure ${CONFIGURE_FLAGS}
  DEPENDS libapr-1
  DEPENDS expat
  WORKING_DIRECTORY ${APR_UTIL_BUILD_DIRECTORY}
)

add_custom_target(apr-util ALL make
  DEPENDS ${APR_UTIL_BUILD_DIRECTORY}/Makefile
  WORKING_DIRECTORY ${APR_UTIL_BUILD_DIRECTORY}
)

install(
  DIRECTORY ${APR_UTIL_LIBS_DIRECTORY}/
  DESTINATION ${3RD_PARTY_INSTALL_PREFIX_ARCH}/lib
  USE_SOURCE_PERMISSIONS
  FILES_MATCHING PATTERN libaprutil-1.so*
)
