project('MUMPS', 'c', 'fortran',
  version : '5.2.1',
  meson_version: '>=0.50',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=0',
    'libdir=mumps-5.2.1/lib', 'includedir=mumps-5.2.1/include'])

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
  scalapack = fc.find_library('scalapack-openmpi', required: false)
  if not scalapack.found()
    scalapack = fc.find_library('scalapack', required: false)
  endif
else
  message('searching for SCALAPACK in ' + scalapack_root)
  scalapack = fc.find_library('scalapack', dirs : scalapack_root / 'lib', required: false)
endif
if not scalapack.found()
  scalapack_proj = subproject('scalapack')
  scalapack = declare_dependency(link_with: scalapack_proj.get_variable('scalapack_lib'))
endif

lapack = dependency('lapack', cmake_module_path: 'cmake/Modules', required: false)
blas = dependency('blas', required: false)
if not blas.found()  # necessary for some systems incl. CentOS 7
  blas = fc.find_library('blas', required: false)
endif
if not lapack.found() or not blas.found()
  lapack_proj = subproject('lapack')
  lapack = lapack_proj.get_variable('lapack')
  blas = lapack_proj.get_variable('blas')
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
