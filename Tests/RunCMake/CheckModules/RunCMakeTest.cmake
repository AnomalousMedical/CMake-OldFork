include(RunCMake)

run_cmake(CheckStructHasMemberOk)
run_cmake(CheckStructHasMemberUnknownLanguage)
run_cmake(CheckStructHasMemberMissingLanguage)
run_cmake(CheckStructHasMemberMissingKey)
run_cmake(CheckStructHasMemberTooManyArguments)
run_cmake(CheckStructHasMemberWrongKey)

run_cmake(CheckTypeSizeOk)
run_cmake(CheckTypeSizeUnknownLanguage)
run_cmake(CheckTypeSizeMissingLanguage)
run_cmake(CheckTypeSizeUnknownArgument)
run_cmake(CheckTypeSizeMixedArgs)

run_cmake(CheckTypeSizeOkNoC)
