cmake_minimum_required(VERSION 2.8.4)
project(${RunCMake_TEST} NONE)
if(NOT TEST_FILE)
  set(TEST_FILE ${RunCMake_TEST}.cmake)
endif()
include(${TEST_FILE})
