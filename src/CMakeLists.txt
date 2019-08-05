set(CDEFS "Add_")


# -- Mumps COMMMON
if(CMAKE_PROJECT_VERSION VERSION_GREATER_EQUAL 5.1 AND CMAKE_PROJECT_VERSION VERSION_LESS 5.2)

set(COMM_SRC
lr_common.F ana_omp_m.F ana_orderings_wrappers_m.F mumps_memory_mod.F
mumps_static_mapping.F mumps_sol_es.F fac_future_niv2_mod.F mumps_comm_ibcast.F mumps_ooc_common.F
double_linked_list.F fac_asm_build_sort_index_m.F fac_asm_build_sort_index_ELT_m.F omp_tps_common_m.F
mumps_l0_omp_m.F front_data_mgt_m.F fac_maprow_data_m.F fac_descband_data_m.F fac_ibct_data_m.F
)

set(COMM_OTHER_SRC
ana_orderings.F ana_AMDMF.F bcast_errors.F estim_flops.F mumps_type_size.F  mumps_type2_blocking.F
mumps_version.F  tools_common.F  mumps_print_defined.F mumps_common.c mumps_size.c
mumps_io.c mumps_io_basic.c mumps_io_thread.c mumps_io_err.c
ana_set_ordering.F mumps_numa.c mumps_thread.c mumps_save_restore_C.c
)

elseif(CMAKE_PROJECT_VERSION VERSION_GREATER_EQUAL 5.2 AND CMAKE_PROJECT_VERSION VERSION_LESS 5.3)

set(COMM_SRC
ana_omp_m.F ana_orderings_wrappers_m.F double_linked_list.F
fac_asm_build_sort_index_ELT_m.F fac_asm_build_sort_index_m.F fac_descband_data_m.F
fac_future_niv2_mod.F fac_ibct_data_m.F fac_maprow_data_m.F front_data_mgt_m.F lr_common.F
mumps_comm_ibcast.F mumps_l0_omp_m.F mumps_memory_mod.F mumps_mpitoomp_m.F mumps_ooc_common.F mumps_static_mapping.F omp_tps_common_m.F
)

set(COMM_OTHER_SRC
ana_orderings.F ana_set_ordering.F ana_AMDMF.F bcast_errors.F estim_flops.F
mumps_type_size.F mumps_type2_blocking.F mumps_version.F mumps_print_defined.F
mumps_pord.c mumps_metis.c mumps_metis64.c mumps_metis_int.c
mumps_scotch.c mumps_scotch64.c mumps_scotch_int.c
mumps_common.c mumps_size.c mumps_io.c mumps_io_basic.c mumps_io_thread.c mumps_io_err.c
mumps_numa.c mumps_thread.c mumps_save_restore_C.c mumps_config_file_C.c mumps_thread_affinity.c
tools_common.F sol_common.F
)

else()
  message(FATAL_ERROR "update to MUMPS src/ list required--raise GitHub issue")
endif()

add_library(mumps_common ${COMM_SRC} ${COMM_OTHER_SRC})
target_link_libraries(mumps_common PRIVATE pord ${SCALAPACK_LIBRARIES} ${LAPACK_LIBRARIES} MPI::MPI_Fortran MPI::MPI_C)
target_include_directories(mumps_common PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../include)
target_compile_definitions(mumps_common PRIVATE ${CDEFS})


# -- Mumps
if(CMAKE_PROJECT_VERSION VERSION_GREATER_EQUAL 5.1 AND CMAKE_PROJECT_VERSION VERSION_LESS 5.2)

