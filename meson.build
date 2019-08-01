project('MUMPS', 'c', 'fortran',
  version : '5.2.1',
  meson_version: '>=0.50',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=0'])

arith = get_option('ARITH')
ordering = get_option('ordering')

fc = meson.get_compiler('fortran')

mpic = dependency('mpi', language : 'c')
mpif = dependency('mpi', language : 'fortran')

# dependency('scalapack') not yet working in Meson--cmake->meson bug within Meson, yielding long meson-log.txt
# scalapack = dependency('scalapack')
scalapack_root = get_option('SCALAPACK_ROOT')
if scalapack_root == ''  # system
  scalapack_lib = fc.find_library('scalapack-openmpi', required: false)
  if not scalapack_lib.found()
    scalapack_lib = fc.find_library('scalapack')
  endif
else
  message('searching for SCALAPACK in ' + scalapack_root)
  scalapack_lib = fc.find_library('scalapack', dirs : scalapack_root / 'lib')
endif
lapack = dependency('lapack')
blas = dependency('blas')
threads = dependency('threads')
scalapack = declare_dependency(dependencies: [scalapack_lib, lapack, blas, threads])


subdir('PORD')

subdir('src')

subdir('tests')
