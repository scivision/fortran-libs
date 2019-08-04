
cargs = '-DAdd_'

mumps_version = meson.project_version()

# -- MUMPS COMMON

if mumps_version.version_compare('>=5.1') and mumps_version.version_compare('<5.2')

comm_src = files(
'lr_common.F', 'ana_omp_m.F', 'ana_orderings_wrappers_m.F', 'mumps_memory_mod.F',
'mumps_static_mapping.F', 'mumps_sol_es.F', 'fac_future_niv2_mod.F', 'mumps_comm_ibcast.F', 'mumps_ooc_common.F',
'double_linked_list.F', 'fac_asm_build_sort_index_m.F', 'fac_asm_build_sort_index_ELT_m.F', 'omp_tps_common_m.F',
'mumps_l0_omp_m.F', 'front_data_mgt_m.F', 'fac_maprow_data_m.F', 'fac_descband_data_m.F', 'fac_ibct_data_m.F',
)

comm_other_src = files(
'ana_orderings.F', 'ana_AMDMF.F', 'bcast_errors.F', 'estim_flops.F', 'mumps_type_size.F', 'mumps_type2_blocking.F',
'mumps_version.F', 'tools_common.F', 'mumps_print_defined.F', 'mumps_common.c', 'mumps_size.c',
'mumps_io.c', 'mumps_io_basic.c', 'mumps_io_thread.c', 'mumps_io_err.c',
'ana_set_ordering.F', 'mumps_numa.c', 'mumps_thread.c', 'mumps_save_restore_C.c'
)

elif mumps_version.version_compare('>=5.2') and mumps_version.version_compare('<5.3')

comm_src = files(
'ana_omp_m.F', 'ana_orderings_wrappers_m.F', 'double_linked_list.F',
'fac_asm_build_sort_index_ELT_m.F', 'fac_asm_build_sort_index_m.F', 'fac_descband_data_m.F',
'fac_future_niv2_mod.F', 'fac_ibct_data_m.F', 'fac_maprow_data_m.F', 'front_data_mgt_m.F', 'lr_common.F',
'mumps_comm_ibcast.F', 'mumps_l0_omp_m.F', 'mumps_memory_mod.F', 'mumps_mpitoomp_m.F', 'mumps_ooc_common.F', 'mumps_static_mapping.F', 'omp_tps_common_m.F',
)

comm_other_src = files(
'ana_orderings.F', 'ana_set_ordering.F', 'ana_AMDMF.F', 'bcast_errors.F', 'estim_flops.F',
'mumps_type_size.F', 'mumps_type2_blocking.F', 'mumps_version.F', 'mumps_print_defined.F',
'mumps_pord.c', 'mumps_metis.c', 'mumps_metis64.c', 'mumps_metis_int.c',
'mumps_scotch.c', 'mumps_scotch64.c', 'mumps_scotch_int.c',
'mumps_common.c', 'mumps_size.c', 'mumps_io.c', 'mumps_io_basic.c', 'mumps_io_thread.c', 'mumps_io_err.c',
'mumps_numa.c', 'mumps_thread.c', 'mumps_save_restore_C.c', 'mumps_config_file_C.c', 'mumps_thread_affinity.c',
'tools_common.F', 'sol_common.F'
)

else
  error('Update meson.build for MUMPS ' + mumps_version)
endif

mumps_common = library('mumps_common',
  sources: [comm_src, comm_other_src],
  dependencies : [mpic, mpif, scalapack],
  include_directories : mumps_inc,
  c_args: cargs,
  link_with : pord,
  install: true,
  install_dir: install_dir,
)

# -- MUMPS LIB

if mumps_version.version_compare('>=5.1') and mumps_version.version_compare('<5.2')

