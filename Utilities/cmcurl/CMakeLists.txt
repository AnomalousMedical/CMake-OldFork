# Set curl options as needed for CMake build
set(BUILD_CURL_EXE OFF CACHE INTERNAL "No curl exe")
set(BUILD_CURL_TESTS OFF CACHE INTERNAL "No curl tests")
set(BUILD_DASHBOARD_REPORTS OFF CACHE INTERNAL "No curl dashboard reports")
set(BUILD_RELEASE_DEBUG_DIRS OFF CACHE INTERNAL "No curl release/debug dirs")
set(CMAKE_USE_LIBSSH2 OFF CACHE INTERNAL "Disable curl libssh2")
set(CMAKE_USE_OPENLDAP OFF CACHE INTERNAL "No curl OpenLDAP")
set(CURL_DISABLE_COOKIES OFF CACHE INTERNAL "Do not disable curl cookie support")
set(CURL_DISABLE_CRYPTO_AUTH OFF CACHE INTERNAL "Do not disable curl crypto auth")
set(CURL_DISABLE_DICT ON CACHE INTERNAL "Disable curl dict protocol?")
set(CURL_DISABLE_FILE OFF CACHE INTERNAL "Disable curl file protocol?")
set(CURL_DISABLE_FTP OFF CACHE INTERNAL "Disable curl ftp protocol?")
set(CURL_DISABLE_GOPHER ON CACHE INTERNAL "Disable curl gopher protocol?")
set(CURL_DISABLE_HTTP OFF CACHE INTERNAL "Disable curl http protocol?")
set(CURL_DISABLE_IMAP ON CACHE INTERNAL "Disable curl imap protocol?")
set(CURL_DISABLE_LDAP ON CACHE INTERNAL "Disable curl ldap protocol?")
set(CURL_DISABLE_LDAPS ON CACHE INTERNAL "Disable curl ldaps protocol?")
set(CURL_DISABLE_POP3 ON CACHE INTERNAL "Disable curl pop3 protocol?")
set(CURL_DISABLE_RTSP ON CACHE INTERNAL "Disable curl rtsp protocol?")
set(CURL_DISABLE_SMTP ON CACHE INTERNAL "Disable curl smtp protocol?")
set(CURL_DISABLE_TELNET ON CACHE INTERNAL "Disable curl telnet protocol?")
set(CURL_DISABLE_TFTP ON CACHE INTERNAL "Disable curl tftp protocol?")
set(CURL_DISABLE_VERBOSE_STRING OFF CACHE INTERNAL "Do not disable curl verbosity")
set(CURL_HIDDEN_SYMBOLS OFF CACHE INTERNAL "No curl hidden symbols")
set(CURL_LDAP_WIN OFF CACHE INTERNAL "No curl Windows LDAP")
set(CURL_STATICLIB ON CACHE INTERNAL "Static curl")
set(CURL_USE_ARES OFF CACHE INTERNAL "No curl c-ares support")
set(DISABLED_THREADSAFE OFF CACHE INTERNAL "Curl can use thread-safe functions")
set(ENABLE_IPV6 OFF CACHE INTERNAL "Curl IPv6 support")
set(HTTP_ONLY OFF CACHE INTERNAL "Curl is not http-only")

# Windows Vista and above have inet_pton, but this will link on
# older versions and then the executable will fail to launch at
# runtime on older versions because no DLL provides the symbol.
if(WIN32)
  set(HAVE_INET_PTON 0 CACHE INTERNAL "Do not use inet_pton")
endif()

# Disable warnings to avoid changing 3rd party code.
if(CMAKE_C_COMPILER_ID MATCHES
    "^(GNU|Clang|AppleClang|XL|VisualAge|SunPro|MIPSpro|HP|Intel)$")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w")
elseif(CMAKE_C_COMPILER_ID STREQUAL "PathScale")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -woffall")
endif()

#***************************************************************************
#                                  _   _ ____  _
#  Project                     ___| | | |  _ \| |
#                             / __| | | | |_) | |
#                            | (__| |_| |  _ <| |___
#                             \___|\___/|_| \_\_____|
#
# Copyright (C) 1998 - 2014, Daniel Stenberg, <daniel@haxx.se>, et al.
#
# This software is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at http://curl.haxx.se/docs/copyright.html.
#
# You may opt to use, copy, modify, merge, publish, distribute and/or sell
# copies of the Software, and permit persons to whom the Software is
# furnished to do so, under the terms of the COPYING file.
#
# This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
# KIND, either express or implied.
#
###########################################################################
# cURL/libcurl CMake script
# by Tetetest and Sukender (Benoit Neil)

# TODO:
# The output .so file lacks the soname number which we currently have within the lib/Makefile.am file
# Add full (4 or 5 libs) SSL support
# Add INSTALL target (EXTRA_DIST variables in Makefile.am may be moved to Makefile.inc so that CMake/CPack is aware of what's to include).
# Add CTests(?)
# Check on all possible platforms
# Test with as many configurations possible (With or without any option)
# Create scripts that help keeping the CMake build system up to date (to reduce maintenance). According to Tetetest:
#  - lists of headers that 'configure' checks for;
#  - curl-specific tests (the ones that are in m4/curl-*.m4 files);
#  - (most obvious thing:) curl version numbers.
# Add documentation subproject
#
# To check:
# (From Daniel Stenberg) The cmake build selected to run gcc with -fPIC on my box while the plain configure script did not.
# (From Daniel Stenberg) The gcc command line use neither -g nor any -O options. As a developer, I also treasure our configure scripts's --enable-debug option that sets a long range of "picky" compiler options.
cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake;${CMAKE_MODULE_PATH}")
include(Utilities)
include(Macros)

project( CURL C )

if(0) # This code not needed for building within CMake.
message(WARNING "the curl cmake build system is poorly maintained. Be aware")
endif()

file (READ ${CURL_SOURCE_DIR}/include/curl/curlver.h CURL_VERSION_H_CONTENTS)
string (REGEX MATCH "LIBCURL_VERSION_MAJOR[ \t]+([0-9]+)"
  LIBCURL_VERSION_MJ ${CURL_VERSION_H_CONTENTS})
string (REGEX MATCH "([0-9]+)"
  LIBCURL_VERSION_MJ ${LIBCURL_VERSION_MJ})
string (REGEX MATCH
  "LIBCURL_VERSION_MINOR[ \t]+([0-9]+)"
  LIBCURL_VERSION_MI ${CURL_VERSION_H_CONTENTS})
string (REGEX MATCH "([0-9]+)" LIBCURL_VERSION_MI ${LIBCURL_VERSION_MI})
string (REGEX MATCH
  "LIBCURL_VERSION_PATCH[ \t]+([0-9]+)"
  LIBCURL_VERSION_PT ${CURL_VERSION_H_CONTENTS})
string (REGEX MATCH "([0-9]+)" LIBCURL_VERSION_PT ${LIBCURL_VERSION_PT})
set (CURL_MAJOR_VERSION ${LIBCURL_VERSION_MJ})
set (CURL_MINOR_VERSION ${LIBCURL_VERSION_MI})
set (CURL_PATCH_VERSION ${LIBCURL_VERSION_PT})

