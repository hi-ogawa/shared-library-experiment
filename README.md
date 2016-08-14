# GCC Shared Library Tutorial

- Motivation:
  - understand what shared library is,
  - understand how loader works,
  - learn gcc options.
- TODO:
  - analyze the output of readelf

## References

- GCC options:
  - `-l, -shared`: https://gcc.gnu.org/onlinedocs/gcc-6.1.0/gcc/Link-Options.html
  - `-fpic`: https://gcc.gnu.org/onlinedocs/gcc-6.1.0/gcc/Code-Gen-Options.html
  - `-I, -L`: https://gcc.gnu.org/onlinedocs/gcc-6.1.0/gcc/Directory-Options.html
- http://www.cprogramming.com/tutorial/shared-libraries-linux-gcc.html
- http://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html

## Commands

After logging in to gcc environment with `docker-compose run --rm gcc bash`,

Compile and run:

```
$ gcc plus.c -c -fpic -I./
$ gcc plus.o -o libplus.so -shared
$ gcc main.c -o main -I./ -L./ -lplus
$ LD_LIBRARY_PATH=$(pwd) ./main
plus(1, 2) = 3
```

Read Binary file:

```
$ readelf -aW plus.o
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              REL (Relocatable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x0
  Start of program headers:          0 (bytes into file)
  Start of section headers:          504 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           0 (bytes)
  Number of program headers:         0
  Size of section headers:           64 (bytes)
  Number of section headers:         11
  Section header string table index: 8

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        0000000000000000 000040 000014 00  AX  0   0  1
  [ 2] .data             PROGBITS        0000000000000000 000054 000000 00  WA  0   0  1
  [ 3] .bss              NOBITS          0000000000000000 000054 000000 00  WA  0   0  1
  [ 4] .comment          PROGBITS        0000000000000000 000054 000012 01  MS  0   0  1
  [ 5] .note.GNU-stack   PROGBITS        0000000000000000 000066 000000 00      0   0  1
  [ 6] .eh_frame         PROGBITS        0000000000000000 000068 000038 00   A  0   0  8
  [ 7] .rela.eh_frame    RELA            0000000000000000 0001e0 000018 18   I  9   6  8
  [ 8] .shstrtab         STRTAB          0000000000000000 0000a0 000054 00      0   0  1
  [ 9] .symtab           SYMTAB          0000000000000000 0000f8 0000d8 18     10   8  8
  [10] .strtab           STRTAB          0000000000000000 0001d0 00000d 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), l (large)
  I (info), L (link order), G (group), T (TLS), E (exclude), x (unknown)
  O (extra OS processing required) o (OS specific), p (processor specific)

There are no section groups in this file.

There are no program headers in this file.

Relocation section '.rela.eh_frame' at offset 0x1e0 contains 1 entries:
    Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
0000000000000020  0000000200000002 R_X86_64_PC32          0000000000000000 .text + 0

The decoding of unwind sections for machine type Advanced Micro Devices X86-64 is not currently supported.

Symbol table '.symtab' contains 9 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS plus.c
     2: 0000000000000000     0 SECTION LOCAL  DEFAULT    1
     3: 0000000000000000     0 SECTION LOCAL  DEFAULT    2
     4: 0000000000000000     0 SECTION LOCAL  DEFAULT    3
     5: 0000000000000000     0 SECTION LOCAL  DEFAULT    5
     6: 0000000000000000     0 SECTION LOCAL  DEFAULT    6
     7: 0000000000000000     0 SECTION LOCAL  DEFAULT    4
     8: 0000000000000000    20 FUNC    GLOBAL DEFAULT    1 plus

No version information found in this file.

$ readelf -aW libplus.so
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              DYN (Shared object file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x500
  Start of program headers:          64 (bytes into file)
  Start of section headers:          4176 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         5
  Size of section headers:           64 (bytes)
  Number of section headers:         26
  Section header string table index: 23

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
  [ 1] .hash             HASH            0000000000000158 000158 000048 04   A  2   0  8
  [ 2] .dynsym           DYNSYM          00000000000001a0 0001a0 000138 18   A  3   2  8
  [ 3] .dynstr           STRTAB          00000000000002d8 0002d8 0000a8 00   A  0   0  1
  [ 4] .gnu.version      VERSYM          0000000000000380 000380 00001a 02   A  2   0  2
  [ 5] .gnu.version_r    VERNEED         00000000000003a0 0003a0 000020 00   A  3   1  8
  [ 6] .rela.dyn         RELA            00000000000003c0 0003c0 0000c0 18   A  2   0  8
  [ 7] .rela.plt         RELA            0000000000000480 000480 000030 18  AI  2   9  8
  [ 8] .init             PROGBITS        00000000000004b0 0004b0 00001a 00  AX  0   0  4
  [ 9] .plt              PROGBITS        00000000000004d0 0004d0 000030 10  AX  0   0 16
  [10] .text             PROGBITS        0000000000000500 000500 000114 00  AX  0   0 16
  [11] .fini             PROGBITS        0000000000000614 000614 000009 00  AX  0   0  4
  [12] .eh_frame_hdr     PROGBITS        0000000000000620 000620 00001c 00   A  0   0  4
  [13] .eh_frame         PROGBITS        0000000000000640 000640 000064 00   A  0   0  8
  [14] .init_array       INIT_ARRAY      00000000002006a8 0006a8 000008 00  WA  0   0  8
  [15] .fini_array       FINI_ARRAY      00000000002006b0 0006b0 000008 00  WA  0   0  8
  [16] .jcr              PROGBITS        00000000002006b8 0006b8 000008 00  WA  0   0  8
  [17] .dynamic          DYNAMIC         00000000002006c0 0006c0 0001c0 10  WA  3   0  8
  [18] .got              PROGBITS        0000000000200880 000880 000028 08  WA  0   0  8
  [19] .got.plt          PROGBITS        00000000002008a8 0008a8 000028 08  WA  0   0  8
  [20] .data             PROGBITS        00000000002008d0 0008d0 000008 00  WA  0   0  8
  [21] .bss              NOBITS          00000000002008d8 0008d8 000008 00  WA  0   0  1
  [22] .comment          PROGBITS        0000000000000000 0008d8 000011 01  MS  0   0  1
  [23] .shstrtab         STRTAB          0000000000000000 0008e9 0000d3 00      0   0  1
  [24] .symtab           SYMTAB          0000000000000000 0009c0 0004e0 18     25  41  8
  [25] .strtab           STRTAB          0000000000000000 000ea0 0001af 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), l (large)
  I (info), L (link order), G (group), T (TLS), E (exclude), x (unknown)
  O (extra OS processing required) o (OS specific), p (processor specific)

There are no section groups in this file.

Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  LOAD           0x000000 0x0000000000000000 0x0000000000000000 0x0006a4 0x0006a4 R E 0x200000
  LOAD           0x0006a8 0x00000000002006a8 0x00000000002006a8 0x000230 0x000238 RW  0x200000
  DYNAMIC        0x0006c0 0x00000000002006c0 0x00000000002006c0 0x0001c0 0x0001c0 RW  0x8
  GNU_EH_FRAME   0x000620 0x0000000000000620 0x0000000000000620 0x00001c 0x00001c R   0x4
  GNU_STACK      0x000000 0x0000000000000000 0x0000000000000000 0x000000 0x000000 RW  0x10

 Section to Segment mapping:
  Segment Sections...
   00     .hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt .text .fini .eh_frame_hdr .eh_frame
   01     .init_array .fini_array .jcr .dynamic .got .got.plt .data .bss
   02     .dynamic
   03     .eh_frame_hdr
   04

Dynamic section at offset 0x6c0 contains 24 entries:
  Tag        Type                         Name/Value
 0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]
 0x000000000000000c (INIT)               0x4b0
 0x000000000000000d (FINI)               0x614
 0x0000000000000019 (INIT_ARRAY)         0x2006a8
 0x000000000000001b (INIT_ARRAYSZ)       8 (bytes)
 0x000000000000001a (FINI_ARRAY)         0x2006b0
 0x000000000000001c (FINI_ARRAYSZ)       8 (bytes)
 0x0000000000000004 (HASH)               0x158
 0x0000000000000005 (STRTAB)             0x2d8
 0x0000000000000006 (SYMTAB)             0x1a0
 0x000000000000000a (STRSZ)              168 (bytes)
 0x000000000000000b (SYMENT)             24 (bytes)
 0x0000000000000003 (PLTGOT)             0x2008a8
 0x0000000000000002 (PLTRELSZ)           48 (bytes)
 0x0000000000000014 (PLTREL)             RELA
 0x0000000000000017 (JMPREL)             0x480
 0x0000000000000007 (RELA)               0x3c0
 0x0000000000000008 (RELASZ)             192 (bytes)
 0x0000000000000009 (RELAENT)            24 (bytes)
 0x000000006ffffffe (VERNEED)            0x3a0
 0x000000006fffffff (VERNEEDNUM)         1
 0x000000006ffffff0 (VERSYM)             0x380
 0x000000006ffffff9 (RELACOUNT)          3
 0x0000000000000000 (NULL)               0x0

Relocation section '.rela.dyn' at offset 0x3c0 contains 8 entries:
    Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
00000000002006a8  0000000000000008 R_X86_64_RELATIVE                         5d0
00000000002006b0  0000000000000008 R_X86_64_RELATIVE                         590
00000000002008d0  0000000000000008 R_X86_64_RELATIVE                         2008d0
0000000000200880  0000000300000006 R_X86_64_GLOB_DAT      0000000000000000 _ITM_deregisterTMCloneTable + 0
0000000000200888  0000000600000006 R_X86_64_GLOB_DAT      0000000000000000 __gmon_start__ + 0
0000000000200890  0000000900000006 R_X86_64_GLOB_DAT      0000000000000000 _Jv_RegisterClasses + 0
0000000000200898  0000000a00000006 R_X86_64_GLOB_DAT      0000000000000000 _ITM_registerTMCloneTable + 0
00000000002008a0  0000000b00000006 R_X86_64_GLOB_DAT      0000000000000000 __cxa_finalize + 0

Relocation section '.rela.plt' at offset 0x480 contains 2 entries:
    Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
00000000002008c0  0000000600000007 R_X86_64_JUMP_SLOT     0000000000000000 __gmon_start__ + 0
00000000002008c8  0000000b00000007 R_X86_64_JUMP_SLOT     0000000000000000 __cxa_finalize + 0

The decoding of unwind sections for machine type Advanced Micro Devices X86-64 is not currently supported.

Symbol table '.dynsym' contains 13 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 00000000000004b0     0 SECTION LOCAL  DEFAULT    8
     2: 0000000000000600    20 FUNC    GLOBAL DEFAULT   10 plus
     3: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_deregisterTMCloneTable
     4: 00000000002008d8     0 NOTYPE  GLOBAL DEFAULT   20 _edata
     5: 0000000000000614     0 FUNC    GLOBAL DEFAULT   11 _fini
     6: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND __gmon_start__
     7: 00000000002008e0     0 NOTYPE  GLOBAL DEFAULT   21 _end
     8: 00000000002008d8     0 NOTYPE  GLOBAL DEFAULT   21 __bss_start
     9: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _Jv_RegisterClasses
    10: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_registerTMCloneTable
    11: 0000000000000000     0 FUNC    WEAK   DEFAULT  UND __cxa_finalize@GLIBC_2.2.5 (2)
    12: 00000000000004b0     0 FUNC    GLOBAL DEFAULT    8 _init

Symbol table '.symtab' contains 52 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 0000000000000158     0 SECTION LOCAL  DEFAULT    1
     2: 00000000000001a0     0 SECTION LOCAL  DEFAULT    2
     3: 00000000000002d8     0 SECTION LOCAL  DEFAULT    3
     4: 0000000000000380     0 SECTION LOCAL  DEFAULT    4
     5: 00000000000003a0     0 SECTION LOCAL  DEFAULT    5
     6: 00000000000003c0     0 SECTION LOCAL  DEFAULT    6
     7: 0000000000000480     0 SECTION LOCAL  DEFAULT    7
     8: 00000000000004b0     0 SECTION LOCAL  DEFAULT    8
     9: 00000000000004d0     0 SECTION LOCAL  DEFAULT    9
    10: 0000000000000500     0 SECTION LOCAL  DEFAULT   10
    11: 0000000000000614     0 SECTION LOCAL  DEFAULT   11
    12: 0000000000000620     0 SECTION LOCAL  DEFAULT   12
    13: 0000000000000640     0 SECTION LOCAL  DEFAULT   13
    14: 00000000002006a8     0 SECTION LOCAL  DEFAULT   14
    15: 00000000002006b0     0 SECTION LOCAL  DEFAULT   15
    16: 00000000002006b8     0 SECTION LOCAL  DEFAULT   16
    17: 00000000002006c0     0 SECTION LOCAL  DEFAULT   17
    18: 0000000000200880     0 SECTION LOCAL  DEFAULT   18
    19: 00000000002008a8     0 SECTION LOCAL  DEFAULT   19
    20: 00000000002008d0     0 SECTION LOCAL  DEFAULT   20
    21: 00000000002008d8     0 SECTION LOCAL  DEFAULT   21
    22: 0000000000000000     0 SECTION LOCAL  DEFAULT   22
    23: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS crtstuff.c
    24: 00000000002006b8     0 OBJECT  LOCAL  DEFAULT   16 __JCR_LIST__
    25: 0000000000000500     0 FUNC    LOCAL  DEFAULT   10 deregister_tm_clones
    26: 0000000000000540     0 FUNC    LOCAL  DEFAULT   10 register_tm_clones
    27: 0000000000000590     0 FUNC    LOCAL  DEFAULT   10 __do_global_dtors_aux
    28: 00000000002008d8     1 OBJECT  LOCAL  DEFAULT   21 completed.6896
    29: 00000000002006b0     0 OBJECT  LOCAL  DEFAULT   15 __do_global_dtors_aux_fini_array_entry
    30: 00000000000005d0     0 FUNC    LOCAL  DEFAULT   10 frame_dummy
    31: 00000000002006a8     0 OBJECT  LOCAL  DEFAULT   14 __frame_dummy_init_array_entry
    32: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS plus.c
    33: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS crtstuff.c
    34: 00000000000006a0     0 OBJECT  LOCAL  DEFAULT   13 __FRAME_END__
    35: 00000000002006b8     0 OBJECT  LOCAL  DEFAULT   16 __JCR_END__
    36: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS
    37: 00000000002008d0     0 OBJECT  LOCAL  DEFAULT   20 __dso_handle
    38: 00000000002006c0     0 OBJECT  LOCAL  DEFAULT   17 _DYNAMIC
    39: 00000000002008d8     0 OBJECT  LOCAL  DEFAULT   20 __TMC_END__
    40: 00000000002008a8     0 OBJECT  LOCAL  DEFAULT   19 _GLOBAL_OFFSET_TABLE_
    41: 0000000000000600    20 FUNC    GLOBAL DEFAULT   10 plus
    42: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_deregisterTMCloneTable
    43: 00000000002008d8     0 NOTYPE  GLOBAL DEFAULT   20 _edata
    44: 0000000000000614     0 FUNC    GLOBAL DEFAULT   11 _fini
    45: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND __gmon_start__
    46: 00000000002008e0     0 NOTYPE  GLOBAL DEFAULT   21 _end
    47: 00000000002008d8     0 NOTYPE  GLOBAL DEFAULT   21 __bss_start
    48: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _Jv_RegisterClasses
    49: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_registerTMCloneTable
    50: 0000000000000000     0 FUNC    WEAK   DEFAULT  UND __cxa_finalize@@GLIBC_2.2.5
    51: 00000000000004b0     0 FUNC    GLOBAL DEFAULT    8 _init

Histogram for bucket list length (total of 3 buckets):
 Length  Number     % of total  Coverage
      0  0          (  0.0%)
      1  0          (  0.0%)      0.0%
      2  0          (  0.0%)      0.0%
      3  1          ( 33.3%)     27.3%
      4  2          ( 66.7%)    100.0%

Version symbols section '.gnu.version' contains 13 entries:
 Addr: 0000000000000380  Offset: 0x000380  Link: 2 (.dynsym)
  000:   0 (*local*)       0 (*local*)       1 (*global*)      0 (*local*)
  004:   1 (*global*)      1 (*global*)      0 (*local*)       1 (*global*)
  008:   1 (*global*)      0 (*local*)       0 (*local*)       2 (GLIBC_2.2.5)
  00c:   1 (*global*)

Version needs section '.gnu.version_r' contains 1 entries:
 Addr: 0x00000000000003a0  Offset: 0x0003a0  Link: 3 (.dynstr)
  000000: Version: 1  File: libc.so.6  Cnt: 1
  0x0010:   Name: GLIBC_2.2.5  Flags: none  Version: 2

$ readelf -aW main
ELF Header:
  Magic:   7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x4005a0
  Start of program headers:          64 (bytes into file)
  Start of section headers:          5208 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         8
  Size of section headers:           64 (bytes)
  Number of section headers:         29
  Section header string table index: 26

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00      0   0  0
  [ 1] .interp           PROGBITS        0000000000400200 000200 00001c 00   A  0   0  1
  [ 2] .note.ABI-tag     NOTE            000000000040021c 00021c 000020 00   A  0   0  4
  [ 3] .hash             HASH            0000000000400240 000240 000048 04   A  4   0  8
  [ 4] .dynsym           DYNSYM          0000000000400288 000288 000138 18   A  5   1  8
  [ 5] .dynstr           STRTAB          00000000004003c0 0003c0 0000bd 00   A  0   0  1
  [ 6] .gnu.version      VERSYM          000000000040047e 00047e 00001a 02   A  4   0  2
  [ 7] .gnu.version_r    VERNEED         0000000000400498 000498 000020 00   A  5   1  8
  [ 8] .rela.dyn         RELA            00000000004004b8 0004b8 000018 18   A  4   0  8
  [ 9] .rela.plt         RELA            00000000004004d0 0004d0 000060 18  AI  4  11  8
  [10] .init             PROGBITS        0000000000400530 000530 00001a 00  AX  0   0  4
  [11] .plt              PROGBITS        0000000000400550 000550 000050 10  AX  0   0 16
  [12] .text             PROGBITS        00000000004005a0 0005a0 0001a2 00  AX  0   0 16
  [13] .fini             PROGBITS        0000000000400744 000744 000009 00  AX  0   0  4
  [14] .rodata           PROGBITS        0000000000400750 000750 000015 00   A  0   0  4
  [15] .eh_frame_hdr     PROGBITS        0000000000400768 000768 000034 00   A  0   0  4
  [16] .eh_frame         PROGBITS        00000000004007a0 0007a0 0000f4 00   A  0   0  8
  [17] .init_array       INIT_ARRAY      0000000000600898 000898 000008 00  WA  0   0  8
  [18] .fini_array       FINI_ARRAY      00000000006008a0 0008a0 000008 00  WA  0   0  8
  [19] .jcr              PROGBITS        00000000006008a8 0008a8 000008 00  WA  0   0  8
  [20] .dynamic          DYNAMIC         00000000006008b0 0008b0 0001e0 10  WA  5   0  8
  [21] .got              PROGBITS        0000000000600a90 000a90 000008 08  WA  0   0  8
  [22] .got.plt          PROGBITS        0000000000600a98 000a98 000038 08  WA  0   0  8
  [23] .data             PROGBITS        0000000000600ad0 000ad0 000010 00  WA  0   0  8
  [24] .bss              NOBITS          0000000000600ae0 000ae0 000008 00  WA  0   0  1
  [25] .comment          PROGBITS        0000000000000000 000ae0 00002d 01  MS  0   0  1
  [26] .shstrtab         STRTAB          0000000000000000 000b0d 0000f1 00      0   0  1
  [27] .symtab           SYMTAB          0000000000000000 000c00 000618 18     28  44  8
  [28] .strtab           STRTAB          0000000000000000 001218 00023d 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), l (large)
  I (info), L (link order), G (group), T (TLS), E (exclude), x (unknown)
  O (extra OS processing required) o (OS specific), p (processor specific)

There are no section groups in this file.

Program Headers:
  Type           Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
  PHDR           0x000040 0x0000000000400040 0x0000000000400040 0x0001c0 0x0001c0 R E 0x8
  INTERP         0x000200 0x0000000000400200 0x0000000000400200 0x00001c 0x00001c R   0x1
      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
  LOAD           0x000000 0x0000000000400000 0x0000000000400000 0x000894 0x000894 R E 0x200000
  LOAD           0x000898 0x0000000000600898 0x0000000000600898 0x000248 0x000250 RW  0x200000
  DYNAMIC        0x0008b0 0x00000000006008b0 0x00000000006008b0 0x0001e0 0x0001e0 RW  0x8
  NOTE           0x00021c 0x000000000040021c 0x000000000040021c 0x000020 0x000020 R   0x4
  GNU_EH_FRAME   0x000768 0x0000000000400768 0x0000000000400768 0x000034 0x000034 R   0x4
  GNU_STACK      0x000000 0x0000000000000000 0x0000000000000000 0x000000 0x000000 RW  0x10

 Section to Segment mapping:
  Segment Sections...
   00
   01     .interp
   02     .interp .note.ABI-tag .hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt .text .fini .rodata .eh_frame_hdr .eh_frame
   03     .init_array .fini_array .jcr .dynamic .got .got.plt .data .bss
   04     .dynamic
   05     .note.ABI-tag
   06     .eh_frame_hdr
   07

Dynamic section at offset 0x8b0 contains 25 entries:
  Tag        Type                         Name/Value
 0x0000000000000001 (NEEDED)             Shared library: [libplus.so]
 0x0000000000000001 (NEEDED)             Shared library: [libc.so.6]
 0x000000000000000c (INIT)               0x400530
 0x000000000000000d (FINI)               0x400744
 0x0000000000000019 (INIT_ARRAY)         0x600898
 0x000000000000001b (INIT_ARRAYSZ)       8 (bytes)
 0x000000000000001a (FINI_ARRAY)         0x6008a0
 0x000000000000001c (FINI_ARRAYSZ)       8 (bytes)
 0x0000000000000004 (HASH)               0x400240
 0x0000000000000005 (STRTAB)             0x4003c0
 0x0000000000000006 (SYMTAB)             0x400288
 0x000000000000000a (STRSZ)              189 (bytes)
 0x000000000000000b (SYMENT)             24 (bytes)
 0x0000000000000015 (DEBUG)              0x0
 0x0000000000000003 (PLTGOT)             0x600a98
 0x0000000000000002 (PLTRELSZ)           96 (bytes)
 0x0000000000000014 (PLTREL)             RELA
 0x0000000000000017 (JMPREL)             0x4004d0
 0x0000000000000007 (RELA)               0x4004b8
 0x0000000000000008 (RELASZ)             24 (bytes)
 0x0000000000000009 (RELAENT)            24 (bytes)
 0x000000006ffffffe (VERNEED)            0x400498
 0x000000006fffffff (VERNEEDNUM)         1
 0x000000006ffffff0 (VERSYM)             0x40047e
 0x0000000000000000 (NULL)               0x0

Relocation section '.rela.dyn' at offset 0x4b8 contains 1 entries:
    Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
0000000000600a90  0000000700000006 R_X86_64_GLOB_DAT      0000000000000000 __gmon_start__ + 0

Relocation section '.rela.plt' at offset 0x4d0 contains 4 entries:
    Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
0000000000600ab0  0000000100000007 R_X86_64_JUMP_SLOT     0000000000000000 plus + 0
0000000000600ab8  0000000500000007 R_X86_64_JUMP_SLOT     0000000000000000 printf + 0
0000000000600ac0  0000000600000007 R_X86_64_JUMP_SLOT     0000000000000000 __libc_start_main + 0
0000000000600ac8  0000000700000007 R_X86_64_JUMP_SLOT     0000000000000000 __gmon_start__ + 0

The decoding of unwind sections for machine type Advanced Micro Devices X86-64 is not currently supported.

Symbol table '.dynsym' contains 13 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND plus
     2: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_deregisterTMCloneTable
     3: 0000000000600ae0     0 NOTYPE  GLOBAL DEFAULT   23 _edata
     4: 0000000000400744     0 FUNC    GLOBAL DEFAULT   13 _fini
     5: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND printf@GLIBC_2.2.5 (2)
     6: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND __libc_start_main@GLIBC_2.2.5 (2)
     7: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND __gmon_start__
     8: 0000000000600ae8     0 NOTYPE  GLOBAL DEFAULT   24 _end
     9: 0000000000600ae0     0 NOTYPE  GLOBAL DEFAULT   24 __bss_start
    10: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _Jv_RegisterClasses
    11: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_registerTMCloneTable
    12: 0000000000400530     0 FUNC    GLOBAL DEFAULT   10 _init

Symbol table '.symtab' contains 65 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 0000000000400200     0 SECTION LOCAL  DEFAULT    1
     2: 000000000040021c     0 SECTION LOCAL  DEFAULT    2
     3: 0000000000400240     0 SECTION LOCAL  DEFAULT    3
     4: 0000000000400288     0 SECTION LOCAL  DEFAULT    4
     5: 00000000004003c0     0 SECTION LOCAL  DEFAULT    5
     6: 000000000040047e     0 SECTION LOCAL  DEFAULT    6
     7: 0000000000400498     0 SECTION LOCAL  DEFAULT    7
     8: 00000000004004b8     0 SECTION LOCAL  DEFAULT    8
     9: 00000000004004d0     0 SECTION LOCAL  DEFAULT    9
    10: 0000000000400530     0 SECTION LOCAL  DEFAULT   10
    11: 0000000000400550     0 SECTION LOCAL  DEFAULT   11
    12: 00000000004005a0     0 SECTION LOCAL  DEFAULT   12
    13: 0000000000400744     0 SECTION LOCAL  DEFAULT   13
    14: 0000000000400750     0 SECTION LOCAL  DEFAULT   14
    15: 0000000000400768     0 SECTION LOCAL  DEFAULT   15
    16: 00000000004007a0     0 SECTION LOCAL  DEFAULT   16
    17: 0000000000600898     0 SECTION LOCAL  DEFAULT   17
    18: 00000000006008a0     0 SECTION LOCAL  DEFAULT   18
    19: 00000000006008a8     0 SECTION LOCAL  DEFAULT   19
    20: 00000000006008b0     0 SECTION LOCAL  DEFAULT   20
    21: 0000000000600a90     0 SECTION LOCAL  DEFAULT   21
    22: 0000000000600a98     0 SECTION LOCAL  DEFAULT   22
    23: 0000000000600ad0     0 SECTION LOCAL  DEFAULT   23
    24: 0000000000600ae0     0 SECTION LOCAL  DEFAULT   24
    25: 0000000000000000     0 SECTION LOCAL  DEFAULT   25
    26: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS crtstuff.c
    27: 00000000006008a8     0 OBJECT  LOCAL  DEFAULT   19 __JCR_LIST__
    28: 00000000004005d0     0 FUNC    LOCAL  DEFAULT   12 deregister_tm_clones
    29: 0000000000400610     0 FUNC    LOCAL  DEFAULT   12 register_tm_clones
    30: 0000000000400650     0 FUNC    LOCAL  DEFAULT   12 __do_global_dtors_aux
    31: 0000000000600ae0     1 OBJECT  LOCAL  DEFAULT   24 completed.6896
    32: 00000000006008a0     0 OBJECT  LOCAL  DEFAULT   18 __do_global_dtors_aux_fini_array_entry
    33: 0000000000400670     0 FUNC    LOCAL  DEFAULT   12 frame_dummy
    34: 0000000000600898     0 OBJECT  LOCAL  DEFAULT   17 __frame_dummy_init_array_entry
    35: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS main.c
    36: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS crtstuff.c
    37: 0000000000400890     0 OBJECT  LOCAL  DEFAULT   16 __FRAME_END__
    38: 00000000006008a8     0 OBJECT  LOCAL  DEFAULT   19 __JCR_END__
    39: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS
    40: 00000000006008a0     0 NOTYPE  LOCAL  DEFAULT   17 __init_array_end
    41: 00000000006008b0     0 OBJECT  LOCAL  DEFAULT   20 _DYNAMIC
    42: 0000000000600898     0 NOTYPE  LOCAL  DEFAULT   17 __init_array_start
    43: 0000000000600a98     0 OBJECT  LOCAL  DEFAULT   22 _GLOBAL_OFFSET_TABLE_
    44: 0000000000400740     2 FUNC    GLOBAL DEFAULT   12 __libc_csu_fini
    45: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND plus
    46: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_deregisterTMCloneTable
    47: 0000000000600ad0     0 NOTYPE  WEAK   DEFAULT   23 data_start
    48: 0000000000600ae0     0 NOTYPE  GLOBAL DEFAULT   23 _edata
    49: 0000000000400744     0 FUNC    GLOBAL DEFAULT   13 _fini
    50: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND printf@@GLIBC_2.2.5
    51: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND __libc_start_main@@GLIBC_2.2.5
    52: 0000000000600ad0     0 NOTYPE  GLOBAL DEFAULT   23 __data_start
    53: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND __gmon_start__
    54: 0000000000600ad8     0 OBJECT  GLOBAL HIDDEN    23 __dso_handle
    55: 0000000000400750     4 OBJECT  GLOBAL DEFAULT   14 _IO_stdin_used
    56: 00000000004006d0   101 FUNC    GLOBAL DEFAULT   12 __libc_csu_init
    57: 0000000000600ae8     0 NOTYPE  GLOBAL DEFAULT   24 _end
    58: 00000000004005a0     0 FUNC    GLOBAL DEFAULT   12 _start
    59: 0000000000600ae0     0 NOTYPE  GLOBAL DEFAULT   24 __bss_start
    60: 0000000000400696    43 FUNC    GLOBAL DEFAULT   12 main
    61: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _Jv_RegisterClasses
    62: 0000000000600ae0     0 OBJECT  GLOBAL HIDDEN    23 __TMC_END__
    63: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_registerTMCloneTable
    64: 0000000000400530     0 FUNC    GLOBAL DEFAULT   10 _init

Histogram for bucket list length (total of 3 buckets):
 Length  Number     % of total  Coverage
      0  0          (  0.0%)
      1  0          (  0.0%)      0.0%
      2  0          (  0.0%)      0.0%
      3  1          ( 33.3%)     25.0%
      4  1          ( 33.3%)     58.3%
      5  1          ( 33.3%)    100.0%

Version symbols section '.gnu.version' contains 13 entries:
 Addr: 000000000040047e  Offset: 0x00047e  Link: 4 (.dynsym)
  000:   0 (*local*)       0 (*local*)       0 (*local*)       1 (*global*)
  004:   1 (*global*)      2 (GLIBC_2.2.5)   2 (GLIBC_2.2.5)   0 (*local*)
  008:   1 (*global*)      1 (*global*)      0 (*local*)       0 (*local*)
  00c:   1 (*global*)

Version needs section '.gnu.version_r' contains 1 entries:
 Addr: 0x0000000000400498  Offset: 0x000498  Link: 5 (.dynstr)
  000000: Version: 1  File: libc.so.6  Cnt: 1
  0x0010:   Name: GLIBC_2.2.5  Flags: none  Version: 2

Displaying notes found at file offset 0x0000021c with length 0x00000020:
  Owner                 Data size	Description
  GNU                  0x00000010	NT_GNU_ABI_TAG (ABI version tag)
    OS: Linux, ABI: 2.6.32

$ ldd main
	linux-vdso.so.1 (0x00007ffc44dda000)
	libplus.so => not found
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f9aa6cd3000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f9aa707e000)

$ LD_LIBRARY_PATH=$(pwd) ldd main
	linux-vdso.so.1 (0x00007ffe023ea000)
	libplus.so => /app/libplus.so (0x00007f872f2e9000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f872ef3e000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f872f4ea000)
```
