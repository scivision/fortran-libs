# -- generated MUMPS_INTSIZE64 header
conf_data = configuration_data()
conf_data.set('MUMPS_INTSIZE', get_option('intsize64') ? 'MUMPS_INTSIZE64' : 'MUMPS_INTSIZE32')
configure_file(
  input : 'mumps_int_def.h.in',
  output : 'mumps_int_def.h',
  configuration : conf_data,
  install: true,
  install_dir : 'include')