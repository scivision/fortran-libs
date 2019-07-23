project('MUMPS', 'c', 'fortran',
  version : '5.1.2',
  meson_version: '>=0.50',
  default_options : ['default_library=static', 'buildtype=release'])

arith = 'd'
ordering = 'PORD'

fc = meson.get_compiler('fortran')

mpic = dependency('mpi', language : 'c')
mpif = dependency('mpi', language : 'fortran')

# dependency('scalapack') not yet working in Meson--cmake->meson bug within Meson, yielding long meson-log.txt
# scalapack = dependency('scalapack')
scalapack_root = get_option('SCALAPACK_ROOT')
if scalapack_root == ''
  scalapack_lib = fc.find_library('scalapack-openmpi')
else
  message('searching for SCALAPACK in ' + scalapack_root)
  scalapack_lib = fc.find_library('scalapack', dirs : scalapack_root / 'lib')
endif
scalapack = declare_dependency(dependencies: scalapack_lib)


subdir('PORD')

subdir('src')

subdir('tests')
