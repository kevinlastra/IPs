// RISC-V Compliance IO Test Header File


#ifndef _COMPLIANCE_IO_H
#define _COMPLIANCE_IO_H

//-----------------------------------------------------------------------
// RV IO Macros 
//-----------------------------------------------------------------------

#define RVTEST_IO_INIT

#define RVTEST_IO_ASSERT_GPR_EQ(_SP, _R, _I) \
  li t3, _I; \
  bne t3, _R, end_testcode; \


#define RVTEST_IO_WRITE_STR(_SP, _STR)
#define RVTEST_IO_CHECK()

#endif // _COMPLIANCE_IO_H
