project('MUMPS', 'c', 'fortran',
  version : '5.2.1',
  meson_version: '>=0.50',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=0',
    'libdir=mumps-5.2.1', 'includedir=mumps-5.2.1/include'])

arith = get_option('arith')
ordering = get_option('ordering')

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
# check if MPI compiler wrapper is usable
if fc.run('use mpi; end', name: 'Fortran MPI compiler wrapper').returncode() == 0
  mpif = []
  mpiroot = get_option('MPI_ROOT')
  if mpiroot == ''
    error('please specify -DMPI_ROOT= root path of MPI lib e.g. ~/lib/openmpi-3.1.4')
  endif
  mpiexec = find_program(mpiroot / 'bin/mpiexec')
else
  mpif = dependency('mpi', language : 'fortran')
  mpiret = fc.run('use mpi; end', dependencies : mpif, name: 'Fortran MPI')
  if mpiret.returncode() != 0
    error('MPI does not link properly: ' + mpiret.stderr() + ' ' + mpiret.stdout())
  endif
  mpiexec = find_program('mpiexec')
endif

mpic_code = '''
#include <mpi.h>
int main() { MPI_Init(NULL, NULL); MPI_Finalize(); return 0;}
'''
if cc.run(mpic_code, name: 'C MPI compiler wrapper').returncode() == 0
  mpic = []
else
  mpic = dependency('mpi', language : 'c')
  mpiret = cc.run(mpic_code, dependencies : mpic, name: 'C MPI')
  if mpiret.returncode() != 0
    error('MPI does not link properly: ' + mpiret.stderr() + ' ' + mpiret.stdout())
  endif
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

threads = dependency('threads')
scalapack = declare_dependency(dependencies: [scalapack, lapack, blas, threads])

mumps_inc = include_directories('include')

subdir('PORD')

subdir('src')

# --- generate pkg-config
pkg = import('pkgconfig')
pkg.generate(mumps_lib,
  url: 'https://github.com/scivision/mumps',
  description: 'MUMPS')

mumps = declare_dependency(
include_directories: mumps_inc,
link_with: [mumps_lib, mumps_common, pord]
)

subdir('tests')
