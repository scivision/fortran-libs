fc = meson.get_compiler('fortran')
fcid = fc.get_id()
cc = meson.get_compiler('c')
ccid = cc.get_id()

if fcid == 'intel-cl'
  # /fpp is necessary for any Fortran preprocessing statement with Intel ifort on Windows
  # https://software.intel.com/en-us/fortran-compiler-developer-guide-and-reference-fpp
   add_project_arguments('/fpp', language: 'fortran')
endif

if meson.is_subproject()
  # this acts like warning_level=0
  if fcid == 'intel-cl'
     add_project_arguments('/nowarn', language: 'fortran')
  elif fcid == 'intel'
    add_project_arguments('-nowarn', language: 'fortran')
  else
    add_project_arguments('-w', language: 'fortran')
  endif
endif

# == MPI
# if MPI_ROOT, assume compiler wrapper is usable
mpiroot = get_option('MPI_ROOT')
if mpiroot == ''
  mpiexec = find_program('mpiexec')
  mpif = dependency('mpi', language : 'fortran')
  mpiret = fc.run('use mpi; end', dependencies : mpif, name: 'Fortran MPI')
  if mpiret.returncode() != 0
    warning('MPI_Fortran does not link properly: ' + mpiret.stderr() + ' ' + mpiret.stdout())
  endif
else
  fc.run('use mpi; integer :: i; call mpi_init(i); call mpi_finalize(i); end', name: 'Fortran MPI wrapper check')
  mpiexec = find_program(mpiroot / 'mpiexec')
  mpif = []
endif

mpic_code = '''
#include <mpi.h>
int main() { MPI_Init(NULL, NULL); MPI_Finalize(); return 0;}
'''
if mpiroot == ''
  mpic = dependency('mpi', language : 'c')
  if cc.run(mpic_code, dependencies: mpic, name: 'C MPI').returncode() != 0
    warning('MPI_C does not link properly')
  endif
else
  cc.run(mpic_code, name: 'C MPI compiler wrapper')
  mpic = []
endif

# == Scalapack
# dependency('scalapack') not yet working in Meson--cmake->meson bug within Meson, yielding long meson-log.txt
# scalapack = dependency('scalapack')
system_blas = get_option('system_blas')
if system_blas # or fcid.contains('intel')
  scalapack_root = get_option('SCALAPACK_ROOT')
  if scalapack_root == ''  # system
    scalapack = fc.find_library('scalapack-openmpi', required: false)
    if not scalapack.found()
      scalapack = fc.find_library('scalapack', required: false)
    endif
  else
    message('searching for SCALAPACK in ' + scalapack_root)
    scalapack = fc.find_library('scalapack', dirs : scalapack_root / 'lib', required: false)
  endif

  lapack = dependency('lapack', cmake_module_path: 'cmake/Modules', required: false)
  blas = dependency('blas', required: false)
  if not blas.found()  # necessary for some systems incl. CentOS 7
    blas = fc.find_library('blas', required: false)
  endif
else
  blas = disabler()
  lapack = disabler()
  scalapack = disabler()
endif
if not lapack.found() or not blas.found()
  lapack_proj = subproject('lapack')
  lapack = lapack_proj.get_variable('lapack')
  blas = lapack_proj.get_variable('blas')
endif
if not scalapack.found()
  scalapack_proj = subproject('scalapack')
  scalapack = declare_dependency(link_with: scalapack_proj.get_variable('scalapack_lib'))
endif