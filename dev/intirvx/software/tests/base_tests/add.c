




int main()
{
  // Add
  asm volatile
  (
    "li t0, 15\n"
    "li t1, 1\n"
    "li t2, 16\n"
    "add t3, t0, t1\n"
    "bne t3, t2, _bad\n"
    "li t1, 17\n"
    "addi t3, t0, 2\n"
    "bne t3, t1, _bad\n"
    "li t1, 13\n"
    "li t4, 2\n"
    "sub t3, t0, t4\n"
    "bne t3, t1, _bad\n"
    "li a0, 0\n"
    "j _good\n"
    "_bad:\n"
    "li a0, 1\n"
    "_good:\n"
    "ret\n"
    "nop\n"
    "nop\n"
  );
}