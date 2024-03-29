file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/test/depth1/depth2/depth3")
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink "${CMAKE_CURRENT_BINARY_DIR}/test" "${CMAKE_CURRENT_BINARY_DIR}/test/depth1/depth2/depth3/recursion")

file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/test/abc" "message to write")
execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink "${CMAKE_CURRENT_BINARY_DIR}/test/abc" "${CMAKE_CURRENT_BINARY_DIR}/test/depth1/depth2/depth3/file_symlink")

file(GLOB_RECURSE CONTENT_LIST FOLLOW_SYMLINKS "${CMAKE_CURRENT_BINARY_DIR}/test/*")
list(LENGTH CONTENT_LIST CONTENT_COUNT)
message("content: ${CONTENT_COUNT} ")
list(SORT CONTENT_LIST)
message("${CONTENT_LIST}")

file(GLOB_RECURSE CONTENT_LIST LIST_DIRECTORIES false FOLLOW_SYMLINKS "${CMAKE_CURRENT_BINARY_DIR}/test/*")
list(LENGTH CONTENT_LIST CONTENT_COUNT)
message("content: ${CONTENT_COUNT} ")
list(SORT CONTENT_LIST)
message("${CONTENT_LIST}")

file(GLOB_RECURSE CONTENT_LIST LIST_DIRECTORIES true FOLLOW_SYMLINKS "${CMAKE_CURRENT_BINARY_DIR}/test/*")
list(LENGTH CONTENT_LIST CONTENT_COUNT)
message("content: ${CONTENT_COUNT} ")
list(SORT CONTENT_LIST)
message("${CONTENT_LIST}")
