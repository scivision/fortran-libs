# Finds Scalapack, tests, and if not found or broken, autobuild scalapack

if(autobuild)
  find_package(SCALAPACK COMPONENTS ${arith})
else()
  find_package(SCALAPACK REQUIRED COMPONENTS ${arith})
endif()

if(NOT SCALAPACK_FOUND)
  set(scalapack_external true CACHE BOOL "autobuild ScaLapack")

  include(FetchContent)

  FetchContent_Declare(scalapack_proj
    GIT_REPOSITORY ${scalapack_url}
    GIT_TAG ${scalapack_tag}
    GIT_SHALLOW true
    UPDATE_DISCONNECTED true
    CMAKE_ARGS "-Darith=${arith}"
  )

  FetchContent_MakeAvailable(scalapack_proj)
endif()

# not linking LAPACK to SCALAPACK here because it fails on Mac when used as subproject
