set(CTEST_RUN_CURRENT_SCRIPT 0)
if(NOT VERSION)
 set(VERSION 3.3)
endif()
if(NOT DEFINED PROJECT_PREFIX)
  set(PROJECT_PREFIX cmake-${VERSION})
endif()
if(NOT DEFINED DIR)
  set(DIR "v${VERSION}")
endif()
file(GLOB FILES ${CMAKE_CURRENT_SOURCE_DIR} "${PROJECT_PREFIX}*")
list(SORT FILES)
list(REVERSE FILES)
message("${FILES}")
set(UPLOAD_LOC
  "kitware@www.cmake.org:/projects/FTP/pub/cmake/${DIR}")
set(count 0)
foreach(file ${FILES})
  if(NOT IS_DIRECTORY ${file})
    message("upload ${file} ${UPLOAD_LOC}")
    execute_process(COMMAND
      scp ${file} ${UPLOAD_LOC}
      RESULT_VARIABLE result)
    if("${result}" GREATER 0)
      message(FATAL_ERROR "failed to upload file to ${UPLOAD_LOC}")
    endif()

    # Pause to give each upload a distinct (to the nearest second)
    # time stamp
    if(COMMAND ctest_sleep)
      ctest_sleep(2)
    endif()

    math(EXPR count "${count} + 1")
  endif()
endforeach()
if(${count} EQUAL 0)
   message(FATAL_ERROR "Error no files uploaded.")
endif()
