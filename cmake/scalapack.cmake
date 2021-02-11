# Finds Scalapack, tests, and if not found or broken, autobuild scalapack
include(FetchContent)

if(intsize64)
  if(MKL IN_LIST SCALAPACK_COMPONENTS)
    list(APPEND SCALAPACK_COMPONENTS MKL64)
  else()
    if(NOT (OpenMPI IN_LIST SCALAPACK_COMPONENTS
        OR MPICH IN_LIST SCALAPACK_COMPONENTS
        OR MKL IN_LIST SCALAPACK_COMPONENTS))
      if(DEFINED ENV{MKLROOT})
        list(APPEND SCALAPACK_COMPONENTS MKL MKL64)
      endif()
    endif()
  endif()
endif()

if(NOT scalapack_external)
  if(autobuild)
    find_package(SCALAPACK COMPONENTS ${SCALAPACK_COMPONENTS})
  else()
    find_package(SCALAPACK REQUIRED COMPONENTS ${SCALAPACK_COMPONENTS})
  endif()
endif()

if(SCALAPACK_FOUND OR TARGET SCALAPACK::SCALAPACK)
# in a stack of FetchContent libraries where MUMPS is invoked later, SCALAPACK could have been built first in the stack
  return()
endif()


set(scalapack_external true CACHE BOOL "build ScaLapack")

FetchContent_Declare(SCALAPACK
  GIT_REPOSITORY ${scalapack_git}
  GIT_TAG ${scalapack_tag}
  CMAKE_ARGS -Darith=${arith})

if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.14)
  FetchContent_MakeAvailable(SCALAPACK)
elseif(NOT scalapack_POPULATED)
  FetchContent_Populate(SCALAPACK)
  add_subdirectory(${scalapack_SOURCE_DIR} ${scalapack_BINARY_DIR})
endif()
