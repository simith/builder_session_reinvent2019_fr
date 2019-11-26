# Install script for directory: /Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/demos

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/demos/ble/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/demos/dev_mode_key_provisioning/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/demos/mqtt/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/demos/ota/cmake_install.cmake")

endif()

