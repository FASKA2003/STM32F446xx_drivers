/*
    TARGET : NUCLEO STM32F446RE
    AUTHOR : AYOUB EL MAHFOUDI
    FILE : Linker Script
*/

/* Define the entry point*/
ENTRY(Reset_Handler)

/*Highest address of the user mode stack*/
_sstack = ORIGIN(SRAM) + LENGTH(SRAM);

/*Minimum and maximum size of user stack*/
_Min_HEAP_size = 0x200; /*Required amount of HEAP*/
_Min_STACK_size = 0x400; /*Required amount of STACK*/


MEMORY {
    SRAM  (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 512K
}

SECTIONS {

    /*Startup code into FLASH memory*/
    .isr_vector :
    {
        . = ALIGN(4);
        *(.isr_vector)
        . = ALIGN(4);
    }

    /*.text section, the program code and other data to the FLASH memory*/
    .text :
    {
        /*sets the current location counter (.) to the nearest memory address that is a multiple of 4.*/
        /*to ensure that the start, end, and contents of the .data section are aligned to 4-byte boundaries*/
        . = ALIGN(4); 
        /*This defines a symbol _stext and assigns it the value of the current memory address (.), effectively marking the start of the .text section*/
        _stext = .;
        *(.text)
        *(.text*)
        *(.glue_7)
        *(.glue_7t)
        *(.eh_frame)

        KEEP(*(.init))
        KEEP(*(.fini))


        /*This defines a symbol _etext and assigns it the value of the current memory address (.), effectively marking the end of the .text section*/
        . = ALIGN(4);
        _etext = .;
    } >FLASH

    /*.rodata section, constant data that program uses but does not modify during its execution.*/
    .rodata :
    {
        . = ALIGN(4);
        _srodata = .;
        *(.rodata)
        *(.rodata*)
        _erodata = .;
        . = ALIGN(4);        
    } >FLASH

    /*define a symbol _sidata and assign it the load memory address (LMA) of the .data section*/
    _sidata = LOADADDR(.data);

    /*.data section,  initialized data section into RAM(SRAM) memory*/
    .data :
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data)
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } >SRAM AT >FLASH

    /*.bss section, uninitialized data section into RAM(SRAM) memory*/
    /*NOLOAD specify that the .bss section should be defined, but it should not be loaded from the input files or the program binary.*/
    . = ALIGN(4);
    .bss (NOLOAD) :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } >SRAM

    /*.user_heap_stack section used to check that there is enough RAM(SRAM) memory*/
    ._user_heap_stack :
    {
        . = ALIGN(8);
        PROVIDE( end = .);
        PROVIDE( _end = .);
        . = . + _Min_HEAP_size;
        . = . + _Min_STACK_size;
        . = ALIGN(8);
    } > SRAM
}
