# Finds Lapack, tests, and if not found or broken, autobuild Lapack
include(FetchContent)

if(intsize64)
  if(MKL IN_LIST LAPACK_COMPONENTS)
    list(APPEND LAPACK_COMPONENTS MKL64)
  else()
    if(NOT (OpenBLAS IN_LIST LAPACK_COMPONENTS
      OR Netlib IN_LIST LAPACK_COMPONENTS
      OR Atlas IN_LIST LAPACK_COMPONENTS
      OR MKL IN_LIST LAPACK_COMPONENTS))
      if(DEFINED ENV{MKLROOT})
        list(APPEND LAPACK_COMPONENTS MKL MKL64)
      endif()
    endif()
  endif()
endif()

if(NOT lapack_external)
  if(autobuild)
    find_package(LAPACK COMPONENTS ${LAPACK_COMPONENTS})
  else()
    find_package(LAPACK REQUIRED COMPONENTS ${LAPACK_COMPONENTS})
  endif()
endif()

if(NOT LAPACK_FOUND)
  set(lapack_external true CACHE BOOL "autobuild Lapack")

  FetchContent_Declare(LAPACK
    GIT_REPOSITORY ${lapack_url}
    GIT_TAG ${lapack_tag}
    CMAKE_ARGS "-Darith=${arith}")

  FetchContent_MakeAvailable(LAPACK)

  add_library(LAPACK::LAPACK ALIAS lapack)
  add_library(BLAS::BLAS ALIAS blas)
endif()