src = files(
arith+'ana_aux_par.F', arith+'ana_lr.F', arith+'fac_asm_master_m.F', arith+'fac_asm_master_ELT_m.F',
arith+'omp_tps_m.F', arith+'mumps_comm_buffer.F', arith+'mumps_load.F', arith+'mumps_lr_data_m.F',
arith+'mumps_ooc_buffer.F', arith+'mumps_ooc.F', arith+'mumps_struc_def.F', arith+'static_ptr_m.F',
arith+'lr_core.F', arith+'lr_type.F', arith+'lr_stats.F', arith+'fac_lr.F', arith+'fac_omp_m.F',
arith+'fac_par_m.F', arith+'fac_front_LU_type1.F', arith+'fac_front_LU_type2.F',
arith+'fac_front_LDLT_type1.F', arith+'fac_front_LDLT_type2.F',
arith+'fac_front_aux.F', arith+'fac_front_type2_aux.F',
arith+'mumps_save_restore_files.F', arith+'mumps_save_restore.F'
)

src_other = files(
arith+'ini_driver.F', arith+'ana_driver.F', arith+'fac_driver.F', arith+'sol_driver.F',
arith+'end_driver.F', arith+'ana_aux_ELT.F', arith+'ana_aux.F', arith+'ana_dist_m.F', arith+'ana_LDLT_preprocess.F',
arith+'ana_reordertree.F', arith+'arrowheads.F', arith+'bcast_int.F', arith+'fac_asm_ELT.F', arith+'fac_asm.F',
arith+'fac_b.F', arith+'fac_distrib_distentry.F', arith+'fac_distrib_ELT.F', arith+'fac_lastrtnelind.F',
arith+'fac_mem_alloc_cb.F', arith+'fac_mem_compress_cb.F', arith+'fac_mem_free_block_cb.F', arith+'fac_mem_stack_aux.F',
arith+'fac_mem_stack.F', arith+'fac_process_band.F', arith+'fac_process_blfac_slave.F', arith+'fac_process_blocfacto_LDLT.F',
arith+'fac_process_blocfacto.F', arith+'fac_process_bf.F', arith+'fac_process_end_facto_slave.F',
arith+'fac_process_contrib_type1.F', arith+'fac_process_contrib_type2.F', arith+'fac_process_contrib_type3.F',
arith+'fac_process_maprow.F', arith+'fac_process_master2.F', arith+'fac_process_message.F',
arith+'fac_process_root2slave.F', arith+'fac_process_root2son.F', arith+'fac_process_rtnelind.F',
arith+'fac_root_parallel.F', arith+'fac_scalings.F', arith+'fac_determinant.F',
arith+'fac_scalings_simScaleAbs.F', arith+'fac_scalings_simScale_util.F', arith+'fac_sol_pool.F',
arith+'fac_type3_symmetrize.F', arith+'ini_defaults.F',
arith+'mumps_driver.F', arith+'mumps_f77.F', arith+'mumps_iXamax.F',
arith+'ana_mtrans.F', arith+'ooc_panel_piv.F', arith+'rank_revealing.F',
arith+'sol_aux.F', arith+'sol_bwd_aux.F', arith+'sol_bwd.F', arith+'sol_c.F',
arith+'sol_fwd_aux.F', arith+'sol_fwd.F', arith+'sol_matvec.F', arith+'sol_root_parallel.F',
arith+'tools.F', arith+'type3_root.F',
# duplicates from common, better way to do this?
'fac_future_niv2_mod.F', 'mumps_ooc_common.F', 'mumps_memory_mod.F',
'ana_orderings_wrappers_m.F', 'mumps_comm_ibcast.F', 'omp_tps_common_m.F', 'fac_ibct_data_m.F',
'fac_asm_build_sort_index_m.F', 'fac_asm_build_sort_index_ELT_m.F', 'mumps_l0_omp_m.F', 'lr_common.F'
)

elif mumps_version.version_compare('>=5.2') and mumps_version.version_compare('<5.3')