include_regular_expression("^.*$")    # Sukender: Is it necessary?

# Setup package meta-data
# SET(PACKAGE "curl")
set(CURL_VERSION ${CURL_MAJOR_VERSION}.${CURL_MINOR_VERSION}.${CURL_PATCH_VERSION})
if(0) # This code not needed for building within CMake.
message(STATUS "curl version=[${CURL_VERSION}]")
endif()
# SET(PACKAGE_TARNAME "curl")
# SET(PACKAGE_NAME "curl")
# SET(PACKAGE_VERSION "-")
# SET(PACKAGE_STRING "curl-")
# SET(PACKAGE_BUGREPORT "a suitable curl mailing list => http://curl.haxx.se/mail/")
set(OPERATING_SYSTEM "${CMAKE_SYSTEM_NAME}")
set(OS "\"${CMAKE_SYSTEM_NAME}\"")

include_directories(${PROJECT_BINARY_DIR}/include/curl)
include_directories( ${CURL_SOURCE_DIR}/include )

option(BUILD_CURL_EXE "Set to ON to build cURL executable." ON)
option(BUILD_CURL_TESTS "Set to ON to build cURL tests." ON)
option(CURL_STATICLIB "Set to ON to build libcurl with static linking." OFF)
option(CURL_USE_ARES "Set to ON to enable c-ares support" OFF)
# initialize CURL_LIBS
set(CURL_LIBS "")

if(CURL_USE_ARES)
  set(USE_ARES ${CURL_USE_ARES})
  find_package(CARES REQUIRED)
  list(APPEND CURL_LIBS ${CARES_LIBRARY} )
  set(CURL_LIBS ${CURL_LIBS} ${CARES_LIBRARY})
endif()

option(BUILD_DASHBOARD_REPORTS "Set to ON to activate reporting of cURL builds here http://www.cdash.org/CDashPublic/index.php?project=CURL" OFF)
if(BUILD_DASHBOARD_REPORTS)
  #INCLUDE(Dart)
  include(CTest)
endif(BUILD_DASHBOARD_REPORTS)

if(MSVC)
  option(BUILD_RELEASE_DEBUG_DIRS "Set OFF to build each configuration to a separate directory" OFF)
  mark_as_advanced(BUILD_RELEASE_DEBUG_DIRS)
endif()

option(CURL_HIDDEN_SYMBOLS "Set to ON to hide libcurl internal symbols (=hide all symbols that aren't officially external)." ON)
mark_as_advanced(CURL_HIDDEN_SYMBOLS)

# IF(WIN32)
# OPTION(CURL_WINDOWS_SSPI "Use windows libraries to allow NTLM authentication without openssl" ON)
# MARK_AS_ADVANCED(CURL_WINDOWS_SSPI)
# ENDIF()

option(HTTP_ONLY "disables all protocols except HTTP (This overrides all CURL_DISABLE_* options)" OFF)
mark_as_advanced(HTTP_ONLY)
option(CURL_DISABLE_FTP "disables FTP" OFF)
mark_as_advanced(CURL_DISABLE_FTP)
option(CURL_DISABLE_LDAP "disables LDAP" OFF)
mark_as_advanced(CURL_DISABLE_LDAP)
option(CURL_DISABLE_TELNET "disables Telnet" OFF)
mark_as_advanced(CURL_DISABLE_TELNET)
option(CURL_DISABLE_DICT "disables DICT" OFF)
mark_as_advanced(CURL_DISABLE_DICT)
option(CURL_DISABLE_FILE "disables FILE" OFF)
mark_as_advanced(CURL_DISABLE_FILE)
option(CURL_DISABLE_TFTP "disables TFTP" OFF)
mark_as_advanced(CURL_DISABLE_TFTP)
option(CURL_DISABLE_HTTP "disables HTTP" OFF)
mark_as_advanced(CURL_DISABLE_HTTP)

option(CURL_DISABLE_LDAPS "to disable LDAPS" OFF)
mark_as_advanced(CURL_DISABLE_LDAPS)

option(CURL_DISABLE_RTSP "to disable RTSP" OFF)
mark_as_advanced(CURL_DISABLE_RTSP)
option(CURL_DISABLE_PROXY "to disable proxy" OFF)
mark_as_advanced(CURL_DISABLE_PROXY)
option(CURL_DISABLE_POP3 "to disable POP3" OFF)
mark_as_advanced(CURL_DISABLE_POP3)
option(CURL_DISABLE_IMAP "to disable IMAP" OFF)
mark_as_advanced(CURL_DISABLE_IMAP)
option(CURL_DISABLE_SMTP "to disable SMTP" OFF)
mark_as_advanced(CURL_DISABLE_SMTP)
option(CURL_DISABLE_GOPHER "to disable Gopher" OFF)
mark_as_advanced(CURL_DISABLE_GOPHER)

if(HTTP_ONLY)
  set(CURL_DISABLE_FTP ON)
  set(CURL_DISABLE_LDAP ON)
  set(CURL_DISABLE_LDAPS ON)
  set(CURL_DISABLE_TELNET ON)
  set(CURL_DISABLE_DICT ON)
  set(CURL_DISABLE_FILE ON)
  set(CURL_DISABLE_TFTP ON)
  set(CURL_DISABLE_RTSP ON)
  set(CURL_DISABLE_POP3 ON)
  set(CURL_DISABLE_IMAP ON)
  set(CURL_DISABLE_SMTP ON)
  set(CURL_DISABLE_GOPHER ON)
endif()

option(CURL_DISABLE_COOKIES "to disable cookies support" OFF)
mark_as_advanced(CURL_DISABLE_COOKIES)

option(CURL_DISABLE_CRYPTO_AUTH "to disable cryptographic authentication" OFF)
mark_as_advanced(CURL_DISABLE_CRYPTO_AUTH)
option(CURL_DISABLE_VERBOSE_STRINGS "to disable verbose strings" OFF)
mark_as_advanced(CURL_DISABLE_VERBOSE_STRINGS)
option(DISABLED_THREADSAFE "Set to explicitly specify we don't want to use thread-safe functions" OFF)
mark_as_advanced(DISABLED_THREADSAFE)
option(ENABLE_IPV6 "Define if you want to enable IPv6 support" OFF)
mark_as_advanced(ENABLE_IPV6)


# We need ansi c-flags, especially on HP
set(CMAKE_C_FLAGS "${CMAKE_ANSI_CFLAGS} ${CMAKE_C_FLAGS}")
set(CMAKE_REQUIRED_FLAGS ${CMAKE_ANSI_CFLAGS})

# Disable warnings on Borland to avoid changing 3rd party code.
if(BORLAND)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -w-")
endif(BORLAND)

# If we are on AIX, do the _ALL_SOURCE magic
if(${CMAKE_SYSTEM_NAME} MATCHES AIX)
  set(_ALL_SOURCE 1)
endif(${CMAKE_SYSTEM_NAME} MATCHES AIX)

