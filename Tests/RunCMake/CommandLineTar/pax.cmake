set(OUTPUT_NAME "test.tar")

set(COMPRESSION_FLAGS cvf)
set(COMPRESSION_OPTIONS --format=pax)

set(DECOMPRESSION_FLAGS xvf)

include(${CMAKE_CURRENT_LIST_DIR}/roundtrip.cmake)

check_magic("7573746172003030" OFFSET 257 LIMIT 8 HEX)
