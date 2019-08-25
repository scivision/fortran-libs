project('MUMPS', 'c', 'fortran',
  version : '5.2.1',
  meson_version: '>=0.50',
  default_options : ['default_library=static', 'buildtype=release', 'warning_level=0',
    'libdir=mumps-5.2.1', 'includedir=mumps-5.2.1/include'])

arith = get_option('arith')
ordering = get_option('ordering')

subdir('cmake')

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

if not meson.is_subproject() or get_option('buildtype') == 'debug'
  subdir('tests')
endif