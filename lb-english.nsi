!define LB "Little Busters!"
!define VERSION "7.0-pre1"

!define RITO "リトルバスターズ！"

!if ${VER} == "EX"
!define RITOEXT "ＥＸ"
!define VERSIONEXT "ex-"
!define ONAME "${LB} Ecstasy"
!define Sc "Script/ex"
!else if ${VER} == "ME"
!define RITOEXT "_ME_ALL"
!define VERSIONEXT "me-"
!define ONAME "${LB} Memorial Edition"
!define Sc "Script/me"
!else
!define RITOEXT ""
!define VERSIONEXT ""
!define ONAME "${LB}"
!define Sc "Script"
!endif

!define ENAME "${ONAME} English"
!define Sn "${Sc}/snapshots"

!include "Sections.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"
!insertmacro DirState

Name "${ENAME}"
OutFile "lb-english-${VERSIONEXT}${VERSION}.exe"
BrandingText "${ENAME} v${VERSION}"
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
Function .onGUIInit
  ReadRegStr $INSTDIR HKCU "Software\KEY\${RITO}${RITOEXT}" "DAT_FOLDER"
  StrCmp $INSTDIR "" 0 Set
    MessageBox MB_OK "Could not find your ${ONAME} installation directory by an automatic method.$\n\
    This can happen if ${ONAME} is not installed correctly, or if the registry has been modified.$\n\
    Please specify it manually."
    StrCpy $INSTDIR "C:\KEY\${RITO}${RITOEXT}"
  Set:
FunctionEnd

; Request application privileges for Windows Vista
RequestExecutionLevel user

Page directory directoryImage "" checkInstDir
Page components componentsImage "" warnForSEEN
Page instfiles instfilesImage
Page custom installedPage installedPageLeave

ComponentText "It's possible to patch only the images or only the scripts. The subtitles are optional." " " "Please select the files you want to install."
DirText "Select the installation directory of ${ONAME}.$\n$\nThis installer does not make a backup of the changed files, you will have to reinstall ${ONAME} to uninstall this patch."
MiscButtonText "" "" "" "Done!"

Section "Images" SecImg
  SetOutPath "$INSTDIR\G00"
  File G00\*.g00
!ifdef VER
  File EG00\*.g00
!if ${VER} == "EX"
  File xg00\*.g00
!endif
!endif
SectionEnd


Section "Script files" SecSEEN
  SetOutPath "$INSTDIR"
  Delete "$INSTDIR\SEEN*.TXT"
  File ${Sn}\SEEN.TXT
  File ${Sn}\GAMEEXE.INI
!if ${VER} == "EX"
  SetOutPath "$INSTDIR\MANUAL"
  File Manual\gun.htm
  SetOutPath "$INSTDIR\MANUAL\image"
  File Manual\image\onoff_gun2.jpg
!endif
SectionEnd

Section "Subtitles" SecSub
  SetOutPath "$INSTDIR\MOV"
  File ${Sn}\op00.ass
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
  !insertmacro SectionFlagIsSet ${SecSub} ${SF_SELECTED} Sub SubUN
  SubUN:
  !insertmacro SectionFlagIsSet ${SecImg} ${SF_SELECTED} Img ImgUN
  ImgUN:
    MessageBox MB_OK "Nothing selected..."
    Abort
  Sub:
  Img:
FunctionEnd


Function checkInstDir
  !insertmacro ClearSectionFlag ${SecImg} ${SF_RO}
  !insertmacro SelectSection ${SecImg}
  IfFileExists "$INSTDIR\REALLIVE.EXE" Good
    MessageBox MB_OK "That is not a valid installation directory.$\nPlease select the installation directory of ${ONAME}"
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



Function componentsImage
  !insertmacro BIMAGE "img\img08.bmp"
FunctionEnd
Function directoryImage
  !insertmacro BIMAGE "img\img01.bmp"
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
  ${NSD_CreateCheckBox} 0 13u 100% -13u "Play ${ENAME}"
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