# Include all the necessary files for macros
include (CheckFunctionExists)
include (CheckIncludeFile)
include (CheckIncludeFiles)
include (CheckLibraryExists)
include (CheckSymbolExists)
include (CheckTypeSize)
include (CheckCSourceCompiles)

# On windows preload settings
if(WIN32)
  include(${CMAKE_CURRENT_SOURCE_DIR}/CMake/Platforms/WindowsCache.cmake)
endif(WIN32)

# Check for all needed libraries
if(0) # This code not needed for building within CMake.
check_library_exists_concat("dl"     dlopen       HAVE_LIBDL)
else()
  # Use the cmake-defined dl libs as dl is should not be used
  # on HPUX, but rather dld this avoids a warning
  list(APPEND CURL_LIBS ${CMAKE_DL_LIBS})
endif()
check_library_exists_concat("socket" connect      HAVE_LIBSOCKET)
check_library_exists("c" gethostbyname "" NOT_NEED_LIBNSL)

# Yellowtab Zeta needs different libraries than BeOS 5.
if(BEOS)
  set(NOT_NEED_LIBNSL 1)
  check_library_exists_concat("bind" gethostbyname HAVE_LIBBIND)
  check_library_exists_concat("bnetapi" closesocket HAVE_LIBBNETAPI)
endif(BEOS)

check_library_exists_concat("network" recv HAVE_LIBNETWORK)

if(NOT NOT_NEED_LIBNSL)
  check_library_exists_concat("nsl"    gethostbyname  HAVE_LIBNSL)
endif(NOT NOT_NEED_LIBNSL)

if(WIN32)
  check_library_exists_concat("ws2_32" getch        HAVE_LIBWS2_32)
  check_library_exists_concat("winmm"  getch        HAVE_LIBWINMM)
endif()

if(NOT CURL_DISABLE_LDAP)

  if(WIN32)
    option(CURL_LDAP_WIN "Use Windows LDAP implementation" ON)
    if(CURL_LDAP_WIN)
      check_library_exists("wldap32" cldap_open "" HAVE_WLDAP32)
      if(NOT HAVE_WLDAP32)
        set(CURL_LDAP_WIN OFF)
      endif()
    endif()
  endif()

  option(CMAKE_USE_OPENLDAP "Use OpenLDAP code." OFF)
  mark_as_advanced(CMAKE_USE_OPENLDAP)
  set(CMAKE_LDAP_LIB "ldap" CACHE STRING "Name or full path to ldap library")
  set(CMAKE_LBER_LIB "lber" CACHE STRING "Name or full path to lber library")

  if(CMAKE_USE_OPENLDAP AND CURL_LDAP_WIN)
    message(FATAL_ERROR "Cannot use CURL_LDAP_WIN and CMAKE_USE_OPENLDAP at the same time")
  endif()
  
  # Now that we know, we're not using windows LDAP...
  if(NOT CURL_LDAP_WIN)
    # Check for LDAP
    check_library_exists_concat(${CMAKE_LDAP_LIB} ldap_init HAVE_LIBLDAP)
    check_library_exists_concat(${CMAKE_LBER_LIB} ber_init HAVE_LIBLBER)
  else()
    check_include_file_concat("winldap.h" HAVE_WINLDAP_H)
    check_include_file_concat("winber.h"  HAVE_WINBER_H)
  endif()
  
  set(CMAKE_LDAP_INCLUDE_DIR "" CACHE STRING "Path to LDAP include directory")
  if(CMAKE_LDAP_INCLUDE_DIR)
    set(CMAKE_REQUIRED_INCLUDES ${CMAKE_LDAP_INCLUDE_DIR})
  endif()
  check_include_file_concat("ldap.h"           HAVE_LDAP_H)
  check_include_file_concat("lber.h"           HAVE_LBER_H)

  if(NOT HAVE_LDAP_H)
    message(STATUS "LDAP_H not found CURL_DISABLE_LDAP set ON")
    set(CURL_DISABLE_LDAP ON CACHE BOOL "" FORCE)
  elseif(NOT HAVE_LIBLDAP)
    message(STATUS "LDAP library '${CMAKE_LDAP_LIB}' not found CURL_DISABLE_LDAP set ON")
    set(CURL_DISABLE_LDAP ON CACHE BOOL "" FORCE)
  else()
    if(CMAKE_USE_OPENLDAP)
      set(USE_OPENLDAP ON)
    endif()
    if(CMAKE_LDAP_INCLUDE_DIR)
      include_directories(${CMAKE_LDAP_INCLUDE_DIR})
    endif()
    set(NEED_LBER_H ON)
    set(_HEADER_LIST)
    if(HAVE_WINDOWS_H)
      list(APPEND _HEADER_LIST "windows.h")
    endif()
    if(HAVE_SYS_TYPES_H)
      list(APPEND _HEADER_LIST "sys/types.h")
    endif()
    list(APPEND _HEADER_LIST "ldap.h")

    set(_SRC_STRING "")
    foreach(_HEADER ${_HEADER_LIST})
      set(_INCLUDE_STRING "${_INCLUDE_STRING}#include <${_HEADER}>\n")
    endforeach()

    set(_SRC_STRING
      "
      ${_INCLUDE_STRING}
      int main(int argc, char ** argv)
      {
        BerValue *bvp = NULL;
        BerElement *bep = ber_init(bvp);
        ber_free(bep, 1);
        return 0;
      }"
    )
    set(CMAKE_REQUIRED_DEFINITIONS "-DLDAP_DEPRECATED=1" "-DWIN32_LEAN_AND_MEAN")
    set(CMAKE_REQUIRED_LIBRARIES ${CMAKE_LDAP_LIB})
    if(HAVE_LIBLBER)
      list(APPEND CMAKE_REQUIRED_LIBRARIES ${CMAKE_LBER_LIB})
    endif()
    check_c_source_compiles("${_SRC_STRING}" NOT_NEED_LBER_H)

    if(NOT_NEED_LBER_H)
      set(NEED_LBER_H OFF)
    else()
      set(CURL_TEST_DEFINES "${CURL_TEST_DEFINES} -DNEED_LBER_H")
    endif()
  endif()

endif()

# No ldap, no ldaps.
if(CURL_DISABLE_LDAP)
  if(NOT CURL_DISABLE_LDAPS)
    message(STATUS "LDAP needs to be enabled to support LDAPS")
    set(CURL_DISABLE_LDAPS ON CACHE BOOL "" FORCE)
  endif()
endif()

if(NOT CURL_DISABLE_LDAPS)
  check_include_file_concat("ldap_ssl.h" HAVE_LDAP_SSL_H)
  check_include_file_concat("ldapssl.h"  HAVE_LDAPSSL_H)
endif()

# Check for idn
check_library_exists_concat("idn" idna_to_ascii_lz HAVE_LIBIDN)

# Check for symbol dlopen (same as HAVE_LIBDL)
check_library_exists("${CURL_LIBS}" dlopen "" HAVE_DLOPEN)

# For other tests to use the same libraries
set(CMAKE_REQUIRED_LIBRARIES ${CURL_LIBS})

