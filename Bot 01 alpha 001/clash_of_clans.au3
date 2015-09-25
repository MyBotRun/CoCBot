#RequireAdmin
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <TrayConstants.au3>
#include <Misc.au3>
#include <Tesseract.au3>

Opt("MouseClickDelay", 10)
Opt("MouseClickDownDelay", 10)
Opt("MouseCoordMode", 0)
Opt('PixelCoordMode', 0)

$Title = "BlueStacks App Player"
$Full = WinGetTitle($Title)
$HWnD = WinGetHandle($Full)
WinActivate($HWnD)

Global $Left = 45, $Top = 70, $Right = 660, $Bottom = 490
Global $BSsize = WinGetClientSize($HWnD)
Global $x_ratio = $BSsize[0] / 800, $y_ratio = $BSsize[1] / 600

Global $Gold, $Elixir, $MinGold = 50000, $MinElixir = 50000
Global $SearchMode = 1, $SearchCheck = 0, $ErrorCheck = 0

Global $UpLeft[5][2] = [[350 * $x_ratio, 51 * $y_ratio], [230 * $x_ratio, 100 * $y_ratio], [186 * $x_ratio, 160 * $y_ratio], [144 * $x_ratio, 187 * $y_ratio], [125 * $x_ratio, 200 * $y_ratio]]
Global $UpRight[5][2] = [[460 * $x_ratio, 62 * $y_ratio], [520 * $x_ratio, 97 * $y_ratio], [570 * $x_ratio, 134 * $y_ratio], [647 * $x_ratio, 186 * $y_ratio], [692 * $x_ratio, 211 * $y_ratio]]
Global $LowLeft[5][2] = [[77 * $x_ratio, 306 * $y_ratio], [130 * $x_ratio, 353 * $y_ratio], [181 * $x_ratio, 395 * $y_ratio], [214 * $x_ratio, 415 * $y_ratio], [250 * $x_ratio, 442 * $y_ratio]]
Global $LowRight[5][2] = [[734 * $x_ratio, 290 * $y_ratio], [685 * $x_ratio, 318 * $y_ratio], [630 * $x_ratio, 350 * $y_ratio], [600 * $x_ratio, 369 * $y_ratio], [535 * $x_ratio, 425 * $y_ratio]]

Global $Troop[5][2] = [[60 * $x_ratio, 505 * $y_ratio], [130 * $x_ratio, 505 * $y_ratio], [200 * $x_ratio, 505 * $y_ratio], [265 * $x_ratio, 505 * $y_ratio], [372 * $x_ratio, 505 * $y_ratio]]
Global $Barbarian[2] = [0, 0], $Archer[2] = [0, 0], $Giant[2] = [0, 0]
Global $Goblin[2] = [0, 0]

Global $B1Pos[2] = [0, 0], $B2Pos[2] = [0, 0], $B3Pos[2] = [0, 0], $B4Pos[2] = [0, 0]
Global $Paused
Global $B1Troop, $B2Troop, $B3Troop, $B4Troop

HotKeySet("+{ESC}", "Terminate")

