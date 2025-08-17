
__stack_size = 0x20;


ENTRY (__start)


SECTIONS
{
    . = 0x10000;
    .text : 
    { 
      . = __start;
      . = ALIGN(4);
      *(.text)
    }
    . = 0x20000;
    .data : 
    { 
      *(.data*)
      *(.ro.data*)
    }
    .bss : 
    {
      __sbss = .;
      . = ALIGN(4);
      __sstack = .;
      . = . + __stack_size;
      . = ALIGN(4);
      __estack = .;
      __ebss = .;
    }
}