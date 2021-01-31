if(NOT (CMAKE_Fortran_COMPILER_ID STREQUAL ${CMAKE_C_COMPILER_ID} AND CMAKE_Fortran_COMPILER_VERSION VERSION_EQUAL ${CMAKE_C_COMPILER_VERSION}))
message(WARNING "C compiler ${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION} != Fortran compiler ${CMAKE_Fortran_COMPILER_ID} ${CMAKE_Fortran_COMPILER_VERSION}.
Set environment variables CC and FC to control compiler selection in general.")
endif()

set(CDEFS "Add_")
# "Add_" works for all modern compilers we tried.

set(_gcc10opts)
if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU AND CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 10)
  set(_gcc10opts "-fallow-argument-mismatch -fallow-invalid-boz")
endif()


# typical projects set options too strict for MUMPS code style, so if
# being used as external project, locally override MUMPS compile options
if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
# MUMPS is being compiled by itself or as ExternalProject
  if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
    if(WIN32)
    add_compile_options(/QxHost)
      # /heap-arrays is necessary to avoid runtime errors in programs using this library
      string(APPEND CMAKE_Fortran_FLAGS " /warn:declarations /heap-arrays")
    else()
      add_compile_options(-xHost)
      string(APPEND CMAKE_Fortran_FLAGS " -warn declarations")
    endif()
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
    add_compile_options(-mtune=native)
    string(APPEND CMAKE_Fortran_FLAGS " -fimplicit-none ${_gcc10opts}")
    if(MINGW)
      # presumably using MS-MPI, which emits extreme amounts of nuisance warnings
      string(APPEND CMAKE_Fortran_FLAGS " -w")
    endif(MINGW)
  endif()
else()
  # MUMPS is being compiled via FetchContent, override options to avoid tens of megabytes of warnings
  if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
    if(WIN32)
      # /heap-arrays is necessary to avoid runtime errors in programs using this library
      string(APPEND CMAKE_Fortran_FLAGS " /nowarn /heap-arrays")
    else()
      string(APPEND CMAKE_Fortran_FLAGS " -nowarn")
    endif()
  elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
    add_compile_options(-mtune=native)
    string(APPEND CMAKE_Fortran_FLAGS " -w ${_gcc10opts}")
    if(MINGW)
      # presumably using MS-MPI, which emits extreme amounts of nuisance warnings
      string(APPEND CMAKE_Fortran_FLAGS " -w")
    endif(MINGW)
  endif()
endif()
