### Script for path:

set path=C:\Python27;C:\bfi;C:\NASM;C:\ALINK;"C:\Program Files (x86)\Bochs-2.6.9";C:\MinGW\bin;%path%

### Tools needed:

    nasm - Famous assembler.
    alinker - To link DOS stub.
    linker - Microsoft linker to generate PE file and replace DOS stub.
    bfi - A command line tool to create disk images https://sites.google.com/site/lanestech/home/bfi.zip
    bochs - To emulate and debug DOS stub.
    python - To fix DOS header.

### How to debug
    IDA > DEBUGGER > RUN > Local Bochs > Open bochsrc.cfg



### Details on DOS programming
    
    DOS Header:
        e_magic: 4d 5a                  // Magic number 'MZ'
        e_cblp: 0x0090                  // Bytes on last page of file
        e_cp: 0x0003                    // Pages in file
        e_crlc: 0x0000                  // Relocations
        e_cparhdr: 0x0004               // Size of header in paragraphs
        e_minalloc: 0x0000              // Minimum extra paragraphs needed
        e_maxalloc: 0xffff              // Maximum extra paragraphs needed
        e_ss: 0x0000                    // Initial (relative) SS value
        e_sp: 0x00b8                    // Initial SP value
        e_csum: 0x0000                  // Checksum
        e_ip: 0x0000                    // Initial IP value
        e_cs: 0x0000                    // Initial (relative) CS value
        e_lfarlc: 0x0040                // File address of relocation table
        e_ovno: 0x0000                  // Overlay number
        e_res: 00 00 00 00 00 00 00 00  // Reserved
        e_oemid: 0x0000                 // OEM identifier (for e_oeminfo)
        e_oeminfo: 0x0000               // OEM information; e_oemid specific
        e_res2: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  // Reserved
        e_lfanew: 0x00000080            // File address of the new exe header
    
    each paragragh is 16 byte.


##  TODO

    Win32 Read/Write is done.
    1.  check ENC_SECOND_CODE.
    2.  write win32 app schema.
    3.  write DOS rc4 check.
    4.  write ENC code + rc4 check in win32.