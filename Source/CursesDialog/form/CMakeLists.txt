#=============================================================================
# CMake - Cross Platform Makefile Generator
# Copyright 2000-2009 Kitware, Inc., Insight Software Consortium
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
project(CMAKE_FORM)

include_regular_expression("^.*$")
include_directories(${CURSES_INCLUDE_PATH} "${CMAKE_CURRENT_BINARY_DIR}")

configure_file(cmFormConfigure.h.in "${CMAKE_CURRENT_BINARY_DIR}/cmFormConfigure.h")

set(  FORM_SRCS
             fld_arg.c
             fld_attr.c
             fld_current.c
             fld_def.c
             fld_dup.c
             fld_ftchoice.c
             fld_ftlink.c
             fld_info.c
             fld_just.c
             fld_link.c
             fld_max.c
             fld_move.c
             fld_newftyp.c
             fld_opts.c
             fld_pad.c
             fld_page.c
             fld_stat.c
             fld_type.c
             fld_user.c
             frm_cursor.c
             frm_data.c
             frm_def.c
             frm_driver.c
             frm_hook.c
             frm_opts.c
             frm_page.c
             frm_post.c
             frm_req_name.c
             frm_scale.c
             frm_sub.c
             frm_user.c
             frm_win.c
             fty_alnum.c
             fty_alpha.c
             fty_enum.c
             fty_int.c
             fty_ipv4.c
             fty_num.c
             fty_regex.c
   )
             
include_directories(${CMAKE_FORM_SOURCE_DIR})
add_library(cmForm ${FORM_SRCS} )
target_link_libraries(cmForm ${CURSES_LIBRARY})
if(CURSES_EXTRA_LIBRARY)
  target_link_libraries(cmForm ${CURSES_EXTRA_LIBRARY})
endif()