#Region ### GUI ###
$BotGUI = GUICreate("Clash of Clans Bot", 280, 170)
GUICtrlSetFont(-1, 10, 800, 0, "Calibri")
$MeetAll = GUICtrlCreateCheckbox("Meet all conditions", 150, 20, 140, 17)
GUICtrlCreateLabel("Min Gold:", 150, 48, 58, 17)
$MinGoldInput = GUICtrlCreateInput("", 200, 44, 55, 21, $ES_NUMBER)
GUICtrlSetLimit(-1, 6)
GUICtrlCreateLabel("Min Elixir:", 150, 72, 57, 17)
$MinElixirInput = GUICtrlCreateInput("", 200, 68, 55, 21, $ES_NUMBER)
GUICtrlSetLimit(-1, 6)
$Barrack01 = GUICtrlCreateCombo("Barrack 01", 30, 16, 80, 30, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarian|Archer|Goblin|Giant")
$Barrack02 = GUICtrlCreateCombo("Barrack 02", 30, 40, 80, 30, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarian|Archer|Goblin|Giant")
$Barrack03 = GUICtrlCreateCombo("Barrack 03", 30, 64, 80, 30, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarian|Archer|Goblin|Giant")
$Barrack04 = GUICtrlCreateCombo("Barrack 04", 30, 88, 80, 30, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarian|Archer|Goblin|Giant")
$StartButton = GUICtrlCreateButton("START (Shift+ESC to Exit)", 30, 120, 220, 40)
GUISetState(@SW_SHOW)
#EndRegion ### GUI ###

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			$ExitCheck = MsgBox(4 + 65536, "Confirm Exit", "Are you sure you want to exit?", 0, $BotGUI)
			If $ExitCheck = 6 Then
				Exit
			EndIf
		Case $StartButton
			Start()
	EndSwitch
WEnd

Func Start()
	Sleep(1000)
	;While 1
	CheckIdle() ;Check disconnect message and click on reload
	GetInput() ;Read user's input
	ZoomOut()
	LocateBarrack() ;If barrack not located, ask user to manually click on barrack to locate position
	Train() ;Train troop according to user's input
	;Sleep(900000)	;Wait 15 mins for troops training
	;AssignTroop()	;Assign troop type to troop position in attack (unfinished)
	PrepareAttack() ;Click Attack
	VillageSearch() ;Search gold & elixir according to input
	;DropTroop()	;Drop troop in order: Giant, Barbarian, Archer (unfinished)
	DropAll() ;Drop everything
	Sleep(180000) ;Wait 3 mins
	ControlClick($HWnD, "", "", "left", "1", 400 * $x_ratio, 450 * $y_ratio) ;Click Return Home
	;Sleep(10000)
	;WEnd
EndFunc   ;==>Start

Func CheckIdle()
	WinActivate($HWnD)
	$ColorCheck = PixelGetColor(560 * $x_ratio, 333 * $y_ratio, $HWnD)
	If Hex($ColorCheck, 6) = 282828 Then
		ControlClick($HWnD, "", "", "left", "1", 205 * $x_ratio, 330 * $y_ratio)
		Sleep(10000)
	EndIf
EndFunc   ;==>CheckIdle

Func GetInput()
	$B1Troop = GUICtrlRead($Barrack01)
	$B2Troop = GUICtrlRead($Barrack02)
	$B3Troop = GUICtrlRead($Barrack03)
	$B4Troop = GUICtrlRead($Barrack04)
	$MinGold = Number(GUICtrlRead($MinGoldInput))
	$MinElixir = Number(GUICtrlRead($MinElixirInput))
	If GUICtrlRead($MeetAll) = $GUI_CHECKED Then
		$SearchMode = 2
	Else
		$SearchMode = 1
	EndIf
EndFunc   ;==>GetInput

#Region ##### TRAIN #####
Func FindPos(ByRef $Pos)
	Local $x = 1
	While $x = 1
		If _IsPressed("01") Then
			$Pos = MouseGetPos()
			$x = 0
		EndIf
	WEnd
EndFunc   ;==>FindPos

Func LocateBarrack()
	Local $ClickCheck, $LocateCheck = 0
	While 1
		While 1
			If $B1Pos[0] = 0 Then
				$ClickCheck = MsgBox(6 + 65536, "Locate first barrack", "Click Continue then click on your first barrack. Cancel if not available", 0, $BotGUI)
				If $ClickCheck = 11 Then
					WinActivate($HWnD)
					FindPos($B1Pos)
				ElseIf $ClickCheck = 10 Then
					$B1Pos[0] = 0
					$B2Pos[0] = 0
					$B3Pos[0] = 0
					$B4Pos[0] = 0
					ExitLoop
				EndIf
				Sleep(500)
			EndIf

			If $B2Pos[0] = 0 Then
				$ClickCheck = MsgBox(6 + 65536, "Locate second barrack", "Click Continue then click on you second barrack. Cancel if not available", 0, $BotGUI)
				If $ClickCheck = 11 Then
					WinActivate($HWnD)
					FindPos($B2Pos)
				ElseIf $ClickCheck = 10 Then
					$B1Pos[0] = 0
					$B2Pos[0] = 0
					$B3Pos[0] = 0
					$B4Pos[0] = 0
					ExitLoop
				EndIf
				Sleep(500)
			EndIf

			If $B3Pos[0] = 0 Then
				$ClickCheck = MsgBox(6 + 65536, "Locate third barrack", "Click Continue then click on your third barrack. Cancel if not available", 0, $BotGUI)
				If $ClickCheck = 11 Then
					WinActivate($HWnD)
					FindPos($B3Pos)
				ElseIf $ClickCheck = 10 Then
					$B1Pos[0] = 0
					$B2Pos[0] = 0
					$B3Pos[0] = 0
					$B4Pos[0] = 0
					ExitLoop
				EndIf
				Sleep(500)
			EndIf

			If $B4Pos[0] = 0 Then
				$ClickCheck = MsgBox(6 + 65536, "Locate fourth barrack", "Click Continue then click on your fourth barrack. Cancel if not available", 0, $BotGUI)
				If $ClickCheck = 11 Then
					WinActivate($HWnD)
					FindPos($B4Pos)
				ElseIf $ClickCheck = 10 Then
					$B1Pos[0] = 0
					$B2Pos[0] = 0
					$B3Pos[0] = 0
					$B4Pos[0] = 0
					ExitLoop
				EndIf
				Sleep(500)
			EndIf
			ExitLoop (2)
		WEnd
	WEnd
EndFunc   ;==>LocateBarrack

Func TrainBarrack($x, $y, $z)
	ControlClick($HWnD, "", "", "left", "1", $x, $y)
	Sleep(1000)
	ControlClick($HWnD, "", "", "left", "1", 560 * $x_ratio, 490 * $y_ratio)
	Sleep(1000)
	Select
		Case $z = "Barbarian"
			For $i = 1 To 65 Step 1
				ControlClick($HWnD, "", "", "left", "1", 220 * $x_ratio, 270 * $y_ratio)
				Sleep(50)
			Next
		Case $z = "Archer"
			For $i = 1 To 65 Step 1
				ControlClick($HWnD, "", "", "left", "1", 310 * $x_ratio, 270 * $y_ratio)
				Sleep(50)
			Next
		Case $z = "Goblin"
			For $i = 1 To 65 Step 1
				ControlClick($HWnD, "", "", "left", "1", 490 * $x_ratio, 270 * $y_ratio)
				Sleep(50)
			Next
		Case $z = "Giant"
			For $i = 1 To 15 Step 1
				ControlClick($HWnD, "", "", "left", "1", 400 * $x_ratio, 270 * $y_ratio)
				Sleep(50)
			Next
	EndSelect
	Sleep(1000)
	ControlClick($HWnD, "", "", "left", "1", 656 * $x_ratio, 113 * $y_ratio)
	Sleep(1000)
EndFunc   ;==>TrainBarrack

Func Train()
	If $B1Pos[0] <> 0 Then
		TrainBarrack($B1Pos[0], $B1Pos[1], $B1Troop)
	EndIf
	If $B2Pos[0] <> 0 Then
		TrainBarrack($B2Pos[0], $B2Pos[1], $B2Troop)
	EndIf
	If $B3Pos[0] <> 0 Then
		TrainBarrack($B3Pos[0], $B3Pos[1], $B3Troop)
	EndIf
	If $B4Pos[0] <> 0 Then
		TrainBarrack($B4Pos[0], $B4Pos[1], $B4Troop)
	EndIf
EndFunc   ;==>Train

#EndRegion ##### TRAIN #####

#Region ##### ATTACK #####
Func PrepareAttack()
	;TrayTip ("Attack mode started!","Minimum Gold: " & $MinGold & ". Minimum Elixir: " & $MinElixir & ". Search Mode: " & $SearchMode, 0, $TIP_ICONASTERISK)
	ControlClick($HWnD, "", "", "left", "1", 50 * $x_ratio, 500 * $y_ratio) ;Click Attack
	Sleep(2000)
	ControlClick($HWnD, "", "", "left", "1", 190 * $x_ratio, 420 * $y_ratio) ;Click Find a Match
	Sleep(2000)
	ControlClick($HWnD, "", "", "left", "1", 470 * $x_ratio, 330 * $y_ratio) ;Click Break Shield
EndFunc   ;==>PrepareAttack

Func CheckScreen()
	Local $Check = ""
	$i = 0
	While $Check = "" And $ErrorCheck = 0
		$Check = _TesseractWinCapture($HWnD, "", 0, "", 1, 2, $Left * $x_ratio, $Top * $y_ratio, $Right * $x_ratio, $Bottom * $y_ratio, 0)
		$Check = StringStripWS($Check, 8)
		Sleep(200)
		$i += 1
		If $i > 150 Then
			$ErrorCheck = 1
			Exit
		EndIf
	WEnd
EndFunc   ;==>CheckScreen

Func VillageSearch()
	CheckScreen()
	ReadValue()
	CompareValue()
	While $SearchCheck = 0 And $ErrorCheck = 0
		ControlClick($HWnD, "", "", "left", "1", 715 * $x_ratio, 405 * $y_ratio) ;Click Next
		CheckScreen()
		ReadValue()
		CompareValue()
	WEnd
	If $ErrorCheck = 1 Then
		Restart()
		PrepareAttack()
	Else
		TrayTip("Enemy Found!", "Requirement met:  Gold: " & $Gold & ". Elixir: " & $Elixir, 0, $TIP_ICONASTERISK)
		Sleep(20000)
	EndIf
EndFunc   ;==>VillageSearch

Func CheckTroop($a)
	If $B1Troop = $a Or $B2Troop = $a Or $B3Troop = $a Or $B4Troop = $a Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>CheckTroop

Func AssignTroop()
	If CheckTroop("Barbarian") Then
		$Barbarian[0] = $Troop[0][0]
		#Barbarian[1] = $Troop[0][1]
		If CheckTroop("Archer") Then
			$Archer[0] = $Troop[1][0]
			$Archer[1] = $Troop[1][1]
			If CheckTroop("Goblin") Then
				$Goblin[0] = $Troop[2][0]
				$Goblin[1] = $Troop[2][1]
				If CheckTroop("Giant") Then
					$Giant[0] = $Troop[3][0]
					$Giant[1] = $Troop[3][1]
				EndIf
			ElseIf CheckTroop("Giant") Then
				$Giant[0] = $Troop[2][0]
				$Giant[1] = $Troop[2][1]
			EndIf
		ElseIf CheckTroop("Goblin") Then
			$Goblin[0] = $Troop[1][0]
			$Goblin[1] = $Troop[1][1]
			If CheckTroop("Giant") Then
				$Giant[0] = $Troop[2][0]
				$Giant[1] = $Troop[2][1]
			EndIf
		ElseIf CheckTroop("Giant") Then
			$Giant[0] = $Troop[1][0]
			$Giant[1] = $Troop[1][1]
		EndIf
	ElseIf CheckTroop("Archer") Then
		$Archer[0] = $Troop[0][0]
		$Archer[1] = $Troop[0][1]
		If CheckTroop("Goblin") Then
			$Goblin[0] = $Troop[1][0]
			$Goblin[1] = $Troop[1][1]
			If CheckTroop("Giant") Then
				$Giant[0] = $Troop[2][0]
				$Giant[1] = $Troop[2][1]
			EndIf
		ElseIf CheckTroop("Giant") Then
			$Giant[0] = $Troop[1][0]
			$Giant[1] = $Troop[1][1]
		EndIf
	ElseIf CheckTroop("Goblin") Then
		$Goblin[0] = $Troop[0][0]
		$Goblin[1] = $Troop[0][1]
		If CheckTroop("Giant") Then
			$Giant[0] = $Troop[1][0]
			$Giant[1] = $Troop[1][1]
		EndIf
	ElseIf CheckTroop("Giant") Then
		$Giant[0] = $Troop[0][0]
		$Giant[1] = $Troop[0][1]
	EndIf
EndFunc   ;==>AssignTroop

Func DropAll()
	ControlClick($HWnD, "", "", "left", "1", $Troop[2][0], $Troop[2][1])
	Sleep(500)
	For $i = 0 To 4 Step 1
		ControlClick($HWnD, "", "", "left", "1", $UpLeft[$i][0], $UpLeft[$i][1])
		Sleep(100)
	Next
	Sleep(500)
	ControlClick($HWnD, "", "", "left", "1", $Troop[0][0], $Troop[0][1])
	Sleep(300)
	For $x = 0 To 15 Step 1
		For $i = 0 To 4 Step 1
			ControlClick($HWnD, "", "", "left", "1", $UpLeft[$i][0], $UpLeft[$i][1])
			Sleep(100)
		Next
		Sleep(300)
	Next
	Sleep(500)
	ControlClick($HWnD, "", "", "left", "1", $Troop[1][0], $Troop[1][1])
	Sleep(300)
	For $x = 0 To 8 Step 1
		For $i = 0 To 4 Step 1
			ControlClick($HWnD, "", "", "left", "1", $UpLeft[$i][0], $UpLeft[$i][1])
			Sleep(100)
		Next
		Sleep(300)
	Next
	Sleep(500)
	ControlClick($HWnD, "", "", "left", "1", $Troop[2][0], $Troop[2][1])
	Sleep(500)
	For $i = 0 To 4 Step 1
		ControlClick($HWnD, "", "", "left", "1", $UpRight[$i][0], $UpRight[$i][1])
		Sleep(100)
	Next
	Sleep(500)
	ControlClick($HWnD, "", "", "left", "1", $Troop[0][0], $Troop[0][1])
	Sleep(300)
	For $x = 0 To 15 Step 1
		For $i = 0 To 4 Step 1
			ControlClick($HWnD, "", "", "left", "1", $UpRight[$i][0], $UpRight[$i][1])
			Sleep(100)
		Next
		Sleep(300)
	Next
	Sleep(500)
	ControlClick($HWnD, "", "", "left", "1", $Troop[1][0], $Troop[1][1])
	Sleep(300)
	For $x = 0 To 8 Step 1
		For $i = 0 To 4 Step 1
			ControlClick($HWnD, "", "", "left", "1", $UpRight[$i][0], $UpRight[$i][1])
			Sleep(100)
		Next
		Sleep(300)
	Next
	Sleep(500)
EndFunc   ;==>DropAll

Func DropTroop()
	DropCombo($UpLeft)
	DropCombo($UpRight)
EndFunc   ;==>DropTroop

Func DropCombo($Wing)
	If CheckTroop("Giant") Then
		ControlClick($HWnD, "", "", "left", "1", $Giant[0], $Giant[1])
		Sleep(300)
		For $i = 1 To 3 Step 1
			ControlClick($HWnD, "", "", "left", "1", $Wing[$i][0], $Wing[$i][1])
			Sleep(100)
		Next
		Sleep(300)
	EndIf
	If CheckTroop("Barbarian") Then
		ControlClick($HWnD, "", "", "left", "1", $Barbarian[0], $Barbarian[1])
		Sleep(300)
		For $x = 0 To 2 Step 1
			For $i = 0 To 4 Step 1
				ControlClick($HWnD, "", "", "left", "1", $Wing[$i][0], $Wing[$i][1])
				Sleep(100)
			Next
		Next
		Sleep(300)
	EndIf
	If CheckTroop("Archer") Then
		ControlClick($HWnD, "", "", "left", "1", $Archer[0], $Archer[1])
		Sleep(300)
		For $x = 0 To 2 Step 1
			For $i = 0 To 4 Step 1
				ControlClick($HWnD, "", "", "left", "1", $Wing[$i][0], $Wing[$i][1])
				Sleep(100)
			Next
		Next
		Sleep(300)
	EndIf
	If CheckTroop("Goblin") Then
		ControlClick($HWnD, "", "", "left", "1", $Goblin[0], $Goblin[1])
		Sleep(300)
		For $x = 0 To 2 Step 1
			For $i = 0 To 4 Step 1
				ControlClick($HWnD, "", "", "left", "1", $Wing[$i][0], $Wing[$i][1])
				Sleep(100)
			Next
		Next
		Sleep(30)
	EndIf
EndFunc   ;==>DropCombo

Func ReadValue()
	$Read = _TesseractWinCapture($HWnD, "", 0, "", 1, 2, $Left * $x_ratio, $Top * $y_ratio, $Right * $x_ratio, $Bottom * $y_ratio, 0) ;Capture screen region with gold and elixir
	;MsgBox(0,"Read",$Read)
	$Read = StringRegExpReplace(StringRegExpReplace($Read, "(\v)+", @CRLF), "\A\v|\v\Z", "")
	;MsgBox(0,"Read",$Read)
	$Read = StringSplit($Read, @CRLF, 1) ;Strip whitespaces & blank lines and split into array
	;MsgBox(0,"Read",$Read[2] & @CR & $Read[3])
	$Gold = Number(StringRegExpReplace($Read[2], "[^[:digit:]]", "")) ;Convert gold to number
	$Elixir = Number(StringRegExpReplace($Read[3], "[^[:digit:]]", "")) ;Convert exlir to number
	;$Dark = Number(StringStripWS($Read[4], $STR_STRIPALL))
	;MsgBox(0,"Result", "Gold: " & $Gold & @CR & "Elixir: " & $Elixir & @CR & "Dark: " & $Dark)
	;TrayTip ("Current Search","Gold: " & $Gold & ". Elixir: " & $Elixir, 0, $TIP_ICONASTERISK)
	;SplashTextOn("Current Search","Gold: " & $Gold & @CR & "Elixir: " & $Elixir,200,70)

EndFunc   ;==>ReadValue

Func CompareValue()
	If $Gold >= $MinGold Then
		If $Elixir >= $MinElixir Then
			;MsgBox(0, "Gold & Elixir Check", "Gold: " & $Gold & @CR & "Elixir: " & $Elixir & @CR & "Requirement met.")
			Select
				Case $SearchMode = 1
					$SearchCheck = 1
				Case $SearchMode = 2
					$SearchCheck = 1
				Case Else
					$SearchCheck = 0
			EndSelect
		Else
			;MsgBox(0, "Gold & Elixir Check", "Gold: " & $Gold & @CR & "Elixir: " & $Elixir & @CR &  "Not enough " & $MinElixir & " Elixir.")
			Select
				Case $SearchMode = 1
					$SearchCheck = 1
				Case $SearchMode = 2
					$SearchCheck = 0
				Case Else
					$SearchCheck = 0
			EndSelect
		EndIf
	Else
		If $Elixir >= $MinElixir Then
			;MsgBox(0, "Gold & Elixir Check", "Gold: " & $Gold & @CR & "Elixir: " & $Elixir & @CR & "Not enough " & $MinGold & " Gold.")
			Select
				Case $SearchMode = 1
					$SearchCheck = 1
				Case $SearchMode = 2
					$SearchCheck = 0
				Case Else
					$SearchCheck = 0
			EndSelect
		Else
			;MsgBox(0, "Gold & Elixir Check", "Gold: " & $Gold & @CR & "Elixir: " & $Elixir & @CR & "Not enough " & $MinGold & " Gold and " & $MinElixir & " Elixir." )
			Select
				Case $SearchMode = 1
					$SearchCheck = 0
				Case $SearchMode = 2
					$SearchCheck = 0
				Case Else
					$SearchCheck = 0
			EndSelect
		EndIf
	EndIf
EndFunc   ;==>CompareValue
#EndRegion ##### ATTACK #####

Func Initiate()
	ControlClick($HWnD, "", "", "left", "1", 290, 150) ;Click BlueStacks
	Sleep(60000)
	ZoomOut()
	Sleep(10000)
EndFunc   ;==>Initiate

Func ZoomOut()
	For $i = 1 To 20 Step 1
		ControlSend($HWnD, "", "", "{DOWN}", 0)
		Sleep(500)
	Next
EndFunc   ;==>ZoomOut

Func Restart()
	ControlClick($HWnD, "", "", "left", "1", 125, 575)
	Sleep(2000)
	ControlClick($HWnD, "", "", "left", "1", 125, 577)
	Sleep(2000)
	ControlClick($HWnD, "", "", "left", "1", 205, 575)
	Sleep(2000)
	MouseClickDrag("left", 700, 300, 700, 120)
	Sleep(2000)
	ControlClick($HWnD, "", "", "left", "1", 290, 160)
	Sleep(50000)
EndFunc   ;==>Restart

Func Pause()
	$Paused = Not $Paused
	While $Paused
		Sleep(100)
		TrayTip("Script Paused", "Press Space to Unpause", 0, $TIP_ICONASTERISK)
	WEnd
EndFunc   ;==>Pause

Func Terminate()
	Exit
EndFunc   ;==>Terminate