if(0) # This code not needed for building within CMake.
option(CURL_ZLIB "Set to ON to enable building cURL with zlib support." ON)
set(HAVE_LIBZ OFF)
set(HAVE_ZLIB_H OFF)
set(HAVE_ZLIB OFF)
if(CURL_ZLIB)
  find_package(ZLIB QUIET)
  if(ZLIB_FOUND)
    set(HAVE_ZLIB_H ON)
    set(HAVE_ZLIB ON)
    set(HAVE_LIBZ ON)
    list(APPEND CURL_LIBS ${ZLIB_LIBRARIES})
  endif()
endif()
endif()

#-----------------------------------------------------------------------------
# CMake-specific curl code.

if(CURL_SPECIAL_LIBZ)
  set(CURL_LIBS ${CURL_LIBS} "${CURL_SPECIAL_LIBZ}")
  include_directories(${CURL_SPECIAL_LIBZ_INCLUDES})
  set(HAVE_LIBZ 0)
  set(HAVE_ZLIB_H 0)
endif()

#-----------------------------------------------------------------------------

set(USE_SSLEAY OFF)
set(USE_OPENSSL OFF)
set(HAVE_LIBCRYPTO OFF)
set(HAVE_LIBSSL OFF)

if(CMAKE_USE_OPENSSL)
  find_package(OpenSSL)
  if(OPENSSL_FOUND)
    list(APPEND CURL_LIBS ${OPENSSL_LIBRARIES})
    set(USE_SSLEAY ON)
    set(USE_OPENSSL ON)
    set(HAVE_LIBCRYPTO ON)
    set(HAVE_LIBSSL ON)
    include_directories(${OPENSSL_INCLUDE_DIR})
    set(CMAKE_REQUIRED_INCLUDES ${OPENSSL_INCLUDE_DIR})
    check_include_file("openssl/crypto.h" HAVE_OPENSSL_CRYPTO_H)
    check_include_file("openssl/engine.h" HAVE_OPENSSL_ENGINE_H)
    check_include_file("openssl/err.h"    HAVE_OPENSSL_ERR_H)
    check_include_file("openssl/pem.h"    HAVE_OPENSSL_PEM_H)
    check_include_file("openssl/pkcs12.h" HAVE_OPENSSL_PKCS12_H)
    check_include_file("openssl/rsa.h"    HAVE_OPENSSL_RSA_H)
    check_include_file("openssl/ssl.h"    HAVE_OPENSSL_SSL_H)
    check_include_file("openssl/x509.h"   HAVE_OPENSSL_X509_H)
    check_include_file("openssl/rand.h"   HAVE_OPENSSL_RAND_H)

    # Optionally build with a specific CA cert bundle.
    if(CURL_CA_BUNDLE)
      add_definitions(-DCURL_CA_BUNDLE="${CURL_CA_BUNDLE}")
    endif()
    # Optionally build with a specific CA cert dir.
    if(CURL_CA_PATH)
      add_definitions(-DCURL_CA_PATH="${CURL_CA_PATH}")
    endif()
  endif(OPENSSL_FOUND)
elseif(WIN32)
  # Use Windows SSL/TLS native implementation.
  add_definitions(-DUSE_SCHANNEL)
  set(USE_WINDOWS_SSPI 1)
elseif(APPLE)
  # Use OS X SSL/TLS native implementation if available on target version.
  if(CMAKE_OSX_DEPLOYMENT_TARGET)
    set(OSX_VERSION ${CMAKE_OSX_DEPLOYMENT_TARGET})
  else()
    execute_process(
      COMMAND sw_vers -productVersion
      OUTPUT_VARIABLE OSX_VERSION
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )
  endif()
  if(NOT OSX_VERSION VERSION_LESS 10.6 AND
     CMAKE_C_COMPILER_ID MATCHES "GNU|Clang|AppleClang")
    add_definitions(-DUSE_DARWINSSL)
    list(APPEND CURL_LIBS
      "-framework CoreFoundation"
      "-framework Security"
      )
  endif()
endif()

#libSSH2
option(CMAKE_USE_LIBSSH2 "Use libSSH2" ON)
mark_as_advanced(CMAKE_USE_LIBSSH2)
set(USE_LIBSSH2 OFF)
set(HAVE_LIBSSH2 OFF)
set(HAVE_LIBSSH2_H OFF)

if(CMAKE_USE_LIBSSH2)
  find_package(LibSSH2)
  if(LIBSSH2_FOUND)
    list(APPEND CURL_LIBS ${LIBSSH2_LIBRARY})
    set(CMAKE_REQUIRED_LIBRARIES ${LIBSSH2_LIBRARY})
    set(CMAKE_REQUIRED_INCLUDES "${LIBSSH2_INCLUDE_DIR}")
    set(HAVE_LIBSSH2 ON)
    set(USE_LIBSSH2 ON)

    # find_package has already found the headers
    set(HAVE_LIBSSH2_H ON)
    set(CURL_INCLUDES ${CURL_INCLUDES} "${LIBSSH2_INCLUDE_DIR}/libssh2.h")
    set(CURL_TEST_DEFINES "${CURL_TEST_DEFINES} -DHAVE_LIBSSH2_H")

    # now check for specific libssh2 symbols as they were added in different versions
    set(CMAKE_EXTRA_INCLUDE_FILES "libssh2.h")
    check_function_exists(libssh2_version           HAVE_LIBSSH2_VERSION)
    check_function_exists(libssh2_init              HAVE_LIBSSH2_INIT)
    check_function_exists(libssh2_exit              HAVE_LIBSSH2_EXIT)
    check_function_exists(libssh2_scp_send64        HAVE_LIBSSH2_SCP_SEND64)
    check_function_exists(libssh2_session_handshake HAVE_LIBSSH2_SESSION_HANDSHAKE)
    set(CMAKE_EXTRA_INCLUDE_FILES "")

  endif(LIBSSH2_FOUND)
endif(CMAKE_USE_LIBSSH2)

# If we have features.h, then do the _BSD_SOURCE magic
check_include_file("features.h"       HAVE_FEATURES_H)

# Check for header files
if(NOT UNIX)
  check_include_file_concat("ws2tcpip.h"     HAVE_WS2TCPIP_H)
  check_include_file_concat("winsock2.h"     HAVE_WINSOCK2_H)
else()
  set(HAVE_WS2TCPIP_H 0)
  set(HAVE_WINSOCK2_H 0)
endif()
check_include_file_concat("stdio.h"          HAVE_STDIO_H)
if(NOT UNIX)
  check_include_file_concat("windows.h"      HAVE_WINDOWS_H)
  check_include_file_concat("winsock.h"      HAVE_WINSOCK_H)
else()
  set(HAVE_WINDOWS_H 0)
  set(HAVE_WINSOCK_H 0)
endif()

