set(d "/long/path/to/directory")
foreach(i RANGE 11)
  set(d "${d}${d}")
endforeach()
string(LENGTH "${d}" dl)
if(IS_DIRECTORY "${d}/")
  message(FATAL_ERROR "Directory should not exist!")
else()
  message(STATUS "Directory path with length ${dl} correctly does not exist.")
endif()
