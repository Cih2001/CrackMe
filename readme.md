### Script for path:

set path=C:\bfi;C:\NASM;C:\ALINK;"C:\Program Files (x86)\Bochs-2.6.9";C:\MinGW\bin;%path%

### Tools needed:

    nasm - Famous assembler.
    alinker - To link DOS stub.
    linker - Microsoft linker to generate PE file and replace DOS stub.
    bfi - A command line tool to create disk images https://sites.google.com/site/lanestech/home/bfi.zip
    bochs - To emulate and debug DOS stub.

### How to debug
    IDA > DEBUGGER > RUN > Local Bochs > Open bochsrc.cfg 