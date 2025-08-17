



int main();

extern unsigned __sstack[], __sbss[], __ebss[];

asm
(
  ".globl __start\n"
  "__start:\n"
  "la sp, __sstack\n"
  "j _main\n"
);


asm
(
  "__exit:\n"
  "nop\n"
  "nop\n"
  "sw x0, 0(x0)\n"
  "nop\n"
  "nop\n"
  "nop\n"
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


  __exit(status);
}