check_include_file_concat("inttypes.h"       HAVE_INTTYPES_H)
check_include_file_concat("sys/filio.h"      HAVE_SYS_FILIO_H)
check_include_file_concat("sys/ioctl.h"      HAVE_SYS_IOCTL_H)
check_include_file_concat("sys/param.h"      HAVE_SYS_PARAM_H)
check_include_file_concat("sys/poll.h"       HAVE_SYS_POLL_H)
check_include_file_concat("sys/resource.h"   HAVE_SYS_RESOURCE_H)
check_include_file_concat("sys/select.h"     HAVE_SYS_SELECT_H)
check_include_file_concat("sys/socket.h"     HAVE_SYS_SOCKET_H)
check_include_file_concat("sys/sockio.h"     HAVE_SYS_SOCKIO_H)
check_include_file_concat("sys/stat.h"       HAVE_SYS_STAT_H)
check_include_file_concat("sys/time.h"       HAVE_SYS_TIME_H)
check_include_file_concat("sys/types.h"      HAVE_SYS_TYPES_H)
check_include_file_concat("sys/uio.h"        HAVE_SYS_UIO_H)
check_include_file_concat("sys/un.h"         HAVE_SYS_UN_H)
check_include_file_concat("sys/utime.h"      HAVE_SYS_UTIME_H)
check_include_file_concat("alloca.h"         HAVE_ALLOCA_H)
check_include_file_concat("arpa/inet.h"      HAVE_ARPA_INET_H)
check_include_file_concat("arpa/tftp.h"      HAVE_ARPA_TFTP_H)
check_include_file_concat("assert.h"         HAVE_ASSERT_H)
check_include_file_concat("crypto.h"         HAVE_CRYPTO_H)
check_include_file_concat("des.h"            HAVE_DES_H)
check_include_file_concat("err.h"            HAVE_ERR_H)
check_include_file_concat("errno.h"          HAVE_ERRNO_H)
check_include_file_concat("fcntl.h"          HAVE_FCNTL_H)
check_include_file_concat("gssapi/gssapi.h"  HAVE_GSSAPI_GSSAPI_H)
check_include_file_concat("gssapi/gssapi_generic.h" HAVE_GSSAPI_GSSAPI_GENERIC_H)
check_include_file_concat("gssapi/gssapi_krb5.h" HAVE_GSSAPI_GSSAPI_KRB5_H)
check_include_file_concat("idn-free.h"       HAVE_IDN_FREE_H)
check_include_file_concat("ifaddrs.h"        HAVE_IFADDRS_H)
check_include_file_concat("io.h"             HAVE_IO_H)
check_include_file_concat("krb.h"            HAVE_KRB_H)
check_include_file_concat("libgen.h"         HAVE_LIBGEN_H)
check_include_file_concat("limits.h"         HAVE_LIMITS_H)
check_include_file_concat("locale.h"         HAVE_LOCALE_H)
check_include_file_concat("net/if.h"         HAVE_NET_IF_H)
check_include_file_concat("netdb.h"          HAVE_NETDB_H)
check_include_file_concat("netinet/in.h"     HAVE_NETINET_IN_H)
check_include_file_concat("netinet/tcp.h"    HAVE_NETINET_TCP_H)

check_include_file_concat("pem.h"            HAVE_PEM_H)
check_include_file_concat("poll.h"           HAVE_POLL_H)
check_include_file_concat("pwd.h"            HAVE_PWD_H)
check_include_file_concat("rsa.h"            HAVE_RSA_H)
check_include_file_concat("setjmp.h"         HAVE_SETJMP_H)
check_include_file_concat("sgtty.h"          HAVE_SGTTY_H)
check_include_file_concat("signal.h"         HAVE_SIGNAL_H)
check_include_file_concat("ssl.h"            HAVE_SSL_H)
check_include_file_concat("stdbool.h"        HAVE_STDBOOL_H)
check_include_file_concat("stdint.h"         HAVE_STDINT_H)
check_include_file_concat("stdio.h"          HAVE_STDIO_H)
check_include_file_concat("stdlib.h"         HAVE_STDLIB_H)
check_include_file_concat("string.h"         HAVE_STRING_H)
check_include_file_concat("strings.h"        HAVE_STRINGS_H)
check_include_file_concat("stropts.h"        HAVE_STROPTS_H)
check_include_file_concat("termio.h"         HAVE_TERMIO_H)
check_include_file_concat("termios.h"        HAVE_TERMIOS_H)
check_include_file_concat("time.h"           HAVE_TIME_H)
check_include_file_concat("tld.h"            HAVE_TLD_H)
check_include_file_concat("unistd.h"         HAVE_UNISTD_H)
check_include_file_concat("utime.h"          HAVE_UTIME_H)
check_include_file_concat("x509.h"           HAVE_X509_H)

check_include_file_concat("process.h"        HAVE_PROCESS_H)
check_include_file_concat("stddef.h"         HAVE_STDDEF_H)
check_include_file_concat("dlfcn.h"          HAVE_DLFCN_H)
check_include_file_concat("malloc.h"         HAVE_MALLOC_H)
check_include_file_concat("memory.h"         HAVE_MEMORY_H)
check_include_file_concat("netinet/if_ether.h" HAVE_NETINET_IF_ETHER_H)
check_include_file_concat("stdint.h"        HAVE_STDINT_H)
check_include_file_concat("sockio.h"        HAVE_SOCKIO_H)
check_include_file_concat("sys/utsname.h"   HAVE_SYS_UTSNAME_H)
check_include_file_concat("idna.h"          HAVE_IDNA_H)



check_type_size(size_t  SIZEOF_SIZE_T)
check_type_size(ssize_t  SIZEOF_SSIZE_T)
check_type_size("long long"  SIZEOF_LONG_LONG)
check_type_size("long"  SIZEOF_LONG)
check_type_size("short"  SIZEOF_SHORT)
check_type_size("int"  SIZEOF_INT)
check_type_size("__int64"  SIZEOF___INT64)
check_type_size("time_t"  SIZEOF_TIME_T)
check_type_size("off_t"  SIZEOF_OFF_T)

# Make public versions of some type sizes for curlbuild.h.
foreach(t INT LONG LONG_LONG SSIZE_T)
  string(REPLACE "SIZEOF_" "CURL_SIZEOF_" CURL_SIZEOF_${t}_CODE "${SIZEOF_${t}_CODE}")
endforeach()

if(HAVE_SIZEOF_LONG_LONG)
  set(HAVE_LONGLONG 1)
  set(HAVE_LL 1)
endif(HAVE_SIZEOF_LONG_LONG)

find_file(RANDOM_FILE urandom /dev)
mark_as_advanced(RANDOM_FILE)

