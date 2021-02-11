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

if(LAPACK_FOUND OR TARGET LAPACK::LAPACK)
# in a stack of FetchContent libraries where Scalapack is invoked later, LAPACK could have been built first in the stack
  return()
endif()


set(lapack_external true CACHE BOOL "build Lapack")

FetchContent_Declare(LAPACK
  GIT_REPOSITORY ${lapack_git}
  GIT_TAG ${lapack_tag}
  CMAKE_ARGS -Darith=${arith})

if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.14)
  FetchContent_MakeAvailable(LAPACK)
elseif(NOT lapack_POPULATED)
  FetchContent_Populate(LAPACK)
  add_subdirectory(${lapack_SOURCE_DIR} ${lapack_BINARY_DIR})
endif()

# this must NOT be an ALIAS or linking breaks.
add_library(LAPACK::LAPACK INTERFACE IMPORTED GLOBAL)
target_link_libraries(LAPACK::LAPACK INTERFACE lapack)
