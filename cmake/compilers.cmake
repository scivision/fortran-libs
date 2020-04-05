set(CMAKE_CONFIGURATION_TYPES "Release;RelWithDebInfo;Debug" CACHE STRING "Build type selections" FORCE)

# don't use LTO, the MUMPS code is not compatible for GCC at least.
# will give link failures when used in real programs.
# include(CheckIPOSupported)
# check_ipo_supported(RESULT lto_supported)
# if(lto_supported)
#   set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
# endif()

set(CDEFS "Add_")
# "Add_" works for all modern compilers we tried.

# typical projects set options too strict for MUMPS code style, so if
# being used as external project, locally override MUMPS compile options
if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
# MUMPS is being compiled by itself or as ExternalProject
  if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
    if(WIN32)
    add_compile_options(/arch:native)
      # /heap-arrays is necessary to avoid runtime errors in programs using this library
      string(APPEND CMAKE_Fortran_FLAGS " /warn:declarations /heap-arrays")
    else()
      add_compile_options(-march=native)
      string(APPEND CMAKE_Fortran_FLAGS " -warn declarations")
    endif()
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
    add_compile_options(-mtune=native)
    string(APPEND CMAKE_Fortran_FLAGS " -fimplicit-none")
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)
    string(APPEND CMAKE_Fortran_FLAGS " -Mdclchk")
  endif()
else()
  # MUMPS is being compiled via FetchContent, override options to avoid tens of megabytes of warnings
  if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
    if(WIN32)
      # /heap-arrays is necessary to avoid runtime errors in programs using this library
      set(CMAKE_Fortran_FLAGS "/nologo /fpp /libs:dll /threads /warn:declarations /heap-arrays")
    else()
      set(CMAKE_Fortran_FLAGS "-warn declarations")
    endif()
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
    add_compile_options(-mtune=native)
    set(CMAKE_Fortran_FLAGS "-fimplicit-none")
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)
    set(CMAKE_Fortran_FLAGS "-Mdclchk")
  endif()
endif()