# Check for some functions that are used
check_symbol_exists(basename      "${CURL_INCLUDES}" HAVE_BASENAME)
check_symbol_exists(socket        "${CURL_INCLUDES}" HAVE_SOCKET)
check_symbol_exists(poll          "${CURL_INCLUDES}" HAVE_POLL)
check_symbol_exists(select        "${CURL_INCLUDES}" HAVE_SELECT)
check_symbol_exists(strdup        "${CURL_INCLUDES}" HAVE_STRDUP)
check_symbol_exists(strstr        "${CURL_INCLUDES}" HAVE_STRSTR)
check_symbol_exists(strtok_r      "${CURL_INCLUDES}" HAVE_STRTOK_R)
check_symbol_exists(strftime      "${CURL_INCLUDES}" HAVE_STRFTIME)
check_symbol_exists(uname         "${CURL_INCLUDES}" HAVE_UNAME)
check_symbol_exists(strcasecmp    "${CURL_INCLUDES}" HAVE_STRCASECMP)
check_symbol_exists(stricmp       "${CURL_INCLUDES}" HAVE_STRICMP)
check_symbol_exists(strcmpi       "${CURL_INCLUDES}" HAVE_STRCMPI)
check_symbol_exists(strncmpi      "${CURL_INCLUDES}" HAVE_STRNCMPI)
check_symbol_exists(alarm         "${CURL_INCLUDES}" HAVE_ALARM)
if(NOT HAVE_STRNCMPI)
  set(HAVE_STRCMPI)
endif(NOT HAVE_STRNCMPI)
check_symbol_exists(gethostbyaddr "${CURL_INCLUDES}" HAVE_GETHOSTBYADDR)
check_symbol_exists(gethostbyaddr_r "${CURL_INCLUDES}" HAVE_GETHOSTBYADDR_R)
check_symbol_exists(gettimeofday  "${CURL_INCLUDES}" HAVE_GETTIMEOFDAY)
check_symbol_exists(inet_addr     "${CURL_INCLUDES}" HAVE_INET_ADDR)
check_symbol_exists(inet_ntoa     "${CURL_INCLUDES}" HAVE_INET_NTOA)
check_symbol_exists(inet_ntoa_r   "${CURL_INCLUDES}" HAVE_INET_NTOA_R)
check_symbol_exists(tcsetattr     "${CURL_INCLUDES}" HAVE_TCSETATTR)
check_symbol_exists(tcgetattr     "${CURL_INCLUDES}" HAVE_TCGETATTR)
check_symbol_exists(perror        "${CURL_INCLUDES}" HAVE_PERROR)
check_symbol_exists(closesocket   "${CURL_INCLUDES}" HAVE_CLOSESOCKET)
check_symbol_exists(setvbuf       "${CURL_INCLUDES}" HAVE_SETVBUF)
check_symbol_exists(sigsetjmp     "${CURL_INCLUDES}" HAVE_SIGSETJMP)
check_symbol_exists(getpass_r     "${CURL_INCLUDES}" HAVE_GETPASS_R)
check_symbol_exists(strlcat       "${CURL_INCLUDES}" HAVE_STRLCAT)
check_symbol_exists(getpwuid      "${CURL_INCLUDES}" HAVE_GETPWUID)
check_symbol_exists(geteuid       "${CURL_INCLUDES}" HAVE_GETEUID)
check_symbol_exists(utime         "${CURL_INCLUDES}" HAVE_UTIME)
if(CMAKE_USE_OPENSSL)
  check_symbol_exists(RAND_status   "${CURL_INCLUDES}" HAVE_RAND_STATUS)
  check_symbol_exists(RAND_screen   "${CURL_INCLUDES}" HAVE_RAND_SCREEN)
  check_symbol_exists(RAND_egd      "${CURL_INCLUDES}" HAVE_RAND_EGD)
  check_symbol_exists(CRYPTO_cleanup_all_ex_data "${CURL_INCLUDES}"
    HAVE_CRYPTO_CLEANUP_ALL_EX_DATA)
  if(HAVE_LIBCRYPTO AND HAVE_LIBSSL)
    set(USE_OPENSSL 1)
    set(USE_SSLEAY 1)
  endif(HAVE_LIBCRYPTO AND HAVE_LIBSSL)
endif(CMAKE_USE_OPENSSL)
check_symbol_exists(gmtime_r      "${CURL_INCLUDES}" HAVE_GMTIME_R)
check_symbol_exists(localtime_r   "${CURL_INCLUDES}" HAVE_LOCALTIME_R)

check_symbol_exists(gethostbyname   "${CURL_INCLUDES}" HAVE_GETHOSTBYNAME)
check_symbol_exists(gethostbyname_r "${CURL_INCLUDES}" HAVE_GETHOSTBYNAME_R)

check_symbol_exists(signal        "${CURL_INCLUDES}" HAVE_SIGNAL_FUNC)
check_symbol_exists(SIGALRM       "${CURL_INCLUDES}" HAVE_SIGNAL_MACRO)
if(HAVE_SIGNAL_FUNC AND HAVE_SIGNAL_MACRO)
  set(HAVE_SIGNAL 1)
endif(HAVE_SIGNAL_FUNC AND HAVE_SIGNAL_MACRO)
check_symbol_exists(uname          "${CURL_INCLUDES}" HAVE_UNAME)
check_symbol_exists(strtoll        "${CURL_INCLUDES}" HAVE_STRTOLL)
check_symbol_exists(_strtoi64      "${CURL_INCLUDES}" HAVE__STRTOI64)
check_symbol_exists(strerror_r     "${CURL_INCLUDES}" HAVE_STRERROR_R)
check_symbol_exists(siginterrupt   "${CURL_INCLUDES}" HAVE_SIGINTERRUPT)
check_symbol_exists(perror         "${CURL_INCLUDES}" HAVE_PERROR)
check_symbol_exists(fork           "${CURL_INCLUDES}" HAVE_FORK)
check_symbol_exists(freeaddrinfo   "${CURL_INCLUDES}" HAVE_FREEADDRINFO)
check_symbol_exists(freeifaddrs    "${CURL_INCLUDES}" HAVE_FREEIFADDRS)
check_symbol_exists(pipe           "${CURL_INCLUDES}" HAVE_PIPE)
check_symbol_exists(ftruncate      "${CURL_INCLUDES}" HAVE_FTRUNCATE)
check_symbol_exists(getprotobyname "${CURL_INCLUDES}" HAVE_GETPROTOBYNAME)
check_symbol_exists(getrlimit      "${CURL_INCLUDES}" HAVE_GETRLIMIT)
check_symbol_exists(idn_free       "${CURL_INCLUDES}" HAVE_IDN_FREE)
check_symbol_exists(idna_strerror  "${CURL_INCLUDES}" HAVE_IDNA_STRERROR)
check_symbol_exists(tld_strerror   "${CURL_INCLUDES}" HAVE_TLD_STRERROR)
check_symbol_exists(setlocale      "${CURL_INCLUDES}" HAVE_SETLOCALE)
check_symbol_exists(setrlimit      "${CURL_INCLUDES}" HAVE_SETRLIMIT)
check_symbol_exists(fcntl          "${CURL_INCLUDES}" HAVE_FCNTL)
check_symbol_exists(ioctl          "${CURL_INCLUDES}" HAVE_IOCTL)
check_symbol_exists(setsockopt     "${CURL_INCLUDES}" HAVE_SETSOCKOPT)

# symbol exists in win32, but function does not.
check_function_exists(inet_pton HAVE_INET_PTON)

# sigaction and sigsetjmp are special. Use special mechanism for
# detecting those, but only if previous attempt failed.
if(HAVE_SIGNAL_H)
  check_symbol_exists(sigaction "signal.h" HAVE_SIGACTION)
endif(HAVE_SIGNAL_H)