set(SRC
${arith}ana_aux_par.F  ${arith}ana_lr.F ${arith}fac_asm_master_m.F ${arith}fac_asm_master_ELT_m.F
${arith}omp_tps_m.F ${arith}mumps_comm_buffer.F ${arith}mumps_load.F ${arith}mumps_lr_data_m.F
${arith}mumps_ooc_buffer.F ${arith}mumps_ooc.F ${arith}mumps_struc_def.F ${arith}static_ptr_m.F
${arith}lr_core.F ${arith}lr_type.F ${arith}lr_stats.F ${arith}fac_lr.F ${arith}fac_omp_m.F
${arith}fac_par_m.F ${arith}fac_front_LU_type1.F ${arith}fac_front_LU_type2.F
${arith}fac_front_LDLT_type1.F ${arith}fac_front_LDLT_type2.F
${arith}fac_front_aux.F ${arith}fac_front_type2_aux.F
${arith}mumps_save_restore_files.F ${arith}mumps_save_restore.F
)

set(SRC_OTHER
${arith}ini_driver.F ${arith}ana_driver.F ${arith}fac_driver.F ${arith}sol_driver.F
${arith}end_driver.F ${arith}ana_aux_ELT.F ${arith}ana_aux.F ${arith}ana_dist_m.F ${arith}ana_LDLT_preprocess.F
${arith}ana_reordertree.F ${arith}arrowheads.F ${arith}bcast_int.F ${arith}fac_asm_ELT.F ${arith}fac_asm.F
${arith}fac_b.F ${arith}fac_distrib_distentry.F ${arith}fac_distrib_ELT.F ${arith}fac_lastrtnelind.F
${arith}fac_mem_alloc_cb.F ${arith}fac_mem_compress_cb.F ${arith}fac_mem_free_block_cb.F ${arith}fac_mem_stack_aux.F
${arith}fac_mem_stack.F ${arith}fac_process_band.F ${arith}fac_process_blfac_slave.F ${arith}fac_process_blocfacto_LDLT.F
${arith}fac_process_blocfacto.F ${arith}fac_process_bf.F ${arith}fac_process_end_facto_slave.F
${arith}fac_process_contrib_type1.F ${arith}fac_process_contrib_type2.F ${arith}fac_process_contrib_type3.F
${arith}fac_process_maprow.F ${arith}fac_process_master2.F ${arith}fac_process_message.F
${arith}fac_process_root2slave.F ${arith}fac_process_root2son.F ${arith}fac_process_rtnelind.F
${arith}fac_root_parallel.F ${arith}fac_scalings.F ${arith}fac_determinant.F
${arith}fac_scalings_simScaleAbs.F ${arith}fac_scalings_simScale_util.F ${arith}fac_sol_pool.F
${arith}fac_type3_symmetrize.F ${arith}ini_defaults.F
${arith}mumps_driver.F ${arith}mumps_f77.F ${arith}mumps_iXamax.F
${arith}ana_mtrans.F ${arith}ooc_panel_piv.F ${arith}rank_revealing.F
${arith}sol_aux.F ${arith}sol_bwd_aux.F ${arith}sol_bwd.F ${arith}sol_c.F
${arith}sol_fwd_aux.F ${arith}sol_fwd.F ${arith}sol_matvec.F ${arith}sol_root_parallel.F
${arith}tools.F ${arith}type3_root.F
# these are duplicates from common--better way to do this?
fac_future_niv2_mod.F  mumps_memory_mod.F ana_orderings_wrappers_m.F mumps_comm_ibcast.F omp_tps_common_m.F fac_ibct_data_m.F fac_asm_build_sort_index_m.F fac_asm_build_sort_index_ELT_m.F mumps_l0_omp_m.F lr_common.F)

elseif(CMAKE_PROJECT_VERSION VERSION_GREATER_EQUAL 5.2 AND CMAKE_PROJECT_VERSION VERSION_LESS 5.3)

