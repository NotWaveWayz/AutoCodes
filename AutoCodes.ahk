;tbd: try clipboard and warn user if broken,better settings,unlimited amount of selection points,support codes from other games (roblox atleast),add exception to autohotkey's toolitp,support multiple instances (maybe)
#NoEnv
#Persistent
#SingleInstance Force
;#Warn
OnExit,Exit
SetWorkingDir %A_ScriptDir%
CodesList := []
MsgSelect := ["Select the side redeem button. 💳`n(Use Middle 🖱 to select.)","Select the code input box. ⌨`n(Use Middle 🖱 to select.)","Select the redeem button. ✔`n(Use Middle 🖱 to select.)","Select the exit button. ❌`n(Use Middle 🖱 to select.)"]

If FileExist("config.ini"){
IniRead, URL, config.ini, Settings | Data,URL
IniRead, IconDark, config.ini, Settings | Icons, IconDark
IniRead, IconLight, config.ini, Settings | Icons, IconLight
IniRead, IconMulti, config.ini, Settings | Icons, IconMulti
;IniRead, CodesList, config.ini, Settings | Codes, CodesList
;IniRead, MsgSelect, config.ini, Settings | Messages, MsgSelect
IniRead, MouseSpeed, config.ini, Settings | Extra,MouseSpeed
IniRead, SCalibration, config.ini, Settings | Calibration,SCalibration
IniRead, Calibrated, config.ini, Settings | Calibration,Calibrated
IniRead, x1, config.ini, Settings | Calibration,x1
IniRead, x2, config.ini, Settings | Calibration,x2
IniRead, x3, config.ini, Settings | Calibration,x3
IniRead, x4, config.ini, Settings | Calibration,x4
IniRead, KeyDelay, config.ini, Settings | Extra,KeyDelay
IniRead, Selection, config.ini, Settings | Extra, Selection
IniRead, SelectionR, config.ini, Settings | Extra, SelectionR
IniRead, Experimental, config.ini, Settings | Experimental, Experimental
SetDefaultMouseSpeed,%MouseSpeed%
SetKeyDelay,%KeyDelay%
}else{
SetKeyDelay,1,-1
SetDefaultMouseSpeed,4
URL := "https://raw.githubusercontent.com/NotWaveWayz/AutoCodes/main/codes.txt"
IconDark := "Dark.ico"
IconLight := "Light.ico"
IconMulti := "Multi.ico"
Selection := 0
SelectionR := 0
Experimental := False
IniWrite, %URL%, config.ini, Settings | Data,URL
IniWrite, %IconDark%, config.ini, Settings | Icons,IconDark
IniWrite, %IconLight%, config.ini, Settings | Icons,IconLight
IniWrite, %IconMulti%, config.ini, Settings | Icons,IconMulti
;IniWrite, %CodesList%, config.ini, Settings | Codes,CodesList
;IniWrite, %MsgSelect%, config.ini, Settings | Messages,MsgSelect
IniWrite, %A_DefaultMouseSpeed%, config.ini, Settings | Extra,MouseSpeed
IniWrite, %SCalibration%, config.ini, Settings | Calibration,SCalibration
IniWrite, %Calibrated%, config.ini, Settings | Calibration,Calibrated
IniWrite, %x1%, config.ini, Settings | Calibration,x1
IniWrite, %x2%, config.ini, Settings | Calibration,x2
IniWrite, %x3%, config.ini, Settings | Calibration,x3
IniWrite, %x4%, config.ini, Settings | Calibration,x4
IniWrite, %A_KeyDelay%, config.ini, Settings | Extra,KeyDelay
IniWrite, %Selection%, config.ini, Settings | Extra,Selection
IniWrite, %SelectionR%, config.ini, Settings | Extra,SelectionR
IniWrite, %Experimental%, config.ini, Settings | Experimental,Experimental
}

If FileExist(IconMulti)
Menu,Tray,Icon,%IconMulti%,,1

; gui settings ;
Gui,5: -MinimizeBox +AlwaysOnTop
Gui,4: -MinimizeBox +AlwaysOnTop
Gui,3: -MinimizeBox +AlwaysOnTop
Gui,2a: -MinimizeBox +AlwaysOnTop
Gui,2: -MinimizeBox +AlwaysOnTop

; main gui ;
Gui,Add,Button,w300 gContinue,▶ Continue ▶
Gui,Add,Button,w300 gSettings,Settings
Gui, Add, StatusBar,,No information available.

; codes manager ;
Gui,2:Add,Text,,What would you like to do?
Gui,2:Add,Button,w150 vCodesLoad gLoad,⤵ Insert Codes ⤵
Gui,2:Add,Button,w150 gViewT,👁 View Raw Text 👁
Gui,2:Add,Button,w150 gSaveL,💾 Save Locally 💾

; additional guis (mainly single purpose) ;
Gui,2a:Add,Edit,vPromptText ReadOnly w300 h300

