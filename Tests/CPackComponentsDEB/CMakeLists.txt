# CPack Example: User-selectable Installation Components
#
# In this example, we have a simple library (mylib) with an example
# application (mylibapp). We create a binary installer (a CPack Generator)
# which supports CPack components.

cmake_minimum_required(VERSION 2.8.3.20101130 FATAL_ERROR)
project(CPackComponentsDEB)

# Use GNUInstallDirs in order to enforce lib64 if needed
include(GNUInstallDirs)

# Create the mylib library
add_library(mylib mylib.cpp)

# Create the mylibapp application
add_executable(mylibapp mylibapp.cpp)
target_link_libraries(mylibapp mylib)

# Duplicate of mylibapp application
# which won't be put in any component (?mistake?)
add_executable(mylibapp2 mylibapp.cpp)
target_link_libraries(mylibapp2 mylib)

# Create installation targets. Note that we put each kind of file
# into a different component via COMPONENT. These components will
# be used to create the installation components.
install(TARGETS mylib
  ARCHIVE
  DESTINATION ${CMAKE_INSTALL_LIBDIR}
  COMPONENT libraries)

install(TARGETS mylibapp
  RUNTIME
  DESTINATION bin
  COMPONENT applications)

install(FILES mylib.h
        DESTINATION include
        COMPONENT headers)

# CPack boilerplate for this project
set(CPACK_PACKAGE_NAME "MyLib")
set(CPACK_PACKAGE_CONTACT "None")
set(CPACK_PACKAGE_VENDOR "CMake.org")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "MyLib - CPack Component Installation Example")
set(CPACK_PACKAGE_VERSION "1.0.2")
set(CPACK_PACKAGE_VERSION_MAJOR "1")
set(CPACK_PACKAGE_VERSION_MINOR "0")
set(CPACK_PACKAGE_VERSION_PATCH "2")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "CPack Component Example")
set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_CURRENT_SOURCE_DIR}/license.txt)

# Tell CPack all of the components to install. The "ALL"
# refers to the fact that this is the set of components that
# will be included when CPack is instructed to put everything
# into the binary installer (the default behavior).
set(CPACK_COMPONENTS_ALL applications libraries headers)

# Set the displayed names for each of the components to install.
# These will be displayed in the list of components inside the installer.
set(CPACK_COMPONENT_APPLICATIONS_DISPLAY_NAME   "MyLib Application")
set(CPACK_COMPONENT_LIBRARIES_DISPLAY_NAME      "Libraries")
set(CPACK_COMPONENT_HEADERS_DISPLAY_NAME        "C++ Headers")

# Provide descriptions for each of the components to install.
# When the user hovers the mouse over the name of a component,
# the description will be shown in the "Description" box in the
# installer. If no descriptions are provided, the "Description"
# box will be removed.
set(CPACK_COMPONENT_APPLICATIONS_DESCRIPTION
  "An extremely useful application that makes use of MyLib")
set(CPACK_COMPONENT_LIBRARIES_DESCRIPTION
  "Static libraries used to build programs with MyLib")
set(CPACK_COMPONENT_HEADERS_DESCRIPTION
  "C/C++ header files for use with MyLib")

# It doesn't make sense to install the headers without the libraries
# (because you could never use the headers!), so make the headers component
# depend on the libraries component.
set(CPACK_COMPONENT_HEADERS_DEPENDS libraries)

# We may use the CPack specific config file in order
# to tailor CPack behavior on a CPack generator specific way
# (Behavior would be different for RPM or TGZ or DEB ...)
if (NOT DEFINED CPackDEBConfiguration)
  message(FATAL_ERROR "CPackDEBConfiguration should be defined")
endif()

# Setup project specific CPack-time CPack Config file.
configure_file(${CPackComponentsDEB_SOURCE_DIR}/MyLibCPackConfig-${CPackDEBConfiguration}.cmake.in
               ${CPackComponentsDEB_BINARY_DIR}/MyLibCPackConfig-${CPackDEBConfiguration}.cmake
               @ONLY)
set(CPACK_PROJECT_CONFIG_FILE ${CPackComponentsDEB_BINARY_DIR}/MyLibCPackConfig-${CPackDEBConfiguration}.cmake)


# Include CPack to introduce the appropriate targets
include(CPack)
