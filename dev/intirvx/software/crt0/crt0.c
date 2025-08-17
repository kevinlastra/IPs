



int main();

extern unsigned __sstack[], __sbss[], __ebss[];
extern unsigned __data_start;


asm
(
  ".globl __start\n"
  "__start:\n"
  "la sp, __sstack\n"
  "j _main\n"
);

void _main()
{
  // init bss segment 
  for(unsigned int* bss = __sbss; bss < __ebss; bss++)
  {
    *bss = 0;
  }

  // call main
  int status = main();

  // exceptions handlers


  _Exit(status);
}

void _Exit(int status)
{
  asm volatile
  (
    "lui a0, 0xFFFFF\n"
    "addi a0, a0, -16\n"
    "sw x0, 0(a0)\n"
  );
}
