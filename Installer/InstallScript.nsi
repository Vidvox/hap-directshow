; Installation Script (C) 2013-2015 RenderHeads Ltd.  All Rights Reserved.
; ________________________________________________________________________

!define     PRODUCTNAME             "Hap DirectShow Codec"
!define     SHORTVERSION            "1.0.12"
!define     TITLE					"${PRODUCTNAME} ${SHORTVERSION}"

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

OutFile "HapDirectShowCodecSetup.exe"

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

	; 64-bit install
	${if} ${RunningX64}
		SetRegView 64
		;MessageBox MB_OK "running on x64"
		SetOutPath $SYSDIR
		${DisableX64FSRedirection}
		File "hapcodec.inf"
		File "Build64\HapCodec.dll"
		ExecWait '$OUTDIR\RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultInstall 132 $OUTDIR\hapcodec.inf'
;		ExecWait '$OUTDIR\regsvr32.exe /S HapTransform.dll'

		${EnableX64FSRedirection}
		SetOutPath $WINDIR\SysWOW64
		SetRegView 32
	${else}
		;MessageBox MB_OK "running on x86"
		SetOutPath $SYSDIR
	${endif}

		File "hapcodec.inf"
		File "Build32\HapCodec.dll"
		ExecWait '$OUTDIR\RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultInstall 132 $OUTDIR\hapcodec.inf'
;		ExecWait '$OUTDIR\regsvr32.exe /S HapTransform.dll'

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
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCTNAME}" "Publisher" 'RenderHeads Ltd'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCTNAME}" "DisplayVersion" "1.0.10"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCTNAME}" "Version" 0x010a0000
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCTNAME}" "VersionMajor" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCTNAME}" "VersionMinor" 10
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCTNAME}" "EstimatedSize" 2048
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

		${DisableX64FSRedirection}
		SetOutPath $SYSDIR
		SetRegView 64
		ExecWait '$OUTDIR\RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultUninstall 132 $OUTDIR\hapcodec.inf'
		;Delete '$OUTDIR\hapcodec.inf'
		;Delete '$OUTDIR\HapCodec.dll'

		${EnableX64FSRedirection}
		SetRegView 32
		SetOutPath $WINDIR\SysWOW64
		ExecWait '$OUTDIR\RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultUninstall 132 $OUTDIR\hapcodec.inf'
		;Delete '$OUTDIR\hapcodec.inf'
		;Delete '$OUTDIR\HapCodec.dll'
		
	${else}
		;MessageBox MB_OK "running on x86"
		SetOutPath $SYSDIR
		ExecWait '$OUTDIR\RUNDLL32.EXE SETUPAPI.DLL,InstallHinfSection DefaultUninstall 132 $OUTDIR\hapcodec.inf'
		;Delete '$OUTDIR\hapcodec.inf'
		;Delete '$OUTDIR\HapCodec.dll'
	${endif}

	; remove registry keys
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCTNAME}"

    ; remove the links from the start menu
    RMDir /r "$SMPROGRAMS\${PRODUCTNAME}"

    RMDir /r "$INSTDIR"	
SectionEnd