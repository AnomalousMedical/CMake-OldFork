cmake_minimum_required (VERSION 2.6)
project(SourceGroups)

# this is not really a test which can fail
# it is more an example with several source_group()
# commands.
# The created projects have to be loaded manually
# in Visual Studio/Xcode/Eclipse/...
# to see whether the correct groups have been created.

source_group(Base             FILES main.c)

# a sub group
source_group(Base\\Sub1       FILES sub1/foo.c)

# a sub sub group
source_group(Base\\Sub1\\Sub2 FILES sub1/foobar.c)

# a group with empty name
source_group("" FILES foo.c)

# a group, whose name consists only of the delimiter
#should be handled the same way as an empty name
source_group("\\" FILES baz.c)

# a sub sub group whose last component has the same name
# as an already existing group
source_group(Base\\Sub1\\Base FILES bar.c)

# a group without files, is currently not created
source_group(EmptyGroup)


add_executable(SourceGroups main.c bar.c foo.c sub1/foo.c sub1/foobar.c baz.c README.txt)

