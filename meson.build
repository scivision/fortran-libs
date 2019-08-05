project('MUMPS', 'c', 'fortran',
  version : '5.2.1',
  meson_version: '>=0.50',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=0'])

arith = get_option('arith')
ordering = get_option('ordering')

# under prefix.  example: --prefix ~/.local then ~/.local/mumps-5.2.1/lib{pord,common,dmumps}.a
install_dir = 'mumps-'+meson.project_version()

fc = meson.get_compiler('fortran')

mpic = dependency('mpi', language : 'c')
mpif = dependency('mpi', language : 'fortran')

# dependency('scalapack') not yet working in Meson--cmake->meson bug within Meson, yielding long meson-log.txt
# scalapack = dependency('scalapack')
scalapack_root = get_option('SCALAPACK_ROOT')
if scalapack_root == ''  # system
  scalapack_lib = fc.find_library('scalapack-openmpi', required: false)
  if not scalapack_lib.found()
    scalapack_lib = fc.find_library('scalapack', required: false)
  endif
  if not scalapack_lib.found()
    scalapack_proj = subproject('scalapack')
    scalapack_lib = scalapack_proj.get_variable('scalapack_lib')
  endif
else
  message('searching for SCALAPACK in ' + scalapack_root)
  scalapack_lib = fc.find_library('scalapack', dirs : scalapack_root / 'lib')
endif
lapack = dependency('lapack', cmake_module_path: 'cmake/Modules')
blas = dependency('blas')
threads = dependency('threads')
scalapack = declare_dependency(dependencies: [scalapack_lib, lapack, blas, threads])

mumps_inc = include_directories('include')

subdir('PORD')

subdir('src')

mumps = declare_dependency(
include_directories: mumps_inc,
link_with: [mumps_lib, mumps_common, pord]
)

subdir('tests')
