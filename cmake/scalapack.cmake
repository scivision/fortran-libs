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

if(NOT SCALAPACK_FOUND)
  set(scalapack_external true CACHE BOOL "autobuild ScaLapack")

  FetchContent_Declare(SCALAPACK
    GIT_REPOSITORY ${scalapack_url}
    GIT_TAG ${scalapack_tag}
    CMAKE_ARGS "-Darith=${arith}")

  FetchContent_MakeAvailable(SCALAPACK)
endif()

# not linking LAPACK to SCALAPACK here because it fails on Mac when used as subproject
