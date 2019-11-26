# Install script for directory: /Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/libraries

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
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/c_sdk/standard/ble/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/c_sdk/standard/common/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/c_sdk/standard/https/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/c_sdk/standard/mqtt/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/c_sdk/standard/serializer/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/freertos_plus/aws/greengrass/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/freertos_plus/aws/ota/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/freertos_plus/standard/crypto/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/freertos_plus/standard/freertos_plus_tcp/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/freertos_plus/standard/pkcs11/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/freertos_plus/standard/tls/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/freertos_plus/standard/utils/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/abstractions/ble_hal/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/abstractions/pkcs11/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/abstractions/platform/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/abstractions/secure_sockets/cmake_install.cmake")
  include("/Users/simithn/Development/reinvent2019/20-11-2019/builder_session_reinvent2019_fr/workshop/amazon-freertos/build/libraries/abstractions/wifi/cmake_install.cmake")

endif()

