rem copy /Y "..\Source\HapCodec\Win32\Debug\HapCodec.dll" "Build32\HapCodec.dll"
rem copy /Y "..\Source\HapCodec\Win32\Debug\HapTransform.dll" "Build32\HapTransform.dll"
rem copy /Y "..\Source\HapCodec\x64\Debug\HapCodec.dll" "Build64\HapCodec.dll"
rem copy /Y "..\Source\HapCodec\x64\Debug\HapTransform.dll" "Build64\HapTransform.dll"
rem copy /Y "..\Source\HapCodec\Win32\Release\HapCodec.dll" "Build32\HapCodec.dll"
rem copy /Y "..\Source\HapCodec\Win32\Release\HapTransform.dll" "Build32\HapTransform.dll"
rem copy /Y "..\Source\HapCodec\x64\Release\HapCodec.dll" "Build64\HapCodec.dll"
rem copy /Y "..\Source\HapCodec\x64\Release\HapTransform.dll" "Build64\HapTransform.dll"
@echo off

Set RegQry=HKLM\Hardware\Description\System\CentralProcessor\0
 
REG.exe Query %RegQry% > checkOS.txt
 
Find /i "x86" < CheckOS.txt > StringCheck.txt
 
If %ERRORLEVEL% == 0 (
	del StringCheck.txt
	Echo "32 Bit Operating system detected, installing 32 bit HAP codec"
	copy hapcodec.inf %windir%\system32\
	copy Build32\hapcodec.dll %windir%\system32\
	rem copy Build32\haptransform.dll %windir%\system32\

	cd /d %windir%\system32\
	rundll32 setupapi.dll,InstallHinfSection DefaultInstall 0 %windir%\system32\hapcodec.inf
	rem regsvr32.exe /S haptransform.dll
) ELSE (
	del StringCheck.txt
	Echo "64 Bit Operating System detected, installing 64 bit and 32 bit HAP codecs"

	copy hapcodec.inf %windir%\system32\
	copy Build64\hapcodec.dll %windir%\system32\
	rem copy Build64\haptransform.dll %windir%\system32\

	copy hapcodec.inf %windir%\SysWOW64\
	copy Build32\hapcodec.dll %windir%\SysWOW64\
	rem copy Build32\haptransform.dll %windir%\SysWOW64\

	cd /d %windir%\system32\
	rundll32 setupapi.dll,InstallHinfSection DefaultInstall 0 %windir%\system32\hapcodec.inf
	rem regsvr32.exe /S haptransform.dll

	cd /d %windir%\SysWOW64\
	rundll32 setupapi.dll,InstallHinfSection DefaultInstall 0 %windir%\SYSWOW64\hapcodec.inf
	rem regsvr32.exe /S haptransform.dll
)
pause
exit
