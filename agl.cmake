INCLUDE(CMakeForceCompiler)

set(CMAKE_SYSTEM_NAME "Linux")
set(CROSS_TARGET "AGL")


set(TOOL_ROOT /opt/poky-agl/3.0.0+snapshot/sysroots/x86_64-aglsdk-linux)
set(CMAKE_SYSROOT /opt/poky-agl/3.0.0+snapshot/sysroots/cortexa7hf-neon-vfpv4-agl-linux-gnueabi)
set(CMAKE_SYSTEM_PROCESSOR arm)

CMAKE_FORCE_C_COMPILER( ${TOOL_ROOT}/usr/bin/arm-agl-linux-gnueabi/arm-agl-linux-gnueabi-gcc GNU )
CMAKE_FORCE_CXX_COMPILER( ${TOOL_ROOT}/usr/bin/arm-agl-linux-gnueabi/arm-agl-linux-gnueabi-g++ GNU )
#set( CMAKE_C_COMPILER ${TOOL_ROOT}/usr/bin/arm-agl-linux-gnueabi/arm-agl-linux-gnueabi-gcc CACHE PATH "")
#set( CMAKE_CXX_COMPILER ${TOOL_ROOT}/usr/bin/arm-agl-linux-gnueabi/arm-agl-linux-gnueabi-g++ CACHE PATH "")

#set( CMAKE_ ${TOOL_ROOT}/usr/bin/arm-agl-linux-gnueabi/arm-agl-linux-gnueabi )
set( CMAKE_AR ${TOOL_ROOT}/usr/bin/arm-agl-linux-gnueabi/arm-agl-linux-gnueabi-ar CACHE PATH "")
set( CMAKE_RANLIB ${TOOL_ROOT}/usr/bin/arm-agl-linux-gnueabi/arm-agl-linux-gnueabi-ranlib CACHE PATH "")
set( CMAKE_NM ${TOOL_ROOT}/usr/bin/arm-agl-linux-gnueabi/arm-agl-linux-gnueabi-nm CACHE PATH "")
set( CMAKE_OBJCOPY ${TOOL_ROOT}/usr/bin/arm-agl-linux-gnueabi/arm-agl-linux-gnueabi-objcopy CACHE PATH "")
set( CMAKE_OBJDUMP ${TOOL_ROOT}/usr/bin/arm-agl-linux-gnueabi/arm-agl-linux-gnueabi-objdump CACHE PATH "")
set( CMAKE_LINKER ${TOOL_ROOT}/usr/bin/arm-agl-linux-gnueabi/arm-agl-linux-gnueabi-ld CACHE PATH "AGL linker")
#set( CMAKE_CXX_LINK_EXECUTABLE ${CMAKE_LINKER} )
set( CMAKE_STRIP ${TOOL_ROOT}/usr/bin/arm-agl-linux-gnueabi/arm-agl-linux-gnueabi-strip CACHE PATH "")

#set( CMAKE_C_FLAGS "-mfloat-abi=hard" CACHE STRING "" FORCE )
#set( CMAKE_CXX_FLAGS "-mfloat-abi=hard" CACHE STRING "" FORCE )
#set(CMAKE_C_FLAGS " --sysroot=/opt/poky-agl/3.0.0+snapshot/sysroots/cortexa7hf-neon-vfpv4-agl-linux-gnueabi -march=armv7ve -marm -mfpu=neon-vfpv4 -mfloat-abi=hard -mcpu=cortex-a7 -fPIC" CACHE STRING "text" FORCE)
#set(CMAKE_CXX_FLAGS " --sysroot=/opt/poky-agl/3.0.0+snapshot/sysroots/cortexa7hf-neon-vfpv4-agl-linux-gnueabi -march=armv7ve -marm -mfpu=neon-vfpv4 -mfloat-abi=hard -mcpu=cortex-a7" CACHE STRING "text" FORCE)
set(CMAKE_CROSSCOMPILING 1)

set(3RD_PARTY_INSTALL_PREFIX_ARCH ${CMAKE_SYSROOT})

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)  
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