; settings ;
Gui,5:Add,Button,w150 gLibrary,Library
Gui,5:Add,Button,w150 vCalibrate gCalibrate,Calibrate
Gui,5:Add,Text,,Methods of sending codes:
Gui,5:Add,Radio, vSEMethod gCodeMethod Checked,SendEvent
Gui,5:Add,Radio,vMCMethod gCodeMethod,MClipboard
Gui,5:Font,s6
Gui,5:Add,Text,w150,Note: MClipboard (Magic Clipboard) temporary replaces saved clipboard data until finished.
Gui,5:Font,s7
; expiremental stuff ;
If (Experimental){
Gui,2:Add,Button,w300,💿 Save As Text 💿
}

Gui,Show,,AutoCodes

; maintaince ; 
GoSub,Check
GoSub,UpdateCodes
; gui icon set ;
if (FileExist(IconDark) && FileExist(IconLight)){
RegRead, SystemTheme, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize , SystemUsesLightTheme
Menu,Tray,Icon,% (SystemTheme) ? "Dark.ico" : "Light.ico",,1
}Else If FileExist(IconMulti)
Menu,Tray,Icon,%IconMulti%,,1

Return


CodeMethod:
Return

; save locally ;
SaveL:
FileAppend,- Saved using AutoCodes @ (%A_NowUTC%:UTC) -`n`n%CodesRaw%,AutoCodes%A_NowUTC%.txt
Return


; load codes ;
Load:
CLoading := True
Gui,5:Submit,NoHide
If (MCMethod)
PreClipboard := Clipboard
WinActivate,ahk_exe RobloxPlayerBeta.exe

MouseMove,%xs1%,%ys1%,0
Click,%x1% %y1%

MouseMove,%xs2%,%ys2%,0
Loop % Codes.MaxIndex(){
MouseMove,%xs2%,%ys2%,0
Click,%x2% %y2%
SendInput,^a{BS}
If (MCMethod){
Clipboard := Codes[A_Index]
SendInput,^v
}Else{
Send,% Codes[A_Index]
}
MouseMove,%xs3%,%ys3%,0
Click,%x3% %y3%
MouseMove,%xs2%,%ys2%,0
Click,%x2% %y2%
}
SendInput,^a{BS}
MouseMove,%xs4%,%ys4%,0
Click,%x4% %y4%
If (MCMethod)
Clipboard := PreClipboard
CLoading := False
Return


; > continue > ;
Continue:

Gui,2:Show,,Manager
Return


; view raw text ;
ViewT:
GuiControl,2a:,PromptText,%CodesRaw%
Gui,2a:Show,,Text Viewer
Return

; save as text (ex) ;
SaveT:
doc := ComObjCreate("HTMLFile")
doc.Write(CodesRaw)
ECodes := doc.body.innerText
FileAppend,- Saved using AutoCodes[E] @ (%A_NowUTC%:UTC) -`n`n%ECodes%,AutoCodes%A_NowUTC%.txt
Return

; show settings gui ;
Settings:
Gui,5:Show,,Settings
Return



; middle button calibration ;
~MButton::
If (Calibrating)
GoSub,Calibrate
Return

; calibration ;
Calibrate:
Calibrated := False
Calibrating := True
Selection++
GuiControl,5:Disable,Calibrate
If (Selection < 5){
If (Selection = 1)
ToolTip, % MsgSelect[Selection]
WinGet,CaliCheckWin,ID,ahk_exe RobloxPlayerBeta.exe
MouseGetPos,x%Selection%,y%Selection%,CaliWin
If not (CaliWin = CaliCheckWin){
Selection := SelectionR
Return
}Else{
ToolTip, % MsgSelect[Selection+1]
xs%Selection% := x%Selection% - 1
ys%Selection% := y%Selection% - 1
If (Selection = 1 || Selection = 4)
Click
}If not (Selection < 4){
Loop 500
ToolTip,Successfully Calibrated!
ToolTip
Calibrating := False
Calibrated := True
GuiControl,5:Enable,Calibrate
GoSub,Check
Selection := SelectionR
}
}
Return


; tbd soon (library to select game codes) ;
Library:

Return


; load codes/ update ;
UpdateCodes:
SB_SetText("Loading codes.")
CodesLoading := True

xmlhttp := ComObjCreate("MSXML2.XMLHTTP")
xmlhttp.Open("GET", URL, false)
xmlhttp.Send()

Codes := StrSplit(RTrim(xmlhttp.ResponseText,"`n"),"`n")
CodesRaw := xmlhttp.ResponseText

CodesLoading := False
SB_SetText("Codes Loaded.")
GoSub,Check
Return


; manage stuff ;
Check:
If not (Calibrated){
GuiControl,Disable,▶ Continue ▶
SB_SetText("Mouse positions must be calibrated first.")
}Else If (Calibrated){
GuiControl,Enable,▶ Continue ▶
SB_SetText("Mouse positions successfully calibrated.")
}Else
SB_SetText("No information available.")
Return


; boring exit stuff ;


GuiClose:
ExitApp
Return

Exit:
If (MCMethod && CLoading)
Clipboard := PreClipboard
If (Calibrated && SCalibraiton){
IniWrite, %Calibrated%, config.ini, Settings | Calibration,Calibrated
IniWrite, %x1%, config.ini, Settings | Calibration,x1
IniWrite, %x2%, config.ini, Settings | Calibration,x2
IniWrite, %x3%, config.ini, Settings | Calibration,x3
IniWrite, %x4%, config.ini, Settings | Calibration,x4
}
ExitApp
Return
