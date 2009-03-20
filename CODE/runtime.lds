SECTIONS
      {
        copy_code = (0x00000000 + 0xc);
        MC_FW_VERSION = MC_BUILD_TIME & 0xffffffc0 | MC_BUILD_ID;
        . = 0x00000000;
        .text : {
          *(.text)
        _etext = .;
        }
        ASSERT( . <= 0x00010000 + (4 * 40960), "The IMEM is full. Go away.")
        . = 0x00080000;
        _gp = .;
        .data : {
    *(.crash_save)
    *(.sdata)
    *(.rodata*)
    *(.data)
    mc_fw_version = .;
    LONG(MC_BUILD_TIME & 0xffffffc0 | MC_BUILD_ID)
     __coros_start = .;
     *(.coros)
     __coros_end = .;
     __prologues_start = .;
     *(SORT_BY_NAME(.prologues_*))
     __prologues_end = .;
  }
        ASSERT( . <= 0x00080000 + (4 * 8192) - (2048), "No room for cmdstub. You lose.")
        .bss :
          { __bss_start = .;
     *(.sbss)
            *(.scommon)
            *(.bss)
            __end = .;
          }
        _stacks_start = .;
        .stack (NOLOAD) : { *(.coro_stacks) }
 _stacks_end = .;
 ASSERT( . <= 0x00080000 + (4 * 8192), "The DMEM is full. You lose.")
      }
