set MicrosoftLinker="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars32.bat"
set PATH=%PATH:C:\cygwin64\bin;=%  
set PATH=%PATH:c:\tools\cygwin\bin;=%  
set PATH=C:\Python27;C:\bfi;C:\NASM;C:\ALINK;C:\Program Files (x86)\Bochs-2.6.9;C:\MinGW\bin;%PATH% 
%comspec% /k %MicrosoftLinker%
