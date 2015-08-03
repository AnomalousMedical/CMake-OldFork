
cmake_minimum_required(VERSION 2.8)

project(CompatibleInterface)

include(GenerateExportHeader)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

add_library(iface1 INTERFACE)
set_property(TARGET iface1 APPEND PROPERTY
  COMPATIBLE_INTERFACE_BOOL
    BOOL_PROP1
    BOOL_PROP2
    BOOL_PROP3
    BOOL_PROP4
    BOOL_PROP5
    BOOL_PROP6
    BOOL_PROP7
)
set_property(TARGET iface1 APPEND PROPERTY
  COMPATIBLE_INTERFACE_STRING
    STRING_PROP1
    STRING_PROP2
    STRING_PROP3
    STRING_PROP4 # Not set.
)
set_property(TARGET iface1 APPEND PROPERTY
  COMPATIBLE_INTERFACE_NUMBER_MIN
    NUMBER_MIN_PROP1
    NUMBER_MIN_PROP2
)
set_property(TARGET iface1 APPEND PROPERTY
  COMPATIBLE_INTERFACE_NUMBER_MAX
    NUMBER_MAX_PROP1
    NUMBER_MAX_PROP2
)

set(CMAKE_DEBUG_TARGET_PROPERTIES
  BOOL_PROP1 BOOL_PROP2 BOOL_PROP3 BOOL_PROP4 BOOL_PROP5 BOOL_PROP6 BOOL_PROP7
  STRING_PROP1 STRING_PROP2 STRING_PROP3 STRING_PROP4
  NUMBER_MIN_PROP1 NUMBER_MIN_PROP2
  NUMBER_MAX_PROP1 NUMBER_MAX_PROP2
)

set_property(TARGET iface1 PROPERTY INTERFACE_BOOL_PROP1 ON)
set_property(TARGET iface1 PROPERTY INTERFACE_BOOL_PROP2 ON)
set_property(TARGET iface1 PROPERTY INTERFACE_BOOL_PROP5 OFF)
set_property(TARGET iface1 PROPERTY INTERFACE_BOOL_PROP6 OFF)
set_property(TARGET iface1 PROPERTY INTERFACE_BOOL_PROP7 OFF)
set_property(TARGET iface1 PROPERTY INTERFACE_STRING_PROP1 prop1)
set_property(TARGET iface1 PROPERTY INTERFACE_STRING_PROP2 prop2)
set_property(TARGET iface1 PROPERTY INTERFACE_NUMBER_MIN_PROP1 100)
set_property(TARGET iface1 PROPERTY INTERFACE_NUMBER_MIN_PROP2 200)
set_property(TARGET iface1 PROPERTY INTERFACE_NUMBER_MAX_PROP1 100)
set_property(TARGET iface1 PROPERTY INTERFACE_NUMBER_MAX_PROP2 200)

add_library(iface2 INTERFACE)
set_property(TARGET iface2 PROPERTY INTERFACE_BOOL_PROP6 OFF)

add_library(iface3 INTERFACE)

add_executable(CompatibleInterface empty.cpp)
target_link_libraries(CompatibleInterface iface1 iface2
  $<$<BOOL:$<TARGET_PROPERTY:BOOL_PROP7>>:iface3>
)

set_property(TARGET CompatibleInterface PROPERTY BOOL_PROP2 ON)
set_property(TARGET CompatibleInterface PROPERTY BOOL_PROP3 ON)
set_property(TARGET CompatibleInterface PROPERTY STRING_PROP2 prop2)
set_property(TARGET CompatibleInterface PROPERTY STRING_PROP3 prop3)
set_property(TARGET CompatibleInterface PROPERTY NUMBER_MIN_PROP1 50)
set_property(TARGET CompatibleInterface PROPERTY NUMBER_MIN_PROP2 250)
set_property(TARGET CompatibleInterface PROPERTY NUMBER_MAX_PROP1 50)
set_property(TARGET CompatibleInterface PROPERTY NUMBER_MAX_PROP2 250)
