include(RunCMake)

run_cmake(BadCONFIG)
run_cmake(BadOR)
run_cmake(BadAND)
run_cmake(BadNOT)
run_cmake(BadStrEqual)
run_cmake(BadZero)
run_cmake(BadTargetName)
run_cmake(BadTargetTypeInterface)
run_cmake(BadTargetTypeObject)
run_cmake(BadInstallPrefix)
run_cmake(CMP0044-WARN)
run_cmake(NonValidTarget-C_COMPILER_ID)
run_cmake(NonValidTarget-CXX_COMPILER_ID)
run_cmake(NonValidTarget-C_COMPILER_VERSION)
run_cmake(NonValidTarget-CXX_COMPILER_VERSION)
run_cmake(NonValidTarget-TARGET_PROPERTY)
run_cmake(NonValidTarget-TARGET_POLICY)
run_cmake(COMPILE_LANGUAGE-add_custom_target)
run_cmake(COMPILE_LANGUAGE-add_custom_command)
run_cmake(COMPILE_LANGUAGE-install)
run_cmake(COMPILE_LANGUAGE-target_sources)
run_cmake(COMPILE_LANGUAGE-add_executable)
run_cmake(COMPILE_LANGUAGE-add_library)
run_cmake(COMPILE_LANGUAGE-add_test)
run_cmake(COMPILE_LANGUAGE-unknown-lang)

if(LINKER_SUPPORTS_PDB)
  run_cmake(NonValidTarget-TARGET_PDB_FILE)
  run_cmake(ValidTarget-TARGET_PDB_FILE)
else()
  run_cmake(NonValidCompiler-TARGET_PDB_FILE)
endif()
