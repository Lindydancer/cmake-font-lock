#
# This file contains snippets of CMakeLists.txt files containing
# uncommon constructs.
#

add_compiler_rt_static_runtime(clang_rt.asan-${arch} ${arch}
      SOURCES ${ASAN_SOURCES}
              $<TARGET_OBJECTS:RTInterception.${arch}>
              $<TARGET_OBJECTS:RTSanitizerCommon.${arch}>
      CFLAGS ${ASAN_CFLAGS}
      DEFS ${ASAN_COMMON_DEFINITIONS})


foo({allan})
foo(${allan})
foo($sune{allan})

foo($sune{${one}})
foo($sune{nested${one}nested})
foo($sune{$sune{one}})
foo($sune{nested$sune{one}nested})

set(ENV{allan} test $ENV{foo} $nonstandard{allan})

set (ENV{LD_LIBRARY_PATH} ${LD_LIBRARY_PATH}:$ENV{LD_LIBRARY_PATH})
