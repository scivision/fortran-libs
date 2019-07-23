
cargs = '-DAdd_'

comm_src = files('lr_common.F', 'ana_omp_m.F', 'ana_orderings_wrappers_m.F', 'mumps_memory_mod.F',
  'mumps_static_mapping.F', 'mumps_sol_es.F', 'fac_future_niv2_mod.F', 'mumps_comm_ibcast.F', 'mumps_ooc_common.F',
  'double_linked_list.F', 'fac_asm_build_sort_index_m.F', 'fac_asm_build_sort_index_ELT_m.F', 'omp_tps_common_m.F',
  'mumps_l0_omp_m.F', 'front_data_mgt_m.F', 'fac_maprow_data_m.F', 'fac_descband_data_m.F', 'fac_ibct_data_m.F',
  'ana_orderings.F', 'ana_AMDMF.F', 'bcast_errors.F', 'estim_flops.F', 'mumps_type_size.F', 'mumps_type2_blocking.F',
  'mumps_version.F', 'tools_common.F', 'mumps_print_defined.F', 'mumps_common.c', 'mumps_size.c', 'mumps_io_err.c',
  'ana_set_ordering.F', 'mumps_numa.c', 'mumps_thread.c', 'mumps_save_restore_C.c')

ioc_src = files('mumps_io.c', 'mumps_io_basic.c', 'mumps_io_thread.c')

# -- MUMPS BUILD
mumps_common = library('mumps_common', ioc_src, comm_src,
  dependencies : [mpic, mpif, scalapack],
  link_with : pord)

src = files(arith+'ana_aux_par.F', arith+'ana_lr.F', arith+'fac_asm_master_m.F', arith+'fac_asm_master_ELT_m.F',
  arith+'omp_tps_m.F', arith+'mumps_comm_buffer.F', arith+'mumps_load.F', arith+'mumps_lr_data_m.F',
  arith+'mumps_ooc_buffer.F', arith+'mumps_ooc.F', arith+'mumps_struc_def.F', arith+'static_ptr_m.F',
  arith+'lr_core.F', arith+'lr_type.F', arith+'lr_stats.F', arith+'fac_lr.F', arith+'fac_omp_m.F',
  arith+'fac_par_m.F', arith+'fac_front_LU_type1.F', arith+'fac_front_LU_type2.F', arith+'fac_front_LDLT_type1.F',
  arith+'fac_front_LDLT_type2.F', arith+'fac_front_aux.F', arith+'fac_front_type2_aux.F', arith+'mumps_save_restore_files.F',
  arith+'mumps_save_restore.F', arith+'ini_driver.F', arith+'ana_driver.F', arith+'fac_driver.F', arith+'sol_driver.F',
  arith+'end_driver.F', arith+'ana_aux_ELT.F', arith+'ana_aux.F', arith+'ana_dist_m.F', arith+'ana_LDLT_preprocess.F',
  arith+'ana_reordertree.F', arith+'arrowheads.F', arith+'bcast_int.F', arith+'fac_asm_ELT.F', arith+'fac_asm.F',
  arith+'fac_b.F', arith+'fac_distrib_distentry.F', arith+'fac_distrib_ELT.F', arith+'fac_lastrtnelind.F',
  arith+'fac_mem_alloc_cb.F', arith+'fac_mem_compress_cb.F', arith+'fac_mem_free_block_cb.F', arith+'fac_mem_stack_aux.F',
  arith+'fac_mem_stack.F', arith+'fac_process_band.F', arith+'fac_process_blfac_slave.F', arith+'fac_process_blocfacto_LDLT.F',
  arith+'fac_process_blocfacto.F', arith+'fac_process_bf.F', arith+'fac_process_end_facto_slave.F',
  arith+'fac_process_contrib_type1.F', arith+'fac_process_contrib_type2.F', arith+'fac_process_contrib_type3.F',
  arith+'fac_process_maprow.F', arith+'fac_process_master2.F', arith+'fac_process_message.F', arith+'fac_process_root2slave.F',
  arith+'fac_process_root2son.F', arith+'fac_process_rtnelind.F', arith+'fac_root_parallel.F', arith+'fac_scalings.F',
  arith+'fac_determinant.F', arith+'fac_scalings_simScaleAbs.F', arith+'fac_scalings_simScale_util.F', arith+'fac_sol_pool.F',
  arith+'fac_type3_symmetrize.F', arith+'ini_defaults.F', arith+'mumps_driver.F', arith+'mumps_f77.F', arith+'mumps_iXamax.F',
  arith+'ana_mtrans.F', arith+'ooc_panel_piv.F', arith+'rank_revealing.F', arith+'sol_aux.F', arith+'sol_bwd_aux.F',
  arith+'sol_bwd.F', arith+'sol_c.F', arith+'sol_fwd_aux.F', arith+'sol_fwd.F', arith+'sol_matvec.F', arith+'sol_root_parallel.F',
  arith+'tools.F', arith+'type3_root.F', 'fac_future_niv2_mod.F', 'mumps_ooc_common.F', 'mumps_memory_mod.F',
  'ana_orderings_wrappers_m.F', 'mumps_comm_ibcast.F', 'omp_tps_common_m.F', 'fac_ibct_data_m.F',
  'fac_asm_build_sort_index_m.F', 'fac_asm_build_sort_index_ELT_m.F', 'mumps_l0_omp_m.F', 'lr_common.F')

cint_src = files('mumps_c.c')

mumps_lib = library(arith + 'mumps', cint_src, src,
  dependencies : [mpif, mpic, scalapack],
  link_with : mumps_common,
  fortran_args : [cargs, '-DMUMPS_ARITH=MUMPS_ARITH_'+arith],
  c_args :  [cargs, '-DMUMPS_ARITH=MUMPS_ARITH_'+arith],
  include_directories : '../include')

