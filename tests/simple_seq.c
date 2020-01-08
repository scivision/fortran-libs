/*
 *
 *  This file is part of MUMPS 5.2.1, released
 *  on Fri Jun 14 14:46:05 UTC 2019
 *
 */
/* Example program using the C interface to the
 * double real arithmetic version of MUMPS, dmumps_c.
 * We solve the system A x = RHS with
 *   A = diag(1 2) and RHS = [1 4]^T
 * Solution is [1 2]^T */
#include <stdio.h>
#include <string.h>

#include "dmumps_c.h"

#define JOB_INIT -1
#define JOB_END -2


int main(void)
{
  DMUMPS_STRUC_C id;
  MUMPS_INT n = 2;
  MUMPS_INT8 nnz = 2;
  MUMPS_INT irn[] = {1,2};
  MUMPS_INT jcn[] = {1,2};
  double a[2];
  double rhs[2];

   /* Define A and rhs */
  rhs[0]=1.0;rhs[1]=4.0;
  a[0]=1.0;a[1]=2.0;

  /* Initialize a MUMPS instance. */

  id.par=1; id.sym=0;
  id.job=JOB_INIT;
  dmumps_c(&id);

  /* Define the problem on the host */
  id.n = n; id.nnz =nnz; id.irn=irn; id.jcn=jcn;
  id.a = a; id.rhs = rhs;

#define ICNTL(I) icntl[(I)-1] /* macro s.t. indices match documentation */
  /* No outputs */
  id.ICNTL(1)=-1; id.ICNTL(2)=-1; id.ICNTL(3)=-1; id.ICNTL(4)=0;

  /* Call the MUMPS package (analyse, factorization and solve). */
  id.job=6;
  dmumps_c(&id);
  if (id.infog[0]<0) {
    fprintf(stderr,"sequential: ERROR RETURN: \tINFOG(1)= %d\n\t\t\t\tINFOG(2)= %d\n",
        id.infog[0], id.infog[1]);
    return 1;
  }

  /* Terminate instance. */
  id.job=JOB_END;
  dmumps_c(&id);
  printf("Solution is : (%8.2f  %8.2f)\n", rhs[0],rhs[1]);

  return 0;
}
