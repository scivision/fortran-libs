option(autobuild "auto-build Lapack and/or Scalapack if missing or broken" true)
option(lapack_external "build Lapack instead of finding")
option(scalapack_external "build ScaLapack instead of finding")
option(mumps_external "build MUMPS instead of finding")

option(dev "developer mode")
option(parallel "parallel or sequential (non-MPI, non-Scalapack)" ON)
option(intsize64 "use 64-bit integers in C and Fortran" OFF)
option(metis "use METIS" OFF)
option(scotch "use Scotch" OFF)
option(openmp "use OpenMP" OFF)
option(mumps_matlab "build optional Matlab interface" OFF)



# --- other options

if(mumps_matlab)
  set(BUILD_SHARED_LIBS true)
endif()

# default build all
if(NOT DEFINED arith)
  set(arith "s;d;c;z")
endif()

if(intsize64)
  add_compile_definitions(INTSIZE64)
endif()

if(dev)

else()
  set(EP_UPDATE_DISCONNECTED true)
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS on)

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()
