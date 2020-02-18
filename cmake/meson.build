fc = meson.get_compiler('fortran')
cc = meson.get_compiler('c')
os = target_machine.system()

if fc.get_id() == 'intel-cl'
  # /fpp is necessary for any Fortran preprocessing statement with Intel ifort on Windows
  # https://software.intel.com/en-us/fortran-compiler-developer-guide-and-reference-fpp
  add_project_arguments('/fpp', language: 'fortran')
  # /heap-arrays necessary for intel-cl to avoid runtime errors
  add_project_arguments('/heap-arrays', language: 'fortran')
  # FIXME: this is a workaround for Intel Compiler icl bug: https://www.scivision.dev/intel-compiler-windows-bug-workaround
  if not cc.compiles(files('../PORD/lib/sort.c'), include_directories: include_directories('../PORD/include'), name: 'ICL MSVC')
    add_project_arguments('/TP', language: 'c')
    message('applying workaround for Intel ICL bug with MSVC: https://www.scivision.dev/intel-compiler-windows-bug-workaround')
  endif
endif

if meson.is_subproject()
  quiet = fc.first_supported_argument(['-w', '-nowarn', '/nowarn'])
  add_project_arguments(quiet, language: 'fortran')
endif

# -- MKL (in general, MKL can be used with intel, intel-cl, gcc or PGI)
mklroot = get_option('mklroot')
mkllib_root = mklroot/'lib/intel64'

# == MPI
mpic = []
mpif = []
if parallel
  mpiexec = find_program('mpiexec')
  mpif = dependency('mpi', language : 'fortran')
  if mpif.found() and not fc.links('use mpi; end', dependencies : mpif, name: 'Fortran MPI')
    error('MUMPS Fortran not working, and MUMPS uses MPI throughout. Try option -Dparallel=false')
  endif

  # stdio.h is necessary for IntelMPI
  mpic_code = '''
  #include <mpi.h>
  #include <stdio.h>
  int main() { MPI_Init(NULL, NULL); MPI_Finalize(); return 0;}
  '''
  mpic = dependency('mpi', language : 'c')
  if mpic.found() and not cc.links(mpic_code, dependencies: mpic, name: 'C MPI')
    error('MUMPS C not working, and MUMPS uses MPI throughout. Try "meson -Dparallel=false"')
  endif
endif

# --- OpenMP
openmp = []
if parallel and get_option('openmp')
  if mklroot == ''
    openmp = dependency('openmp')
  else
    n = os == 'windows' ? 'iomp5md' : 'iomp5'
    openmp = fc.find_library(n, dirs: mklroot / '../compiler/lib/intel64')
  endif
endif

# == Lapack
if mklroot == ''
  blas = dependency('blas', required: false, disabler: true)
  if not blas.found()  # necessary for some systems incl. CentOS 7
    blas = fc.find_library('blas', required: false, disabler: true)
  endif
  if blas.found() and not fc.links('x=dnrm2(1, [2.], 1); end', dependencies: blas, name: 'BLAS')
    blas = disabler()
  endif

  lapack = dependency('lapack', required: false, disabler: true)
  if not lapack.found()
    lapack = fc.find_library('lapack', required: false, disabler: true)
  endif
  if lapack.found() and not fc.links('print *,disnan(0.); end', dependencies: lapack, name: 'LAPACK')
    lapack = disabler()
  endif
  if not lapack.found() or not blas.found()
    lapack_proj = subproject('lapack')
    lapack = declare_dependency(link_with: lapack_proj.get_variable('lapack'))
    blas = declare_dependency(link_with: lapack_proj.get_variable('blas'))
  endif
else
  # MKL
  lapack = []
  n1 = fc.get_id() == 'gcc' ? 'mkl_gf_lp64' : 'mkl_intel_lp64'
  m = get_option('openmp') ? 'mkl_intel_thread' : 'mkl_sequential'
  names = [n1, m, 'mkl_core']
  foreach n : names
    lapack += fc.find_library(n, dirs: mkllib_root)
  endforeach
  blas = lapack
endif

intelmpi_lib = []
if parallel
  # --- intel MPI lib for Windows
  if mklroot != '' and os == 'windows'
    intelmpi_lib = fc.find_library('impi', dirs: mklroot / '../mpi/intel64/lib/release')
  endif
endif

# --- Find BLACS
# some systems need Blacs explicitly, but most don't, so don't pass disabler() if not found.
blacs = []
if parallel
  if mklroot == ''
    blacs = fc.find_library('blacs-openmpi', required: false)
    if not blacs.found()
      blacs = []
    endif
  else
    blacs += fc.find_library('mkl_blacs_intelmpi_lp64', dirs: mkllib_root)
    blacs += intelmpi_lib
  endif
endif

# --- Find Scalapack
scalapack = []
if parallel
  scalapack = dependency('scalapack', required: false, disabler: true)
  if not fc.links('L = numroc(1,1,1,1,1); end', dependencies: scalapack, name: 'SCALAPACK')
    scalapack = disabler()
  endif

  if not scalapack.found()
    scalapack_proj = subproject('scalapack')
    scalapack = declare_dependency(link_with: scalapack_proj.get_variable('scalapack_lib'))
  endif
endif
