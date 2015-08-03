list(APPEND CMAKE_FIND_LIBRARY_PREFIXES lib)
list(APPEND CMAKE_FIND_LIBRARY_SUFFIXES .a)
find_library(CREATED_LIBRARY
  NAMES created
  PATHS ${CMAKE_CURRENT_BINARY_DIR}/lib
  NO_DEFAULT_PATH
  )
message("CREATED_LIBRARY='${CREATED_LIBRARY}'")
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib)
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/lib/libcreated.a" "created")
find_library(CREATED_LIBRARY
  NAMES created
  PATHS ${CMAKE_CURRENT_BINARY_DIR}/lib
  NO_DEFAULT_PATH
  )
message("CREATED_LIBRARY='${CREATED_LIBRARY}'")
