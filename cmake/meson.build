fc = meson.get_compiler('fortran')
cc = meson.get_compiler('c')

if fc.get_id() == 'intel-cl'
  # /fpp is necessary for any Fortran preprocessing statement with Intel ifort on Windows
  # https://software.intel.com/en-us/fortran-compiler-developer-guide-and-reference-fpp
   add_project_arguments('/fpp', language: 'fortran')
endif

if meson.is_subproject()
  quiet = fc.first_supported_argument(['-w', '-nowarn', '/nowarn'])
  add_project_arguments(quiet, language: 'fortran')
endif

# == MPI
mpiexec = find_program('mpiexec', required: false, disabler: true)
mpif = dependency('mpi', language : 'fortran')
if mpif.found() and not fc.links('use mpi; end', dependencies : mpif, name: 'Fortran MPI')
  mpif = disabler()
endif

mpic_code = '''
#include <mpi.h>
int main() { MPI_Init(NULL, NULL); MPI_Finalize(); return 0;}
'''
mpic = dependency('mpi', language : 'c')
if mpic.found() and not cc.links(mpic_code, dependencies: mpic, name: 'C MPI')
  mpic = disabler()
endif

# == Lapack
system_blas = get_option('system_blas')

blas = disabler()
if system_blas
  blas = dependency('blas', required: false, disabler: true)
  if not blas.found()  # necessary for some systems incl. CentOS 7
    blas = fc.find_library('blas', required: false, disabler: true)
  endif
endif
if blas.found() and not fc.links('x=dnrm2(1, [2.], 1); end', dependencies: blas, name: 'BLAS')
  blas = disabler()
endif

lapack = disabler()
if system_blas and blas.found()
  lapack = dependency('lapack', cmake_module_path: 'cmake/Modules', required: false, disabler: true)
endif
if lapack.found() and not fc.links('print *,disnan(0.); end', dependencies: lapack, name: 'LAPACK')
  lapack = disabler()
endif
if not lapack.found() or not blas.found()
  lapack_proj = subproject('lapack')
  lapack = lapack_proj.get_variable('lapack')
  blas = lapack_proj.get_variable('blas')
endif

# == Scalapack
# dependency('scalapack') not yet working in Meson--cmake->meson bug within Meson, yielding long meson-log.txt
# scalapack = dependency('scalapack')

scalapack = disabler()
if system_blas
  scalapack_root = get_option('SCALAPACK_ROOT')
  if scalapack_root == ''  # system
    scalapack = fc.find_library('scalapack-openmpi', required: false, disabler: true)
    if not scalapack.found()
      scalapack = fc.find_library('scalapack', required: false, disabler: true)
    endif
  else
    message('searching for SCALAPACK in ' + scalapack_root)
    scalapack = fc.find_library('scalapack', dirs : scalapack_root / 'lib', required: false, disabler: true)
  endif
endif
if scalapack.found() and not fc.links('L = numroc(1,1,1,1,1); end', dependencies: scalapack, name: 'SCALAPACK')
  scalapack = disabler()
endif
if not scalapack.found()
  scalapack_proj = subproject('scalapack')
  scalapack = declare_dependency(link_with: scalapack_proj.get_variable('scalapack_lib'))
endif
