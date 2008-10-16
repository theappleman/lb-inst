
!define VERSION "0.3"


!include "Sections.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"
!insertmacro DirState

Name "Little Busters! English"
OutFile "lb-english-${VERSION}.exe"
BrandingText "lb-english v${VERSION}"
Icon LB.ico
XPStyle on
WindowIcon off
SetCompressor /SOLID lzma
AddBrandingImage left 100



; from the gfx.nsi example
!macro BIMAGE IMAGE
  Push $0
  GetTempFileName $0
  File /oname=$0 ${IMAGE}
  ;MessageBox MB_OK "${IMAGE} - $0"
  SetBrandingImage $0
  Delete $0
  Pop $0
!macroend



; The default installation directory
; (Uhm... Unicode?)
InstallDir "C:\KEY\���g���o�X�^�[�Y�I"

; Request application privileges for Windows Vista
RequestExecutionLevel user

PageEx license
  Caption ": Readme"
  PageCallbacks licenseImage
PageExEnd
Page directory directoryImage "" checkInstDir
Page components componentsImage "" warnForSEEN
Page instfiles instfilesImage
Page custom installedPage installedPageLeave

LicenseData readme.txt
LicenseText "Welcome to the Little Busters! English translation setup!" "Next >"
ComponentText "It's possible to patch only the images or only the scripts." " " "Please select the files you want to install."
DirText "Select the installation directory of Little Busters!$\n$\nThis installer does not make a backup of the changed files, you will have to reinstall Little Busters! to uninstall this patch."
MiscButtonText "" "" "" "Done!"

Section "Images" SecImg
  SetOutPath "$INSTDIR\G00"
  File G00\*
SectionEnd


Section "Script files" SecSEEN
  SetOutPath "$INSTDIR"
  File Script\*
SectionEnd


Function warnForSEEN
  !insertmacro SectionFlagIsSet ${SecSEEN} ${SF_SELECTED} Seen SeenUN
  Seen:
    ${DirState} "$INSTDIR\SAVEDATA" $R0
    ${If} $R0 == 1
      MessageBox MB_YESNO "Warning: Your existing save files may not work anymore after installing the script files!$\nAre you sure you want to continue?" IDYES Img
      Abort
    ${EndIf}
    Goto Img
  SeenUn:
  !insertmacro SectionFlagIsSet ${SecImg} ${SF_SELECTED} Img ImgUN
  ImgUN:
    MessageBox MB_OK "Nothing selected..."
    Abort
  Img:
FunctionEnd


Function checkInstDir
  !insertmacro ClearSectionFlag ${SecImg} ${SF_RO}
  !insertmacro SelectSection ${SecImg}
  IfFileExists "$INSTDIR\REALLIVE.EXE" Good
    MessageBox MB_OK "Please select the installation directory of Little Busters!"
    Abort
  Good:
  IfFileExists "$INSTDIR\G00" Good2
    MessageBox MB_OKCANCEL "No G00 directory found, the translated images won't be installed.$\n$\nA standard installation is required to install the image files." IDOK okbut
      Abort
    okbut:
      !insertmacro UnselectSection ${SecImg}
      !insertmacro SetSectionFlag ${SecImg} ${SF_RO}
  Good2:
FunctionEnd



Function licenseImage
  !insertmacro BIMAGE "img\img01.bmp"
FunctionEnd
Function componentsImage
  !insertmacro BIMAGE "img\img08.bmp"
FunctionEnd
Function directoryImage
  !insertmacro BIMAGE "img\img07.bmp"
FunctionEnd
Function instfilesImage
  !insertmacro BIMAGE "img\img02.bmp"
FunctionEnd


Var Dialog
Var Lbl1
var Chk
Function installedPage
  !insertmacro BIMAGE "img\img06.bmp"
  nsDialogs::Create /NOUNLOAD 1018
  Pop $Dialog
  ${If} $Dialog == error
    Abort
  ${EndIf}
  ${NSD_CreateLabel} 0 0 100% 12u "All done"
  Pop $Lbl1
  ${NSD_CreateCheckBox} 0 13u 100% -13u "Play Little Busters!" 
  Pop $Chk
  nsDialogs::Show
FunctionEnd

Var ChkState
Function installedPageLeave
  ${NSD_GetState} $Chk $ChkState
  ${If} $ChkState == ${BST_CHECKED}
    Exec '"$INSTDIR\REALLIVE.EXE"'
  ${EndIf}
FunctionEnd