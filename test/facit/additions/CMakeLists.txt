#
# This file is used to test new CMake additions.
#
# Note that this file contains badly formed CMake functions (e.g. the
# call to "file") as it is only intended to be used to test CMake
# highlight rules.
#

# 2.8.8.8 -> 2.8.12

add_executable(alpha ALIAS beta)
add_library(alpha ALIAS beta)
cmake_host_system_information(RESULT var QUERY HOSTNAME)
export(TARGETS tgt1 tgt2 tgt3 EXPORT_LINK_INTERFACE_LIBRARIES)
file(CONDITION
  EXPECTED_HASH
  GENERATE
  INPUT
  CONTENT
  OUTPUT
  READ path var
  TLS_VERIFY
  TLS_CAINFO)
file(TIMESTAMP file var format UTC)
include_external_msproject(tgt file TYPE alpha
  GUID beta PLATFORM delta dep1 dep2)
install(TARGETS tgt INCLUDES DESTINATION path)
string(TIMESTAMP var format UTC)

target_compile_definitions(target PUBLIC THESE ARE INTERFACE SYMBOLS)

target_compile_options(target BEFORE PUBLIC --these --are INTERFACE --options
  -DALPHA)

target_include_directories(target SYSTEM BEFORE PUBLIC
  these are INTERFACE paths)

try_compile(var bindir srcdir projectName tgt OUTPUT_VARIABLE var2)
try_compile(var bindir SOURCES src1 src2 COMPILE_DEFINITIONS DEF1 DEF2)
try_compile(var bindir src COPY_FILE file COPY_FILE_ERROR var2)

try_run(var1 var2 bindir srcdir COMPILE_DEFINITIONS DEF1 DEF2)

# list()

list(INSERT var)                # Incomplete, should still highlight OK.
list(INSERT var alpha beta)

# execute_process()

execute_process(
  COMMAND mycommand
  RESULT_VARIABLE myvar
  OUTPUT_FILE myfile
  INPUT_FILE myfile
  OUTPUT_FILE myfile)

execute_process(
  COMMAND mycommand
  RESULT_VARIABLE myvar
  OUTPUT_FILE
  INPUT_FILE                    # This is the argument to OUTPUT_FILE.
  OUTPUT_FILE)

#
# Generator expressions
#

foo($<FOO:$<CONFIGURATION>>)

#
# Don't highlight variable expressions in comments: ${var}
#

foo("But they should work in ${strings} and" ${outside})

# The argument of DIRECTORY is optional.
get_property(my_var DIRECTORY PROPERTY my_prop)
get_property(my_var DIRECTORY a_dir PROPERTY my_prop)