if(NOT HAVE_SIGSETJMP)
  if(HAVE_SETJMP_H)
    check_symbol_exists(sigsetjmp "setjmp.h" HAVE_MACRO_SIGSETJMP)
    if(HAVE_MACRO_SIGSETJMP)
      set(HAVE_SIGSETJMP 1)
    endif(HAVE_MACRO_SIGSETJMP)
  endif(HAVE_SETJMP_H)
endif(NOT HAVE_SIGSETJMP)

# If there is no stricmp(), do not allow LDAP to parse URLs
if(NOT HAVE_STRICMP)
  set(HAVE_LDAP_URL_PARSE 1)
endif(NOT HAVE_STRICMP)



# Do curl specific tests
if(HAVE_LIBWS2_32)
  set(CMAKE_REQUIRED_LIBRARIES ws2_32)
endif()
foreach(CURL_TEST
    HAVE_FCNTL_O_NONBLOCK
    HAVE_IOCTLSOCKET
    HAVE_IOCTLSOCKET_CAMEL
    HAVE_IOCTLSOCKET_CAMEL_FIONBIO
    HAVE_IOCTLSOCKET_FIONBIO
    HAVE_IOCTL_FIONBIO
    HAVE_IOCTL_SIOCGIFADDR
    HAVE_SETSOCKOPT_SO_NONBLOCK
    HAVE_SOCKADDR_IN6_SIN6_SCOPE_ID
    TIME_WITH_SYS_TIME
    HAVE_O_NONBLOCK
    HAVE_GETHOSTBYADDR_R_5
    HAVE_GETHOSTBYADDR_R_7
    HAVE_GETHOSTBYADDR_R_8
    HAVE_GETHOSTBYADDR_R_5_REENTRANT
    HAVE_GETHOSTBYADDR_R_7_REENTRANT
    HAVE_GETHOSTBYADDR_R_8_REENTRANT
    HAVE_GETHOSTBYNAME_R_3
    HAVE_GETHOSTBYNAME_R_5
    HAVE_GETHOSTBYNAME_R_6
    HAVE_GETHOSTBYNAME_R_3_REENTRANT
    HAVE_GETHOSTBYNAME_R_5_REENTRANT
    HAVE_GETHOSTBYNAME_R_6_REENTRANT
    HAVE_SOCKLEN_T
    HAVE_IN_ADDR_T
    HAVE_BOOL_T
    STDC_HEADERS
    RETSIGTYPE_TEST
    HAVE_INET_NTOA_R_DECL
    HAVE_INET_NTOA_R_DECL_REENTRANT
    HAVE_GETADDRINFO
    HAVE_FILE_OFFSET_BITS
    )
  curl_internal_test(${CURL_TEST})
endforeach(CURL_TEST)
if(HAVE_FILE_OFFSET_BITS)
  set(_FILE_OFFSET_BITS 64)
endif(HAVE_FILE_OFFSET_BITS)
foreach(CURL_TEST
    HAVE_GLIBC_STRERROR_R
    HAVE_POSIX_STRERROR_R
    )
  curl_internal_test_run(${CURL_TEST})
endforeach(CURL_TEST)

# Check for reentrant
foreach(CURL_TEST
    HAVE_GETHOSTBYADDR_R_5
    HAVE_GETHOSTBYADDR_R_7
    HAVE_GETHOSTBYADDR_R_8
    HAVE_GETHOSTBYNAME_R_3
    HAVE_GETHOSTBYNAME_R_5
    HAVE_GETHOSTBYNAME_R_6
    HAVE_INET_NTOA_R_DECL_REENTRANT)
  if(NOT ${CURL_TEST})
    if(${CURL_TEST}_REENTRANT)
      set(NEED_REENTRANT 1)
    endif(${CURL_TEST}_REENTRANT)
  endif(NOT ${CURL_TEST})
endforeach(CURL_TEST)

if(NEED_REENTRANT)
  foreach(CURL_TEST
      HAVE_GETHOSTBYADDR_R_5
      HAVE_GETHOSTBYADDR_R_7
      HAVE_GETHOSTBYADDR_R_8
      HAVE_GETHOSTBYNAME_R_3
      HAVE_GETHOSTBYNAME_R_5
      HAVE_GETHOSTBYNAME_R_6)
    set(${CURL_TEST} 0)
    if(${CURL_TEST}_REENTRANT)
      set(${CURL_TEST} 1)
    endif(${CURL_TEST}_REENTRANT)
  endforeach(CURL_TEST)
endif(NEED_REENTRANT)

if(HAVE_INET_NTOA_R_DECL_REENTRANT)
  set(HAVE_INET_NTOA_R_DECL 1)
  set(NEED_REENTRANT 1)
endif(HAVE_INET_NTOA_R_DECL_REENTRANT)

# Some other minor tests

if(NOT HAVE_IN_ADDR_T)
  set(in_addr_t "unsigned long")
endif(NOT HAVE_IN_ADDR_T)

# Fix libz / zlib.h

if(NOT CURL_SPECIAL_LIBZ)
  if(NOT HAVE_LIBZ)
    set(HAVE_ZLIB_H 0)
  endif(NOT HAVE_LIBZ)

  if(NOT HAVE_ZLIB_H)
    set(HAVE_LIBZ 0)
  endif(NOT HAVE_ZLIB_H)
endif(NOT CURL_SPECIAL_LIBZ)

if(_FILE_OFFSET_BITS)
  set(_FILE_OFFSET_BITS 64)
endif(_FILE_OFFSET_BITS)
set(CMAKE_REQUIRED_FLAGS "-D_FILE_OFFSET_BITS=64")
set(CMAKE_EXTRA_INCLUDE_FILES "${CMAKE_CURRENT_SOURCE_DIR}/curl/curl.h")
check_type_size("curl_off_t" SIZEOF_CURL_OFF_T)
set(CMAKE_EXTRA_INCLUDE_FILES)
set(CMAKE_REQUIRED_FLAGS)


# Check for nonblocking
set(HAVE_DISABLED_NONBLOCKING 1)
if(HAVE_FIONBIO OR
    HAVE_IOCTLSOCKET OR
    HAVE_IOCTLSOCKET_CASE OR
    HAVE_O_NONBLOCK)
  set(HAVE_DISABLED_NONBLOCKING)
endif(HAVE_FIONBIO OR
  HAVE_IOCTLSOCKET OR
  HAVE_IOCTLSOCKET_CASE OR
  HAVE_O_NONBLOCK)

if(RETSIGTYPE_TEST)
  set(RETSIGTYPE void)
else(RETSIGTYPE_TEST)
  set(RETSIGTYPE int)
endif(RETSIGTYPE_TEST)

