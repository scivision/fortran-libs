# Finds Scalapack, tests, and if not found or broken, autobuild scalapack
include(FetchContent)

if(NOT scalapack_external)
  if(autobuild)
    find_package(SCALAPACK)
  else()
    find_package(SCALAPACK REQUIRED)
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
