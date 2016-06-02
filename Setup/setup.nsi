  SetCompressor lzma
# Variables
  !define Product "Virtual Salesman"
  !define Version "3.3.3"

# Configuration
  Name "${Product} ${Version}"
  OutFile "..\VS3Setup.exe"
  InstallDir "$PROGRAMFILES\${Product}"
  InstallDirRegKey HKLM "Software\${Product}" "Install Dir"
  XPStyle On

# Modern UI Configuration
  !include "MUI.nsh"
  !define MUI_ICON "images\install.ico"
  !define MUI_UNICON "images\uninstall.ico"
  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "images\install.bmp"
  !define MUI_HEADERIMAGE_UNBITMAP "images\uninstall.bmp"
  !define MUI_HEADERIMAGE_RIGHT
  !define MUI_WELCOMEFINISHPAGE_BITMAP "images\welcome.bmp"
  !define MUI_ABORTWARNING
  !define MUI_WELCOMEPAGE_TITLE_3LINES

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_LANGUAGE "English"

# Begin Section
Section "Virtual Salesman" SecMain
SectionIn RO
  ; Delete files
  Delete "$INSTDIR\*.lang"
  Delete "$INSTDIR\VV3.exe"
  Delete "$INSTDIR\Web\VV3.cgi"
  ; Rename files
  Push "$INSTDIR"
  Call ScanDir
  Rename "$INSTDIR\vv3.dat" "$INSTDIR\users.dat"
  Rename "$INSTDIR\vv3.ini" "$INSTDIR\vs3.ini"
  ; Add files
  SetOutPath "$INSTDIR"
  SetOverWrite Off
  File "users.dat"
  SetOverWrite On
  File "VS3.exe"
  File "License.txt"
  File "Changes.txt"
  File "Help.chm"
  SetOutPath "$INSTDIR\Web"
  File "Web\exemple.v3i"
  File "Web\exemple-en.html"
  File "Web\exemple-fr.html"
  File "Web\VS3.cgi"
  SetOutPath "$INSTDIR"

  ;Create start-menu items
  CreateShortCut "$SMPROGRAMS\Virtual Salesman 3.lnk" "$INSTDIR\VS3.exe"
  CreateShortCut "$DESKTOP\Virtual Salesman 3.lnk" "$INSTDIR\VS3.exe"

  ; Write installation information to the registry
  WriteRegStr HKLM "Software\${Product}" "Install Dir" "$INSTDIR"
  WriteRegDWORD HKLM "Software\${Product}" "Install Language" $LANGUAGE

  ; Write uninstall information to the registry
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${Product}" "DisplayIcon" "$INSTDIR\VS3.exe,0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${Product}" "DisplayName" "${Product}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${Product}" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${Product}" "ModifyPath" "$INSTDIR"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${Product}" "NoModify" 1

  ; Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

SubSection "Languages" SecLang
   
Section "English" SecLangEn
  ;Add files
  SetOutPath "$INSTDIR"
  SetOverWrite On
  File "VS3EN.lang"
SectionEnd

Section "Français" SecLangFr
  ;Add files
  SetOutPath "$INSTDIR"
  SetOverWrite On
  File "VS3FR.lang"
SectionEnd

SubSectionEnd

# Installer Functions
#Function .onInit
#  MessageBox MB_OK "Warning!! If the Virtual Salesman version you actually use is older than 3.3.0, then make sure you have a backup of your company files before proceeding with the installation (Those files are in your Virtual Salesman installation folder)!"
#FunctionEnd

Function ScanDir
  Exch $2
  Push $0
  Push $1
  IfErrors 0 0  ; Resets the error flag
  FindFirst $0 $1 "$2\*.*"
  IfErrors done
  loop:
    StrCmp $1 "." next
    StrCmp $1 ".." next
    StrCpy $3 $1 4 -4
    StrCmp $3 ".vv3" cie
    StrCmp $3 ".v3o" op
    StrCmp $3 ".*" next else
    cie: 
    StrCpy $4 $1 -4 0
    Rename "$2\$1" "$2\$4.vs3"
    Goto next
    op: 
    StrCpy $4 $1 1 0
    StrCmp $4 "S" quo
    StrCmp $4 "C" ord
    StrCmp $4 "F" inv
    Goto next
    quo:
    StrCpy $4 $1 -4 1
    Rename "$2\$1" "$2\Q$4.v3t"
    Goto next
    ord:
    StrCpy $4 $1 -4 1
    Rename "$2\$1" "$2\O$4.v3t"
    Goto next
    inv:
    StrCpy $4 $1 -4 1
    Rename "$2\$1" "$2\I$4.v3t"
    Goto next
    else:
    Push "$2\$1"
    Call ScanDir
    StrCmp $1 "Soumissions" folder 
    StrCmp $1 "Commandes" folder 
    StrCmp $1 "Factures" folder 
    Goto next
    folder:
    IfFileExists "$2\Transactions\" +2
    CreateDirectory "$2\Transactions\"
    CopyFiles /SILENT "$2\$1\*.*" "$2\Transactions\"
    IfErrors next
    RmDir /r "$2\$1"
    next:
      IfErrors 0 0  ; Resets the error flag
      FindNext $0 $1
      IfErrors done loop
  done:
  FindClose $0
  Pop $1
  Pop $0
  Pop $2
FunctionEnd

# Uninstaller Section
Section "Uninstall"
  ;Delete Files And Directory
  Delete "$INSTDIR\Web\*.*"
  RmDir "$INSTDIR\Web"
  Delete "$INSTDIR\*.*"
  RmDir "$INSTDIR"

  ;Delete Shortcuts
  Delete "$SMPROGRAMS\Virtual Salesman 3.lnk"
  Delete "$DESKTOP\Virtual Salesman 3.lnk"

  ;Delete Uninstaller And Uninstall Registry Entries
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${Product}"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${Product}"
SectionEnd