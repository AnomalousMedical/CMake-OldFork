include(RunCMake)

run_cmake(FindPkgConfig_NO_PKGCONFIG_PATH)
run_cmake(FindPkgConfig_PKGCONFIG_PATH)
run_cmake(FindPkgConfig_PKGCONFIG_PATH_NO_CMAKE_PATH)
run_cmake(FindPkgConfig_PKGCONFIG_PATH_NO_CMAKE_ENVIRONMENT_PATH)

if(APPLE)
  run_cmake(FindPkgConfig_CMAKE_FRAMEWORK_PATH)
  run_cmake(FindPkgConfig_CMAKE_APPBUNDLE_PATH)
endif()
