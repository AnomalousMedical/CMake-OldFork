cmake_minimum_required(VERSION 2.8.9)
project(CompilerIdFortran Fortran)

foreach(v
    CMAKE_Fortran_COMPILER
    CMAKE_Fortran_COMPILER_ID
    CMAKE_Fortran_COMPILER_VERSION
    )
  if(${v})
    message(STATUS "${v}=[${${v}}]")
  else()
    message(SEND_ERROR "${v} not set!")
  endif()
endforeach()