set(SRC
${arith}ana_aux.F ${arith}ana_aux_par.F ${arith}ana_lr.F ${arith}fac_asm_master_ELT_m.F ${arith}fac_asm_master_m.F
${arith}fac_front_aux.F ${arith}fac_front_LU_type1.F ${arith}fac_front_LU_type2.F
${arith}fac_front_LDLT_type1.F ${arith}fac_front_LDLT_type2.F ${arith}fac_front_type2_aux.F
${arith}fac_lr.F ${arith}fac_mem_dynamic.F ${arith}fac_omp_m.F ${arith}fac_par_m.F
${arith}lr_core.F ${arith}lr_stats.F ${arith}lr_type.F
${arith}mumps_comm_buffer.F ${arith}mumps_config_file.F ${arith}mumps_load.F ${arith}mumps_lr_data_m.F
${arith}mumps_ooc_buffer.F ${arith}mumps_ooc.F ${arith}mumps_sol_es.F
${arith}mumps_save_restore.F ${arith}mumps_save_restore_files.F
${arith}mumps_struc_def.F ${arith}omp_tps_m.F ${arith}sol_lr.F ${arith}static_ptr_m.F
)

set(SRC_OTHER
${arith}ini_driver.F ${arith}ana_driver.F ${arith}fac_driver.F ${arith}sol_driver.F ${arith}sol_distrhs.F
${arith}end_driver.F ${arith}ana_aux_ELT.F ${arith}ana_dist_m.F ${arith}ana_LDLT_preprocess.F
${arith}ana_reordertree.F ${arith}arrowheads.F ${arith}bcast_int.F ${arith}fac_asm_ELT.F
${arith}fac_asm.F ${arith}fac_b.F ${arith}fac_distrib_distentry.F ${arith}fac_distrib_ELT.F ${arith}fac_lastrtnelind.F
${arith}fac_mem_alloc_cb.F ${arith}fac_mem_compress_cb.F ${arith}fac_mem_free_block_cb.F
${arith}fac_mem_stack_aux.F ${arith}fac_mem_stack.F
${arith}fac_process_band.F ${arith}fac_process_blfac_slave.F ${arith}fac_process_blocfacto_LDLT.F ${arith}fac_process_blocfacto.F
${arith}fac_process_bf.F ${arith}fac_process_end_facto_slave.F
${arith}fac_process_contrib_type1.F ${arith}fac_process_contrib_type2.F ${arith}fac_process_contrib_type3.F
${arith}fac_process_maprow.F ${arith}fac_process_master2.F ${arith}fac_process_message.F
${arith}fac_process_root2slave.F ${arith}fac_process_root2son.F ${arith}fac_process_rtnelind.F ${arith}fac_root_parallel.F
${arith}fac_scalings.F ${arith}fac_determinant.F ${arith}fac_scalings_simScaleAbs.F ${arith}fac_scalings_simScale_util.F
${arith}fac_sol_pool.F ${arith}fac_type3_symmetrize.F ${arith}ini_defaults.F
${arith}mumps_driver.F ${arith}mumps_f77.F ${arith}mumps_gpu.c ${arith}mumps_iXamax.F
${arith}ana_mtrans.F ${arith}ooc_panel_piv.F ${arith}rank_revealing.F
${arith}sol_aux.F ${arith}sol_bwd_aux.F ${arith}sol_bwd.F ${arith}sol_c.F ${arith}sol_fwd_aux.F ${arith}sol_fwd.F ${arith}sol_matvec.F
${arith}sol_root_parallel.F ${arith}tools.F ${arith}type3_root.F
)
endif()

set(CINT_SRC mumps_c.c)

add_library(${arith}mumps ${CINT_SRC} ${SRC} ${SRC_OTHER})
target_compile_definitions(${arith}mumps
  PRIVATE MUMPS_ARITH=MUMPS_ARITH_${arith}
  PRIVATE ${CDEFS})
target_include_directories(${arith}mumps PRIVATE ${CMAKE_SOURCE_DIR}/include)
target_link_libraries(${arith}mumps PRIVATE
  mumps_common
  ${SCALAPACK_LIBRARIES} ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES} MPI::MPI_Fortran MPI::MPI_C)