if(CMAKE_COMPILER_IS_GNUCC AND APPLE)
  include(CheckCCompilerFlag)
  check_c_compiler_flag(-Wno-long-double HAVE_C_FLAG_Wno_long_double)
  if(HAVE_C_FLAG_Wno_long_double)
    # The Mac version of GCC warns about use of long double.  Disable it.
    get_source_file_property(MPRINTF_COMPILE_FLAGS mprintf.c COMPILE_FLAGS)
    if(MPRINTF_COMPILE_FLAGS)
      set(MPRINTF_COMPILE_FLAGS "${MPRINTF_COMPILE_FLAGS} -Wno-long-double")
    else(MPRINTF_COMPILE_FLAGS)
      set(MPRINTF_COMPILE_FLAGS "-Wno-long-double")
    endif(MPRINTF_COMPILE_FLAGS)
    set_source_files_properties(mprintf.c PROPERTIES
      COMPILE_FLAGS ${MPRINTF_COMPILE_FLAGS})
  endif(HAVE_C_FLAG_Wno_long_double)
endif(CMAKE_COMPILER_IS_GNUCC AND APPLE)

if(HAVE_SOCKLEN_T)
  set(CURL_HAVE_SOCKLEN_T 1)
  set(CURL_TYPEOF_CURL_SOCKLEN_T "socklen_t")
  if(WIN32)
    set(CMAKE_EXTRA_INCLUDE_FILES "winsock2.h;ws2tcpip.h")
  elseif(HAVE_SYS_SOCKET_H)
    set(CMAKE_EXTRA_INCLUDE_FILES "sys/socket.h")
  endif()
  check_type_size("socklen_t" CURL_SIZEOF_CURL_SOCKLEN_T)
  set(CMAKE_EXTRA_INCLUDE_FILES)
  if(NOT HAVE_CURL_SIZEOF_CURL_SOCKLEN_T)
    message(FATAL_ERROR
     "Check for sizeof socklen_t failed, see CMakeFiles/CMakerror.log")
  endif()
else()
  set(CURL_HAVE_SOCKLEN_T 0)
endif()

# TODO test which of these headers are required for the typedefs used in curlbuild.h
if(WIN32)
  set(CURL_PULL_WS2TCPIP_H ${HAVE_WS2TCPIP_H})
else()
  set(CURL_PULL_SYS_TYPES_H ${HAVE_SYS_TYPES_H})
  set(CURL_PULL_SYS_SOCKET_H ${HAVE_SYS_SOCKET_H})
  set(CURL_PULL_SYS_POLL_H ${HAVE_SYS_POLL_H})
endif()
set(CURL_PULL_STDINT_H ${HAVE_STDINT_H})
set(CURL_PULL_INTTYPES_H ${HAVE_INTTYPES_H})

include(CMake/OtherTests.cmake)

add_definitions(-DHAVE_CONFIG_H)

# For windows, do not allow the compiler to use default target (Vista).
if(WIN32)
  add_definitions(-D_WIN32_WINNT=0x0501)
endif(WIN32)

if(MSVC)
  add_definitions(-D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE)
endif(MSVC)

# Sets up the dependencies (zlib, OpenSSL, etc.) of a cURL subproject according to options.
# TODO This is far to be complete!
function(SETUP_CURL_DEPENDENCIES TARGET_NAME)
  if(CURL_ZLIB AND ZLIB_FOUND)
    include_directories(${ZLIB_INCLUDE_DIR})
  endif()

  if(CMAKE_USE_OPENSSL AND OPENSSL_FOUND)
    include_directories(${OPENSSL_INCLUDE_DIR})
  endif()

  if(CMAKE_USE_LIBSSH2 AND LIBSSH2_FOUND)
    include_directories(${LIBSSH2_INCLUDE_DIR})
  endif()

  target_link_libraries(${TARGET_NAME} ${CURL_LIBS})
endfunction()

# Ugly (but functional) way to include "Makefile.inc" by transforming it (= regenerate it).
function(TRANSFORM_MAKEFILE_INC INPUT_FILE OUTPUT_FILE)
  file(READ ${INPUT_FILE} MAKEFILE_INC_TEXT)
  string(REPLACE "$(top_srcdir)"   "\${CURL_SOURCE_DIR}" MAKEFILE_INC_TEXT ${MAKEFILE_INC_TEXT})
  string(REPLACE "$(top_builddir)" "\${CURL_BINARY_DIR}" MAKEFILE_INC_TEXT ${MAKEFILE_INC_TEXT})

  string(REGEX REPLACE "\\\\\n" "�!�" MAKEFILE_INC_TEXT ${MAKEFILE_INC_TEXT})
  string(REGEX REPLACE "([a-zA-Z_][a-zA-Z0-9_]*)[\t ]*=[\t ]*([^\n]*)" "SET(\\1 \\2)" MAKEFILE_INC_TEXT ${MAKEFILE_INC_TEXT})
  string(REPLACE "�!�" "\n" MAKEFILE_INC_TEXT ${MAKEFILE_INC_TEXT})

  string(REGEX REPLACE "\\$\\(([a-zA-Z_][a-zA-Z0-9_]*)\\)" "\${\\1}" MAKEFILE_INC_TEXT ${MAKEFILE_INC_TEXT})    # Replace $() with ${}
  string(REGEX REPLACE "@([a-zA-Z_][a-zA-Z0-9_]*)@" "\${\\1}" MAKEFILE_INC_TEXT ${MAKEFILE_INC_TEXT})    # Replace @@ with ${}, even if that may not be read by CMake scripts.
  file(WRITE ${OUTPUT_FILE} ${MAKEFILE_INC_TEXT})

endfunction()

add_subdirectory(lib)
if(BUILD_CURL_EXE)
  add_subdirectory(src)
endif()
if(BUILD_CURL_TESTS)
  add_subdirectory(tests)
endif()

#-----------------------------------------------------------------------------
# CMake-specific curl code.
add_executable(LIBCURL curltest.c)
target_link_libraries(LIBCURL cmcurl)

if(CMAKE_CURL_TEST_URL)
  add_test(curl LIBCURL ${CMAKE_CURL_TEST_URL})
endif()

install(FILES COPYING DESTINATION ${CMAKE_DOC_DIR}/cmcurl)
#-----------------------------------------------------------------------------

if(0) # This code not needed for building within CMake.
# This needs to be run very last so other parts of the scripts can take advantage of this.
if(NOT CURL_CONFIG_HAS_BEEN_RUN_BEFORE)
  set(CURL_CONFIG_HAS_BEEN_RUN_BEFORE 1 CACHE INTERNAL "Flag to track whether this is the first time running CMake or if CMake has been configured before")
endif()

# Installation.
# First, install generated curlbuild.h
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/include/curl/curlbuild.h"
    DESTINATION include/curl )
# Next, install other headers excluding curlbuild.h
install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/curl"
    DESTINATION include
    FILES_MATCHING PATTERN "*.h"
    PATTERN "curlbuild.h" EXCLUDE)


# Workaround for MSVS10 to avoid the Dialog Hell
# FIXME: This could be removed with future version of CMake.
if(MSVC_VERSION EQUAL 1600)
  set(CURL_SLN_FILENAME "${CMAKE_CURRENT_BINARY_DIR}/CURL.sln")
  if(EXISTS "${CURL_SLN_FILENAME}")
    file(APPEND "${CURL_SLN_FILENAME}" "\n# This should be regenerated!\n")
  endif()
endif()
endif()
