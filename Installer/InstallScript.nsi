; Installation Script (C) 2013-2014 RenderHeads Ltd.  All Rights Reserved.
; ________________________________________________________________________

!define     PRODUCTNAME             "Hap Codec"
!define     SHORTVERSION            "1.0.4"
!define     TITLE             "${PRODUCTNAME} ${SHORTVERSION}"

SetCompressor /Solid lzma
RequestExecutionLevel admin

InstallDir "$PROGRAMFILES\${PRODUCTNAME}"

!include x64.nsh

Function .onInit
	UserInfo::GetAccountType
	pop $0
	${If} $0 != "admin" ;Require admin rights on NT4+
	    MessageBox mb_iconstop "Administrator rights required!"
	    SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
	    Quit
	${EndIf}
FunctionEnd

Name "${TITLE}"
Caption "${TITLE}"

OutFile "HapCodecSetup.exe"

;Icon			"icon.png"

XPStyle on


; _____________________________
; Install Pages
;

PageEx instfiles
    Caption " - Installing"
PageExEnd

; ____________________________
; Program Files Operations
;

Section "FilesInstall"
	SetShellVarContext all

	${if} ${RunningX64}
		SetRegView 64
		;MessageBox MB_OK "running on x64"
		SetOutPath $SYSDIR
		${DisableX64FSRedirection}
		File "hapcodec.inf"
		File "Build64\HapCodec.dll"
;		File "Build64\HapTransform.dll"		
		ExecWait '$SYSDIR\RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultInstall 132 $SYSDIR\hapcodec.inf'
;		ExecWait '$SYSDIR\regsvr32.exe /S HapTransform.dll'

		${EnableX64FSRedirection}
		SetOutPath $WINDIR\SysWOW64
		File "hapcodec.inf"
		File "Build32\HapCodec.dll"
;		File "Build32\HapTransform.dll"			
		ExecWait '$WINDIR\SysWOW64\RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultInstall 132 $WINDIR\SysWOW64\hapcodec.inf'
;		ExecWait '$WINDIR\SysWOW64\regsvr32.exe /S HapTransform.dll'

		SetRegView 32
	${else}
		;MessageBox MB_OK "running on x86"
		SetOutPath $SYSDIR
		File "hapcodec.inf"
		File "Build32\HapCodec.dll"
;		File "Build32\HapTransform.dll"			

		ExecWait '$SYSDIR\RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultInstall 132 $SYSDIR\hapcodec.inf'
;		ExecWait '$SYSDIR\regsvr32.exe /S HapTransform.dll'
	${endif}
SectionEnd


; _____________________________
; Registry Operations
;

Section "Registry"
	;MessageBox MB_OK "registry"
	SetOutPath $INSTDIR

	; Write the uninstall keys for Windows
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCTNAME}" "DisplayName" "${PRODUCTNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCTNAME}" "UninstallString" '"$INSTDIR\uninstall.exe"'
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCTNAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCTNAME}" "NoRepair" 1
   	WriteUninstaller "$INSTDIR\uninstall.exe"


	CreateDirectory "$SMPROGRAMS\${PRODUCTNAME}"
	CreateShortCut "$SMPROGRAMS\${PRODUCTNAME}\Uninstall.lnk" "$INSTDIR\uninstall.exe"
SectionEnd

; _______________________
; Uninstall
;

UninstPage uninstConfirm
UninstPage instfiles

Section "Uninstall"

	SetShellVarContext all

	${if} ${RunningX64}
		;MessageBox MB_OK "running on x64"

		SetRegView 64
		ExecWait '$SYSDIR\RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultUninstall 132 $SYSDIR\hapcodec.inf'
		Delete '$SYSDIR\hapcodec.inf'
		Delete '$SYSDIR\HapCodec.dll'
;		Delete '$SYSDIR\HapTransform.dll'

		ExecWait '$WINDIR\SysWOW64\RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultUninstall 132 $WINDIR\SysWOW64\hapcodec.inf'
		Delete '$WINDIR\SysWOW64\hapcodec.inf'
		Delete '$WINDIR\SysWOW64\HapCodec.dll'
;		Delete '$WINDIR\SysWOW64\HapTransform.dll'
		SetRegView 32
	${else}
		;MessageBox MB_OK "running on x86"
		ExecWait '$SYSDIR\RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultUninstall 132 $SYSDIR\hapcodec.inf'
		Delete '$SYSDIR\hapcodec.inf'
		Delete '$SYSDIR\HapCodec.dll'
	${endif}

	; remove registry keys
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCTNAME}"

    ; remove the links from the start menu
    RMDir /r "$SMPROGRAMS\${PRODUCTNAME}"

    RMDir /r "$INSTDIR"	
SectionEnd