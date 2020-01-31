include(FetchContent)

FetchContent_Declare(Scalapack_proj
  GIT_REPOSITORY https://github.com/scivision/scalapack.git
  GIT_TAG v2.1.0.2
  CMAKE_ARGS "-Darith=${arith}"
)

FetchContent_MakeAvailable(Scalapack_proj)

set(SCALAPACK_LIBRARIES scalapack::scalapack)