src = files(
arith+'ana_aux.F', arith+'ana_aux_par.F', arith+'ana_lr.F', arith+'fac_asm_master_ELT_m.F', arith+'fac_asm_master_m.F',
arith+'fac_front_aux.F', arith+'fac_front_LU_type1.F', arith+'fac_front_LU_type2.F',
arith+'fac_front_LDLT_type1.F', arith+'fac_front_LDLT_type2.F', arith+'fac_front_type2_aux.F',
arith+'fac_lr.F', arith+'fac_mem_dynamic.F', arith+'fac_omp_m.F', arith+'fac_par_m.F',
arith+'lr_core.F', arith+'lr_stats.F', arith+'lr_type.F',
arith+'mumps_comm_buffer.F', arith+'mumps_config_file.F', arith+'mumps_load.F', arith+'mumps_lr_data_m.F',
arith+'mumps_ooc_buffer.F', arith+'mumps_ooc.F', arith+'mumps_sol_es.F',
arith+'mumps_save_restore.F', arith+'mumps_save_restore_files.F',
arith+'mumps_struc_def.F', arith+'omp_tps_m.F', arith+'sol_lr.F', arith+'static_ptr_m.F',
)

src_other = files(
arith+'ini_driver.F', arith+'ana_driver.F', arith+'fac_driver.F', arith+'sol_driver.F', arith+'sol_distrhs.F',
arith+'end_driver.F', arith+'ana_aux_ELT.F', arith+'ana_dist_m.F', arith+'ana_LDLT_preprocess.F',
arith+'ana_reordertree.F', arith+'arrowheads.F', arith+'bcast_int.F', arith+'fac_asm_ELT.F',
arith+'fac_asm.F', arith+'fac_b.F', arith+'fac_distrib_distentry.F', arith+'fac_distrib_ELT.F', arith+'fac_lastrtnelind.F',
arith+'fac_mem_alloc_cb.F', arith+'fac_mem_compress_cb.F', arith+'fac_mem_free_block_cb.F',
arith+'fac_mem_stack_aux.F', arith+'fac_mem_stack.F',
arith+'fac_process_band.F', arith+'fac_process_blfac_slave.F', arith+'fac_process_blocfacto_LDLT.F', arith+'fac_process_blocfacto.F',
arith+'fac_process_bf.F', arith+'fac_process_end_facto_slave.F',
arith+'fac_process_contrib_type1.F', arith+'fac_process_contrib_type2.F', arith+'fac_process_contrib_type3.F',
arith+'fac_process_maprow.F', arith+'fac_process_master2.F', arith+'fac_process_message.F',
arith+'fac_process_root2slave.F', arith+'fac_process_root2son.F', arith+'fac_process_rtnelind.F', arith+'fac_root_parallel.F',
arith+'fac_scalings.F', arith+'fac_determinant.F', arith+'fac_scalings_simScaleAbs.F', arith+'fac_scalings_simScale_util.F',
arith+'fac_sol_pool.F', arith+'fac_type3_symmetrize.F', arith+'ini_defaults.F',
arith+'mumps_driver.F', arith+'mumps_f77.F', arith+'mumps_gpu.c', arith+'mumps_iXamax.F',
arith+'ana_mtrans.F', arith+'ooc_panel_piv.F', arith+'rank_revealing.F',
arith+'sol_aux.F', arith+'sol_bwd_aux.F', arith+'sol_bwd.F', arith+'sol_c.F', arith+'sol_fwd_aux.F', arith+'sol_fwd.F', arith+'sol_matvec.F',
arith+'sol_root_parallel.F', arith+'tools.F', arith+'type3_root.F'
)

endif

cint_src = files('mumps_c.c')

defs = [cargs, '-DMUMPS_ARITH=MUMPS_ARITH_'+arith]

mumps_lib = library(arith + 'mumps',
  sources: [cint_src, src, src_other],
  dependencies : [mpif, mpic, scalapack],
  fortran_args : defs, c_args : defs,
  link_with: mumps_common,
  include_directories : mumps_inc,
  install: true,
  install_dir: install_dir,
)


install_headers(
'../include' / arith+'mumps_c.h',
'../include' / arith+'mumps_root.h',
'../include' / arith+'mumps_struc.h',
'../include' / 'mumps_c_types.h',
'../include' / 'mumps_compat.h',
install_dir: install_dir / 'include',
)
