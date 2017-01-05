# razor-de: Configure libudev environment
#
# UDEV_FOUND - system has a libudev
# UDEV_INCLUDE_DIR - where to find header files
# UDEV_LIBRARIES - the libraries to link against udev
# UDEV_STABLE - it's true when is the version greater or equals to 143 - version when the libudev was stabilized in its API
#
# copyright (c) 2011 Petr Vanek <petr@scribus.info>
# Redistribution and use is allowed according to the terms of the BSD license.
#

# the find functions aren't working for some reasion so setting manually
set(UDEV_INCLUDE_DIR ${CMAKE_SYSROOT}/usr/include)
set(UDEV_LIBRARIES ${CMAKE_SYSROOT}/usr/lib/libudev.so)
#message(TESTSFSDFSDFJLKFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
#message("UDEV_INCLUDE_DIR:" ${UDEV_INCLUDE_DIR})
#message("UDEV_LIBRARIES:"${UDEV_LIBRARIES})
#message("UDEV_PATH_INCLUDES:"${UDEV_PATH_INCLUDES})
#message("UDEV_PATH_LIB:"${UDEV_PATH_LIB})
#message("LIB_SUFFIX:"${LIB_SUFFIX})
#message("$CMAKE_SYSROOT/usr/lib$LIB_SUFFIX:"${CMAKE_SYSROOT}/usr/lib${LIB_SUFFIX})
FIND_PATH(
    UDEV_INCLUDE_DIR
    libudev.h
    ${CMAKE_SYSROOT}/usr/include
    ${CMAKE_SYSROOT}/usr/local/include
    ${UDEV_PATH_INCLUDES}
)

FIND_LIBRARY(
    UDEV_LIBRARIES
    NAMES udev libudev
    PATHS
        ${CMAKE_SYSROOT}/usr/lib${LIB_SUFFIX}
        ${CMAKE_SYSROOT}/usr/local/lib${LIB_SUFFIX}
        ${UDEV_PATH_LIB}
)

IF (UDEV_LIBRARIES AND UDEV_INCLUDE_DIR)
    SET(UDEV_FOUND "YES")
    execute_process(COMMAND pkg-config --atleast-version=143 libudev RESULT_VARIABLE UDEV_STABLE)
    # retvale is 0 of the condition is "true" so we need to negate the value...
    if (UDEV_STABLE)
set(UDEV_STABLE 0)
    else (UDEV_STABLE)
set(UDEV_STABLE 1)
    endif (UDEV_STABLE)
    message(STATUS "libudev stable: ${UDEV_STABLE}")
ENDIF (UDEV_LIBRARIES AND UDEV_INCLUDE_DIR)

IF (UDEV_FOUND)
    MESSAGE(STATUS "Found UDev: ${UDEV_LIBRARIES}")
    MESSAGE(STATUS " include: ${UDEV_INCLUDE_DIR}")
ELSE (UDEV_FOUND)
    MESSAGE(STATUS "UDev not found.")
    MESSAGE(STATUS "UDev: You can specify includes: -DUDEV_PATH_INCLUDES=/opt/udev/include")
    MESSAGE(STATUS " currently found includes: ${UDEV_INCLUDE_DIR}")
    MESSAGE(STATUS "UDev: You can specify libs: -DUDEV_PATH_LIB=/opt/udev/lib")
    MESSAGE(STATUS " currently found libs: ${UDEV_LIBRARIES}")
    IF (UDev_FIND_REQUIRED)
        MESSAGE(FATAL_ERROR "Could not find UDev library")
    ENDIF (UDev_FIND_REQUIRED)
ENDIF (UDEV_FOUND)
