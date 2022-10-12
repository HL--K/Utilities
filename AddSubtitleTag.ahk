

/*
To add html tags to .srt file for font size, color, etc.
eg, <font face="Helvetica" size="80" color="#FFFFFF">First line of the subtitle</font>
 */

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#SingleInstance Force
#NoEnv
;SetWorkingDir %A_ScriptDir%
SetBatchLines -1
defaultFolder1 = %A_WorkingDir%
Prefix = <font >
Suffix = </font>


;iniName = %A_ScriptName%.ini
iniName := StrReplace(A_ScriptName, ".ahk", ".ini")
IfExist, %iniName%
{
	IniRead, defaultFolder1, %iniName%, MainSection, folder1, %A_Space%
	IniRead, Prefix, %iniName%, MainSection, Prefix, %Prefix%
	IniRead, Suffix, %iniName%, MainSection, Suffix, %Suffix%
}

SelFolder1 = %defaultFolder1%

Gui +Resize
Gui, Font, s14
Gui Add, Text, x202 y13 w269 h30, Add Subtitle Tag to srt File
Gui, Font, s10

Gui, Add, Text, x34 y55, Source (full path)
Gui, Add, Text, x34 y104, Destination (full path)

Gui Add, Edit, x34 y70 w518 h23 vTextBox1
Gui Add, Button, x590 y66 w93 h28 vButton1 gButton1, Browse

Gui Add, Edit, x34 y119 w518 h23 vTextBox2

Gui Add, Text, x42 y200  , Prefix
Gui Add, Text, x42 y250  , Suffix

Gui Add, Edit, x90 y196 w400 h23 vPrefix, %Prefix%
Gui Add, Edit, x90 y246 w400 h23 vSuffix, %Suffix%

Gui, Font, s8
Gui Add, Text, x92 y220, eg, <font face="Helvetica" size="80" color="#FFFFFF">
Gui Add, Text, x92 y270, usually, </font>

Gui, Font, s10
Gui Add, Button, x294 y320 w91 h30 gGo, Go

Gui Show, w732 h400, Burn Subtitle
Return

;    Function to move and resize control automatically when GUI resizes.
AutoXYWH(DimSize, cList*){       ; http://ahkscript.org/boards/viewtopic.php?t=1079

  static cInfo := {}

  If (DimSize = "reset")
    Return cInfo := {}

  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If ( cInfo[ctrlID].x = "" ){
        GuiControlGet, i, %A_Gui%:Pos, %ctrl%
        MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
        fx := fy := fw := fh := 0
        For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]")))
            If !RegExMatch(DimSize, "i)" dim "\s*\K[\d.-]+", f%dim%)
              f%dim% := 1
        cInfo[ctrlID] := { x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a , m:MMD}
    }Else If ( cInfo[ctrlID].a.1) {
        dgx := dgw := A_GuiWidth  - cInfo[ctrlID].gw  , dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
        For i, dim in cInfo[ctrlID]["a"]
            Options .= dim (dg%dim% * cInfo[ctrlID]["f" dim] + cInfo[ctrlID][dim]) A_Space
        GuiControl, % A_Gui ":" cInfo[ctrlID].m , % ctrl, % Options
  } } }

GuiSize:
    AutoXYWH("w", "TextBox1")
    AutoXYWH("x", "Button1" )
    AutoXYWH("w", "TextBox2")
    AutoXYWH("w", "Prefix")
    AutoXYWH("w", "Suffix" )
Return



Button1:
FileSelectFile, SelectedFile, 3, %SelFolder1% , Open a file, (*.srt)
if SelectedFile =
{
	MsgBox, The user didn't select anything.
	return
}
; display the selected file in the text box
GuiControl, ,TextBox1, %SelectedFile%
; set default destination file path
SplitPath, SelectedFile, name, dir, ext, name_no_ext
;
dest := dir . "\" . name_no_ext . "_1.srt"
GuiControl, ,TextBox2, %dest%
; set default srt file path, if available in same folder. Else, leave blank
srt2 := dir . "\" . name_no_ext . "_1.srt"

Return


go:
FileDelete, %srt2%
GuiControlGet, Prefix
GuiControlGet, Suffix

Loop, read,  %SelectedFile%, %srt2%
{
    v := trim(A_LoopReadLine)
	if (v = "")
	{
		FileAppend, `n
		continue
	}
	if v is integer
	{
		FileAppend, %A_LoopReadLine%`n
		continue
	}
	if InStr(A_LoopReadLine, "-->")
	{
		FileAppend, %A_LoopReadLine%`n
		continue
	}
	FileAppend, %Prefix%%A_LoopReadLine%%Suffix%`n
}

return


;*********
GuiClose:
;*********

  IniWrite, %dir%, %iniName%, MainSection, Folder1
  IniWrite, %Prefix%, %iniName%, MainSection, Prefix
  IniWrite, %Suffix%, %iniName%, MainSection, Suffix
  ExitApp
Return
