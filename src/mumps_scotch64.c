/*
 *
 *  This file is part of MUMPS 5.3.5, released
 *  on Thu Oct 22 09:29:08 UTC 2020
 *
 *
 *  Copyright 1991-2020 CERFACS, CNRS, ENS Lyon, INP Toulouse, Inria,
 *  Mumps Technologies, University of Bordeaux.
 *
 *  This version of MUMPS is provided to you free of charge. It is
 *  released under the CeCILL-C license 
 *  (see doc/CeCILL-C_V1-en.txt, doc/CeCILL-C_V1-fr.txt, and
 *  https://cecill.info/licences/Licence_CeCILL-C_V1-en.html)
 *
 */
/* Interfacing with 64-bit SCOTCH and pt-SCOTCH */
#include "mumps_scotch64.h"
#if defined(scotch) || defined(ptscotch)
void MUMPS_CALL
MUMPS_SCOTCH_64( const MUMPS_INT8 * const  n,        /* in    */
                 const MUMPS_INT8 * const  iwlen,    /* in    */
                       MUMPS_INT8 * const  petab,    /* inout */
                 const MUMPS_INT8 * const  pfree,    /* in    */
                       MUMPS_INT8 * const  lentab,   /* in (modified in ANA_H) */
                       MUMPS_INT8 * const  iwtab,    /* in (modified in ANA_H) */
                       MUMPS_INT8 * const  nvtab,    /* out   */
                       MUMPS_INT8 * const  elentab,  /* out   */
                       MUMPS_INT8 * const  lasttab,  /* out   */
                       MUMPS_INT  * const  ncmpa )   /* out   */
{
     *ncmpa = esmumps( *n, *iwlen, petab, *pfree,
                       lentab, iwtab, nvtab, elentab, lasttab );
}
#endif
