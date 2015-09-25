DirCreate(@ScriptDir & "\Loots\")

If WinExists("Clash of Clans Bot") Then
   MsgBox(0,"","Bot's already running.")
   Exit
EndIf
If Not WinExists("BlueStacks App Player") Then
   MsgBox(0,"BlueStacks is not running", "Please open BlueStacks and CoC first before running.")
   Exit
EndIf

#RequireAdmin
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <TrayConstants.au3>
#include <Misc.au3>
#include "GkevinOD 003.au3"
#include "AtoZZombieSearch.au3"

Opt ("GUIOnEventMode", 1)
Opt ("MouseClickDelay", 10)
Opt ("MouseClickDownDelay", 10)
Opt ("MouseCoordMode", 0)
Opt ('PixelCoordMode', 0)

GUIRegisterMsg($WM_COMMAND, "GUIControl")
GUIRegisterMsg($WM_SYSCOMMAND, "GUIControl")

Global $Title = "BlueStacks App Player"
Global $HWnD = WinGetHandle (WinGetTitle($Title))
WinActivate ($HWnD)

Global $x_default
Global $y_default

getBlueStacksPos()

Global $RunState = False, $KeepAlive = False, $FullArmy = False, $ZombieMode
Global $Gold, $Elixir, $Dark, $Trophy, $MinGold = 80000, $MinElixir = 80000, $MinDark = 0, $MinTrophy = 0, $SearchMode = 1, $SearchCheck = 0, $Zcount = 0

Global $Config = @ScriptDir & "\config.ini"
Global $BSsize = WinGetClientSize($hWnd)
Global $x_ratio = $BSsize[0]/800, $y_ratio = $BSsize[1]/600
Global $Troop[5][2] = [[60*$x_ratio,505*$y_ratio],[130*$x_ratio,505*$y_ratio],[200*$x_ratio,505*$y_ratio],[265*$x_ratio,505*$y_ratio],[372*$x_ratio,505*$y_ratio]]
Global $Barbarian[2] = [0,0], $Archer[2] = [0,0], $Goblin[2] =[0,0], $Giant[2] = [0,0]
Global $B1Pos[2] = [0,0], $B2Pos[2] = [0,0], $B3Pos[2] = [0,0], $B4Pos[2] = [0,0]
Global $B1Troop, $B2Troop, $B3Troop, $B4Troop

Global $UpLeft[5][2] = [[350*$x_ratio,51*$y_ratio],[230*$x_ratio,100*$y_ratio],[186*$x_ratio,160*$y_ratio],[144*$x_ratio,187*$y_ratio],[125*$x_ratio,200*$y_ratio]]
Global $UpRight[5][2] = [[460*$x_ratio,62*$y_ratio],[520*$x_ratio,97*$y_ratio],[570*$x_ratio,134*$y_ratio],[647*$x_ratio,186*$y_ratio],[692*$x_ratio,211*$y_ratio]]
Global $LowLeft[5][2] = [[77*$x_ratio, 306*$y_ratio],[130*$x_ratio,353*$y_ratio],[181*$x_ratio,395*$y_ratio],[214*$x_ratio,415*$y_ratio],[250*$x_ratio,442*$y_ratio]]
Global $LowRight[5][2] = [[734*$x_ratio,290*$y_ratio],[685*$x_ratio,318*$y_ratio],[630*$x_ratio,350*$y_ratio],[600*$x_ratio,369*$y_ratio],[535*$x_ratio,425*$y_ratio]]



#Region ##### GUI #####
$BotGUI = GUICreate("Clash of Clans Bot", 330, 510)
GUICtrlSetFont(-1, 10, 800, 0, "Calibri")
GUISetOnEvent($GUI_EVENT_CLOSE, "Terminate")
$Button = GUICtrlCreateButton("START", 10, 460, 310, 40)
GUICtrlSetOnEvent(-1, "Start")
$LBButton = GUICtrlCreateButton("Locate Barrack", 10, 390, 99, 30)
GUICtrlSetOnEvent(-1, "LB")
$TrButton = GUICtrlCreateButton("Train", 116, 390, 99, 30)
GUICtrlSetOnEvent(-1, "Tr")
$AtkButton = GUICtrlCreateButton("Attack", 222, 390, 99, 30)
GUICtrlSetOnEvent(-1, "Atk")
$VSButton = GUICtrlCreateButton("Village Search", 10, 425, 151, 30)
GUICtrlSetOnEvent(-1, "SearchFunction")
$DTButton = GUICtrlCreateButton("Drop Troop", 169, 425, 151, 30)
GUICtrlSetOnEvent(-1, "DrpTrp")
;$KAButton = GUICtrlCreateButton("Keep Alive: OFF", 30, 110, 100, 20)
;GUICtrlSetOnEvent(-1, "KeepAlive")
;$SearchOption = GUICtrlCreateCombo("G.E", 45, 10, 70, 17, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
;GUICtrlSetData(-1, "G/E|G.E.D|G.E.D.T")
GUIStartGroup()
$s1 = GUICtrlCreateRadio("G + E", 15, 7)
$s2 = GUICtrlCreateRadio("G / E", 15, 25)
$s3 = GUICtrlCreateRadio("D", 70, 7)
$s4 = GUICtrlCreateRadio("T", 70, 25)
$s5 = GUICtrlCreateRadio("G E D", 105, 7)
$s6 = GUICtrlCreateRadio("GE / D", 105, 25)
GUICtrlSetState($s1, $GUI_CHECKED)
GUIStartGroup()
$a1 = GUICtrlCreateRadio("2 Sides", 173, 7)
$a2 = GUICtrlCreateRadio("4 Sides", 246, 7)
GUICtrlSetState($a1, $GUI_CHECKED)
$ZMod = GUICtrlCreateCheckbox("Zombie Mode", 173, 27, 140, 17)
;$MeetAll = GUICtrlCreateCheckbox("Meet all conditions", 25, 15, 140, 17)
;GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateLabel("(G)", 15, 51, 15, 17)
$MinGoldInput = GUICtrlCreateInput("", 32, 49, 45, 21, $ES_NUMBER)
GUICtrlSetLimit(-1, 6)
GUICtrlSetData(-1, $MinGold)
GUICtrlCreateLabel("(E)", 15, 76, 15, 17)
$MinElixirInput = GUICtrlCreateInput("", 32, 73, 45, 21, $ES_NUMBER)
GUICtrlSetLimit(-1, 6)
GUICtrlSetData(-1, $MinElixir)
GUICtrlCreateLabel("(D)", 85, 51, 15, 17)
$MinDarkInput = GUICtrlCreateInput("", 102, 49, 45, 21, $ES_NUMBER)
GUICtrlSetLimit(-1, 4)
GUICtrlSetData(-1, $MinDark)
GUICtrlCreateLabel("(T)", 85, 76, 15, 17)
$MinTrophyInput = GUICtrlCreateInput("", 102, 73, 45, 21, $ES_NUMBER)
GUICtrlSetLimit(-1, 2)
GUICtrlSetData(-1, $MinTrophy)
$Barrack01 = GUICtrlCreateCombo("Barrack 01", 170, 49, 70, 30, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarian|Archer|Goblin|Giant")
_GUICtrlComboBox_SelectString(-1, "Archer")
$Barrack02 = GUICtrlCreateCombo("Barrack 02", 170, 73, 70, 30, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarian|Archer|Goblin|Giant")
_GUICtrlComboBox_SelectString(-1, "Archer")
$Barrack03 = GUICtrlCreateCombo("Barrack 03", 243, 49, 70, 30, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarian|Archer|Goblin|Giant")
_GUICtrlComboBox_SelectString(-1, "Barbarian")
$Barrack04 = GUICtrlCreateCombo("Barrack 04", 243, 73, 70, 30, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarian|Archer|Goblin|Giant")
_GUICtrlComboBox_SelectString(-1, "Barbarian")
$Results = GUICtrlCreateEdit("", 10, 108, 310, 272, BitOR($SS_SUNKEN,$ES_READONLY, $SS_LEFT))
;$Results = GUICtrlCreateList("", 20, 140, 260, 225, BitOR($SS_SUNKEN,$ES_READONLY, $SS_LEFT, $WS_VSCROLL))
GUISetState(@SW_SHOW)
WinSetOnTop($BotGUI,"",1)
#EndRegion ##### GUI #####

While 1
   $Msg = GUIGetMsg()
WEnd

Func getBlueStacksPos()
   $aPos = ControlGetPos("BlueStacks App Player", "", "[CLASS:BlueStacksApp; INSTANCE:1]")
   $tPoint = DllStructCreate("int X;int Y")
   DllStructSetData($tpoint, "X", $aPos[0])
   DllStructSetData($tpoint, "Y", $aPos[1])
   _WinAPI_ClientToScreen(WinGetHandle(WinGetTitle("BlueStacks App Player")), $tPoint)

   $x_default = DllStructGetData($tpoint, "X") + 51
   $y_default = DllStructGetData($tpoint, "Y") + 66
EndFunc

Func GUIControl($hWind, $iMsg, $wParam, $lParam)
   Local $nNotifyCode = BitShift($wParam, 16)
   Local $nID = BitAND($wParam, 0x0000FFFF)
   Local $hCtrl = $lParam
   #forceref $hWind, $iMsg, $wParam, $lParam
   Switch $iMsg
	  Case 273
		 Switch $nID
			Case $Button
			   ClearBox()
			   $RunState = Not $RunState
			   If $RunState = True Then
				  GUICtrlSetData($Button,"STOP")
				  GUICtrlSetData($Results, "Bot Started" & @CRLF, -1)
			   ElseIf $RunState = False Then
				  GUICtrlSetData($Button,"START")
				  GUICtrlSetData($Results, "Bot Stopped" & @CRLF, -1)
			   EndIf
			Case $LBButton
			   GUICtrlSetData($LBButton,"Locating...")
			   GUICtrlSetData($Results, "Bot Started" & @CRLF, -1)
			Case $TrButton
			   GUICtrlSetData($TrButton,"Training...")
			   GUICtrlSetData($Results, "Bot Started" & @CRLF, -1)
			Case $AtkButton
			   GUICtrlSetData($AtkButton,"Attacking...")
			   GUICtrlSetData($Results, "Bot Started" & @CRLF, -1)
			Case $VSButton
			   GUICtrlSetData($VSButton,"Searching...")
			   GUICtrlSetData($Results, "Bot Started" & @CRLF, -1)
			Case $DTButton
			   GUICtrlSetData($DTButton,"Dropping...")
			   ;GUICtrlSetData($Results, "Bot Started" & @CRLF, -1)
			#cs
			Case $KAButton
			   $KeepAlive = Not $KeepAlive
			   If $KeepAlive = True Then
				  GUICtrlSetData($KAButton,"Keep Alive: ON")
			   ElseIf $KeepAlive = False Then
				  GUICtrlSetData($KAButton,"Keep Alive: OFF")
			   EndIf
			#ce
		 EndSwitch
	  Case 274
		 Switch $wParam
			Case 0xf060
			   Exit
		 EndSwitch
   EndSwitch
   Return $GUI_RUNDEFMSG
EndFunc

Func Start()
   $HWnD = WinGetHandle (WinGetTitle($Title))
   WinActivate ($HWnD)
   If ControlGetPos("BlueStacks App Player", "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")[2] <> 860 Or ControlGetPos("BlueStacks App Player", "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")[3] <> 720 Then
	  GUICtrlSetData($Results, "BlueStacks is not set to 860x720!" & @CRLF & "Download the '860x720.reg' file and run it, restart BlueStacks" & @CRLF & "Download here: http://ge.tt/6Twq4O72" & @CRLF, -1)
	  $RunState = False
	  GUICtrlSetData($Button,"START")
	  GUICtrlSetData($Results, "Bot Stopped" & @CRLF, -1)
   EndIf
   While 1
	  If $RunState = False Then ExitLoop
	  MainScreen()	;Check if main screen
	  If $RunState = False Then ExitLoop
	  GetInput()	;Read user's input
	  If $RunState = False Then ExitLoop
	  ZoomOut()
	  If $RunState = False Then ExitLoop
	  LocateBarrack()	;If barrack not located, ask user to manually click on barrack to locate position
	  If $RunState = False Then ExitLoop
	  Train()			;Locate Barrack, Train Barrack
	  If $RunState = False Then ExitLoop
	  ClearBox()
	  While Not $FullArmy
		 Idle()
	  WEnd
	  If $RunState = False Then ExitLoop
	  Attack()			;Prepare Attack, Read Value, Compute Value, Compare Value, Search Village, Drop Troop, Return Home
   WEnd
EndFunc

Func GetInput()
   $B1Troop = GUICtrlRead($Barrack01)
   $B2Troop = GUICtrlRead($Barrack02)
   $B3Troop = GUICtrlRead($Barrack03)
   $B4Troop = GUICtrlRead($Barrack04)
   $MinGold = Number(GUICtrlRead($MinGoldInput))
   $MinElixir = Number(GUICtrlRead($MinElixirInput))
   $MinDark = Number(GUICtrlRead($MinDarkInput))
   $MinTrophy = Number(GUICtrlRead($MinTrophyInput))
   ;If GUICtrlRead($MeetAll) = $GUI_CHECKED Then
	;  $SearchMode = 2
   ;Else
	;  $SearchMode = 1
   ;EndIf
   If GUICtrlRead($s1) = $GUI_CHECKED Then
	  $SearchMode = 1
   ElseIf GUICtrlRead($s2) = $GUI_CHECKED Then
	  $SearchMode = 2
   ElseIf GUICtrlRead($s3) = $GUI_CHECKED Then
	  $SearchMode = 3
   ElseIf GUICtrlRead($s4) = $GUI_CHECKED Then
	  $SearchMode = 4
   ElseIf GUICtrlRead($s5) = $GUI_CHECKED Then
	  $SearchMode = 5
   ElseIf GUICtrlRead($s6) = $GUI_CHECKED Then
	  $SearchMode = 6
   EndIf
   If GUICtrlRead($ZMod) = $GUI_CHECKED Then
	  $ZombieMode = 1
   Else
	  $ZombieMode = 0
   EndIf
   $B1Pos[0] = IniRead($Config, "Barrack 01", "X", "0")
   $B1Pos[1] = IniRead($Config, "Barrack 01", "Y", "0")
   $B2Pos[0] = IniRead($Config, "Barrack 02", "X", "0")
   $B2Pos[1] = IniRead($Config, "Barrack 02", "Y", "0")
   $B3Pos[0] = IniRead($Config, "Barrack 03", "X", "0")
   $B3Pos[1] = IniRead($Config, "Barrack 03", "Y", "0")
   $B4Pos[0] = IniRead($Config, "Barrack 04", "X", "0")
   $B4Pos[1] = IniRead($Config, "Barrack 04", "Y", "0")
   If $B1Pos[0] <> 0 Or $B2Pos[0] <> 0 Or $B3Pos[0] <> 0 Or $B4Pos[0] <> 0 Then GUICtrlSetData($Results, "Barracks' Positions: " & @CRLF, -1)
   If $B1Pos[0] <> 0 Then GUICtrlSetData($Results, "[1]: " & $B1Pos[0] & ", " & $B1Pos[1] & @CRLF, -1)
   If $B2Pos[0] <> 0 Then GUICtrlSetData($Results, "[2]: " & $B2Pos[0] & ", " & $B2Pos[1] & @CRLF, -1)
   If $B3Pos[0] <> 0 Then GUICtrlSetData($Results, "[3]: " & $B3Pos[0] & ", " & $B3Pos[1] & @CRLF, -1)
   If $B4Pos[0] <> 0 Then GUICtrlSetData($Results, "[4]: " & $B4Pos[0] & ", " & $B4Pos[1] & @CRLF, -1)
EndFunc

#Region ##### TRAIN #####
Func LocateBarrack()
   Local $ClickCheck, $LocateCheck = 0
   While 1
	  While 1
		 If $RunState = False Then ExitLoop(2)
		 If $B1Pos[0] = 0  And $B1Troop <> "Barrack 01" Then
			$ClickCheck = MsgBox(6+262144, "Locate first barrack", "Click Continue then click on your first barrack. Cancel if not available. Try again to start over.", 0, $BotGUI)
			If $ClickCheck = 11 Then
			   WinActivate ($HWnD)
			   FindPos($B1Pos)
			   IniWrite ($Config, "Barrack 01", "X", $B1Pos[0])
			   IniWrite ($Config, "Barrack 01", "Y", $B1Pos[1])
			ElseIf $ClickCheck = 10 Then
			   $B1Pos[0] = 0
			   $B2Pos[0] = 0
			   $B3Pos[0] = 0
			   $B4Pos[0] = 0
			   ExitLoop
			EndIf
			Sleep(500)
		 EndIf
		 If $RunState = False Then ExitLoop (2)
		 If $B2Pos[0] = 0 And $B2Troop <> "Barrack 02"  Then
			$ClickCheck = MsgBox(6+262144, "Locate second barrack", "Click Continue then click on you second barrack. Cancel if not available. Try again to start over.", 0, $BotGUI)
			If $ClickCheck = 11 Then
			   WinActivate ($HWnD)
			   FindPos($B2Pos)
			   IniWrite ($Config, "Barrack 02", "X", $B2Pos[0])
			   IniWrite ($Config, "Barrack 02", "Y", $B2Pos[1])
			ElseIf $ClickCheck = 10 Then
			   $B1Pos[0] = 0
			   $B2Pos[0] = 0
			   $B3Pos[0] = 0
			   $B4Pos[0] = 0
			   ExitLoop
			EndIf
			Sleep(500)
		 EndIf
		 If $RunState = False Then ExitLoop(2)
		 If $B3Pos[0] = 0 And $B3Troop <> "Barrack 03" Then
			$ClickCheck = MsgBox(6+262144, "Locate third barrack", "Click Continue then click on your third barrack. Cancel if not available. Try again to start over.", 0, $BotGUI)
			If $ClickCheck = 11 Then
			   WinActivate ($HWnD)
			   FindPos($B3Pos)
			   IniWrite ($Config, "Barrack 03", "X", $B3Pos[0])
			   IniWrite ($Config, "Barrack 03", "Y", $B3Pos[1])
			ElseIf $ClickCheck = 10 Then
			   $B1Pos[0] = 0
			   $B2Pos[0] = 0
			   $B3Pos[0] = 0
			   $B4Pos[0] = 0
			   ExitLoop
			EndIf
			Sleep(500)
		 EndIf
		 If $RunState = False Then ExitLoop(2)
		 If $B4Pos[0] = 0  And $B4Troop <> "Barrack 04" Then
			$ClickCheck = MsgBox(6+262144, "Locate fourth barrack", "Click Continue then click on your fourth barrack. Cancel if not available. Try again to start over.", 0, $BotGUI)
			If $ClickCheck = 11 Then
			   WinActivate ($HWnD)
			   FindPos($B4Pos)
			   IniWrite ($Config, "Barrack 04", "X", $B4Pos[0])
			   IniWrite ($Config, "Barrack 04", "Y", $B4Pos[1])
			ElseIf $ClickCheck = 10 Then
			   $B1Pos[0] = 0
			   $B2Pos[0] = 0
			   $B3Pos[0] = 0
			   $B4Pos[0] = 0
			   ExitLoop
			EndIf
			Sleep(500)
		 EndIf
		 ExitLoop(2)
	  WEnd
   WEnd
EndFunc

Func TrainBarrack($x, $y, $z)
   While 1
	  If $RunState = False Then ExitLoop
	  ControlClick ($HWnD, "","", "left", "1", 717, 494)
	  Sleep(500)
	  If $RunState = False Then ExitLoop
	  ControlClick ($HWnD, "","", "left", "1", $x, $y)
	  Sleep(1000)
	  If $RunState = False Then ExitLoop
	  $TrainTroop = PixelSearch(230,579,716,672,0x9F7328,5,1,$HWnD)
	  If IsArray($TrainTroop) Then
		 ;GUICtrlSetData($Results,"Found Train Button" & @CRLF, -1)
		 ControlClick ($HWnD, "","", "left", "1", $TrainTroop[0], $Traintroop[1]) ; Click Barrack
	  Else
		 ControlClick ($HWnD, "","", "left", "1", 600, 620) ; Click Train Troops (original function)
	  EndIf
	  Sleep(1000)
	  If $RunState = False Then ExitLoop
	  $Pixel = _ColorCheckVariation(Hex(PixelGetColor(377, 546, $HWnD),6), Hex(0xD03838,6),20)
	  If $Pixel = True Then
		 $FullArmy = True
	  EndIf
	  Select
	  Case $z = "Barbarian"
		 $Pixel = _ColorCheckVariation(Hex(PixelGetColor(259, 342, $HWnD), 6), Hex(0x48B0C8, 6), 60)
		 While $Pixel
			ControlClick ($HWnD, "","", "left", "1", 220*$x_ratio, 270*$y_ratio)
			$Pixel = _ColorCheckVariation(Hex(PixelGetColor(259, 342, $HWnD), 6), Hex(0x48B0C8, 6), 60)
			If $RunState = False Then ExitLoop
			Sleep(50)
		 WEnd
	  Case $z = "Archer"
		 $Pixel = _ColorCheckVariation(Hex(PixelGetColor(363, 350, $HWnD), 6), Hex(0x3AA1C0, 6), 60)
		 While $Pixel
			ControlClick ($HWnD, "","", "left", "1", 310*$x_ratio, 270*$y_ratio)
			$Pixel = _ColorCheckVariation(Hex(PixelGetColor(363, 350, $HWnD), 6), Hex(0x3AA1C0, 6), 60)
			If $RunState = False Then ExitLoop
			Sleep(50)
		 WEnd
	  Case $z = "Goblin"
		 $Pixel = _ColorCheckVariation(Hex(PixelGetColor(569, 347, $HWnD), 6), Hex(0x8CA342, 6), 60)
		 While $Pixel
			ControlClick ($HWnD, "","", "left", "1", 490*$x_ratio, 270*$y_ratio)
			$Pixel = _ColorCheckVariation(Hex(PixelGetColor(569, 347, $HWnD), 6), Hex(0x8CA342, 6), 60)
			If $RunState = False Then ExitLoop
			Sleep(50)
		 WEnd
	  Case $z = "Giant"
		 $Pixel = _ColorCheckVariation(Hex(PixelGetColor(271, 372, $HWnD), 6), Hex(0x989B8D, 6), 60)
		 While $Pixel
			ControlClick ($HWnD, "","", "left", "1", 400*$x_ratio, 270*$y_ratio
			$Pixel = _ColorCheckVariation(Hex(PixelGetColor(271, 372, $HWnD), 6), Hex(0x989B8D, 6), 60)
			If $RunState = False Then ExitLoop
			Sleep(50)
		 WEnd
	  EndSelect
	  If $RunState = False Then ExitLoop
	  Sleep(1000)
	  ControlClick ($HWnD, "","", "left", "1", 656*$x_ratio, 113*$y_ratio)
	  Sleep(1000)
	  ControlClick ($HWnD, "","", "left", "1", 717, 494)
	  Sleep(500)
	  ExitLoop
   WEnd
EndFunc

Func Train()
   While 1
	  If $RunState = False Then ExitLoop
	  GUICtrlSetData($Results,"Begin Training" & @CRLF, -1)
	  $FullArmy = False
	  If $RunState = False Then ExitLoop
	  If $B1Pos[0] <> 0 And $B1Troop <> "Barrack 01" Then
		 TrainBarrack($B1Pos[0],$B1Pos[1],$B1Troop)
	  EndIf
	  If $RunState = False Then ExitLoop
	  If $B2Pos[0] <> 0 And $B2Troop <> "Barrack 02" Then
		 TrainBarrack($B2Pos[0],$B2Pos[1],$B2Troop)
	  EndIf
	  If $RunState = False Then ExitLoop
	  If $B3Pos[0] <> 0  And $B3Troop <> "Barrack 03" Then
		 TrainBarrack($B3Pos[0],$B3Pos[1],$B3Troop)
	  EndIf
	  If $RunState = False Then ExitLoop
	  If $B4Pos[0] <> 0  And $B4Troop <> "Barrack 04" Then
		 TrainBarrack($B4Pos[0],$B4Pos[1],$B4Troop)
	  EndIf
	  If $RunState = False Then ExitLoop
	  If $FullArmy Then
		 GUICtrlSetData($Results, "Army Full" & @CRLF, -1)
	  EndIf
	  GUICtrlSetData($Results, "Training Complete" & @CRLF, -1)
	  ExitLoop
   WEnd
EndFunc

#EndRegion ##### TRAIN #####

#Region ##### ATTACK #####
Func Attack()
   While 1
	  If $RunState = False Then ExitLoop
	  AssignTroop()
	  If $RunState = False Then ExitLoop
	  PrepareAttack()
	  If $RunState = False Then ExitLoop
	  GUICtrlSetData($Results, "Attack started. Begin searching.." & @CRLF, -1)
	  VillageSearch()
	  If $RunState = False Then ExitLoop
	  Sleep(5000)
	  DropTroop()
	  If $RunState = False Then ExitLoop
	  ReturnHome()
	  ExitLoop
   WEnd
EndFunc

Func PrepareAttack()
   While 1
	  If $RunState = False Then ExitLoop
	  ControlClick ($HWnD, "","", "left", "1", 50*$x_ratio, 500*$y_ratio) ;Click Attack
	  If $RunState = False Then ExitLoop
	  Sleep(2000)
	  ControlClick ($HWnD, "","", "left", "1", 190*$x_ratio, 420*$y_ratio) ;Click Find a Match
	  If $RunState = False Then ExitLoop
	  Sleep(1000)
	  If Not CheckScreenChange(0.25,0.25,0.75,0.75,500) Then
		 ControlClick ($HWnD, "","", "left", "1", 470*$x_ratio, 330*$y_ratio) ;Click Break Shield
	  EndIf
	  ExitLoop
   WEnd
EndFunc

Func CheckSearch()
   Sleep(1000)
   Local $i = 0
   While getGold($x_default, $y_default) = ""
	  getBlueStacksPos()
	  If $RunState = False Then ExitLoop
	  $i += 1
	  If $i >= 20 Then
		 $i = 0
		 If CheckScreenChange(0.25,0.25,0.75,0.75,500) Then
			ControlClick ($HWnD, "","", "left", "1", 715*$x_ratio, 405*$y_ratio) ;Click Next
		 Else
			ClearBox()
			GUICtrlSetData($Results, "Out of Sync Error. Restart" & @CRLF, -1)
			Start()
			$RunState = False
			ExitLoop
		 EndIf
	  EndIf
	  Sleep(500)
   WEnd
EndFunc

Func VillageSearch()
   $SearchCheck = 0 ;May fix 1st search atk bug
   While 1
	  Global $SearchCount = 0
	  If $RunState = False Then ExitLoop
	  CheckSearch()
	  If $RunState = False Then ExitLoop
	  ReadValue()
	  If $RunState = False Then ExitLoop
	  CompareValue()
	  If $RunState = False Then ExitLoop
	  If $SearchCheck = 1 And $ZombieMode = 1 Then
		 ZombieSearch($SearchCheck, 90)
		 ZombieSearch($SearchCheck, 100)
	  EndIf
	  While $SearchCheck = 0
		 If $RunState = False Then ExitLoop
		 ControlClick ($HWnD, "","", "left", "1", 715*$x_ratio, 405*$y_ratio) ;Click Next
		 If $RunState = False Then ExitLoop
		 CheckSearch()
		 If $RunState = False Then ExitLoop
		 ReadValue()
		 If $RunState = False Then ExitLoop
		 CompareValue()
		 If $RunState = False Then ExitLoop
		 If $SearchCheck = 1 And $ZombieMode = 1 Then
			ZombieSearch($SearchCheck, 90)
			ZombieSearch($SearchCheck, 100)
		 EndIf
		 If $RunState = False Then ExitLoop
	  WEnd
	  If $RunState = False Then ExitLoop
	  GUICtrlSetData($Results, "Enemy Found!" & @CRLF, -1)
	  Sleep(5000)
	  ExitLoop
   WEnd
EndFunc

Func CheckTroop($a)
   If $B1Troop = $a Or $B2Troop = $a Or $B3Troop = $a Or $B4Troop = $a Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func AssignTroop()
   If CheckTroop("Barbarian") Then
	  $Barbarian[0] = $Troop[0][0]
	  $Barbarian[1] = $Troop[0][1]
	  If CheckTroop("Archer") Then
		 $Archer[0] = $Troop[1][0]
		 $Archer[1] = $Troop[1][1]
		 If CheckTroop("Goblin") Then
			$Goblin[0] = $Troop[2][0]
			$Goblin[1] = $Troop[2][1]
			If CheckTroop("Giant") Then
			   $Giant[0] = $Troop[3][0]
			   $Giant[1] = $Troop[3][1]
			   ;MsgBox(0,"","Barbarian, Archer, Goblin, Giant")
			EndIf
		 ElseIf CheckTroop("Giant") Then
			$Giant[0] = $Troop[2][0]
			$Giant[1] = $Troop[2][1]
			;MsgBox(0,"","Barbarian, Archer, Giant")
		 EndIf
	  ElseIf CheckTroop("Goblin") Then
		 $Goblin[0] = $Troop[1][0]
		 $Goblin[1] = $Troop[1][1]
		 If CheckTroop("Giant") Then
			$Giant[0] = $Troop[2][0]
			$Giant[1] = $Troop[2][1]
			;MsgBox(0,"","Barbarian, Goblin, Giant")
		 EndIf
	  ElseIf CheckTroop("Giant") Then
		 $Giant[0] = $Troop[1][0]
		 $Giant[1] = $Troop[1][1]
		 ;MsgBox(0,"","Barbarian, Giant")
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
			;MsgBox(0,"","Archer, Goblin, Giant")
		 EndIf
	  ElseIf CheckTroop("Giant") Then
		 $Giant[0] = $Troop[1][0]
		 $Giant[1] = $Troop[1][1]
		 ;MsgBox(0,"","Archer, Giant")
	  EndIf
   ElseIf CheckTroop("Goblin") Then
	  $Goblin[0] = $Troop[0][0]
	  $Goblin[1] = $Troop[0][1]
	  If CheckTroop("Giant") Then
		 $Giant[0] = $Troop[1][0]
		 $Giant[1] = $Troop[1][1]
		 ;MsgBox(0,"","Goblin, Giant")
	  EndIf
   ElseIf CheckTroop("Giant") Then
	  $Giant[0] = $Troop[0][0]
	  $Giant[1] = $Troop[0][1]
	  ;MsgBox(0,"","Giant")
   EndIf
EndFunc

Func DropTroop()
   While 1
	  GUICtrlSetData($Results, "Start to drop troops" & @CRLF, -1)
	  ; Up Left
	  If $RunState = False Then ExitLoop
	  DropSingle("Giant",$UpLeft)
	  If $RunState = False Then ExitLoop
	  DropSingle("Barbarian", $UpLeft)
	  If $RunState = False Then ExitLoop
	  DropSingle("Archer", $UpLeft)
	  If $RunState = False Then ExitLoop
	  DropSingle("Goblin", $UpLeft)
	  If $RunState = False Then ExitLoop
	  ; Up Right
	  DropSingle("Giant",$UpRight)
	  If $RunState = False Then ExitLoop
	  DropSingle("Barbarian", $UpRight)
	  If $RunState = False Then ExitLoop
	  DropSingle("Archer", $UpRight)
	  If $RunState = False Then ExitLoop
	  DropSingle("Goblin", $UpRight)
	  If $RunState = False Then ExitLoop
	  ; 4 Sides: Low Left & Low Right
	  If GUICtrlRead($a2) = $GUI_CHECKED Then
		 DropSingle("Giant",$LowLeft)
		 If $RunState = False Then ExitLoop
		 DropSingle("Barbarian", $LowLeft)
		 If $RunState = False Then ExitLoop
		 DropSingle("Archer", $LowLeft)
		 If $RunState = False Then ExitLoop
		 DropSingle("Goblin", $LowLeft)
		 If $RunState = False Then ExitLoop
		 DropSingle("Giant",$LowRight)
		 If $RunState = False Then ExitLoop
		 DropSingle("Barbarian", $LowRight)
		 If $RunState = False Then ExitLoop
		 DropSingle("Archer", $LowRight)
		 If $RunState = False Then ExitLoop
		 DropSingle("Goblin", $LowRight)
	  EndIf
	  ; Up Left
	  If $RunState = False Then ExitLoop
	  DropSingle("Giant",$UpLeft)
	  If $RunState = False Then ExitLoop
	  DropSingle("Barbarian", $UpLeft)
	  If $RunState = False Then ExitLoop
	  DropSingle("Archer", $UpLeft)
	  If $RunState = False Then ExitLoop
	  DropSingle("Goblin", $UpLeft)
	  If $RunState = False Then ExitLoop
	  ; Up Right
	  DropSingle("Giant",$UpRight)
	  If $RunState = False Then ExitLoop
	  DropSingle("Barbarian", $UpRight)
	  If $RunState = False Then ExitLoop
	  DropSingle("Archer", $UpRight)
	  If $RunState = False Then ExitLoop
	  DropSingle("Goblin", $UpRight)
	  If $RunState = False Then ExitLoop
	  ; 4 Sides: Low Left & Low Right
	  If GUICtrlRead($a2) = $GUI_CHECKED Then
		 DropSingle("Giant",$LowLeft)
		 If $RunState = False Then ExitLoop
		 DropSingle("Barbarian", $LowLeft)
		 If $RunState = False Then ExitLoop
		 DropSingle("Archer", $LowLeft)
		 If $RunState = False Then ExitLoop
		 DropSingle("Goblin", $LowLeft)
		 If $RunState = False Then ExitLoop
		 DropSingle("Giant",$LowRight)
		 If $RunState = False Then ExitLoop
		 DropSingle("Barbarian", $LowRight)
		 If $RunState = False Then ExitLoop
		 DropSingle("Archer", $LowRight)
		 If $RunState = False Then ExitLoop
		 DropSingle("Goblin", $LowRight)
	  EndIf
	  GUICtrlSetData($Results, "Finish dropping troops. Waiting for battle end." & @CRLF, -1)
	  ExitLoop
   WEnd
EndFunc

Func DropSingle($T, $W)
   While 1
	  If $RunState = False Then ExitLoop
	  If CheckTroop($T) Then
		 Select
		 Case $T = "Giant"
			ControlClick ($HWnD, "","", "left", "1", $Giant[0], $Giant[1])
			Sleep(300)
			For $i = 0 to 4 Step 1
			   ControlClick ($HWnD, "","", "left", "1", $W[$i][0], $W[$i][1])
			   Sleep(100)
			Next
			Sleep(3000)
		 If $RunState = False Then ExitLoop
		 Case $T = "Barbarian"
			ControlClick ($HWnD, "","", "left", "1", $Barbarian[0], $Barbarian[1])
			Sleep(300)
			For $x = 0 to 7 Step 1
			   For $i = 0 to 4 Step 1
				  ControlClick ($HWnD, "","", "left", "1", $W[$i][0], $W[$i][1])
				  Sleep(100)
			   Next
			Next
			Sleep(1000)
		 If $RunState = False Then ExitLoop
		 Case $T = "Archer"
			ControlClick ($HWnD, "","", "left", "1", $Archer[0], $Archer[1])
			Sleep(300)
			For $x = 0 to 7 Step 1
			   For $i = 0 to 4 Step 1
				  ControlClick ($HWnD, "","", "left", "1", $W[$i][0], $W[$i][1])
				  Sleep(100)
			   Next
			Next
			Sleep(1000)
		 If $RunState = False Then ExitLoop
		 Case $T = "Goblin"
			ControlClick ($HWnD, "","", "left", "1", $Goblin[0], $Goblin[1])
			Sleep(300)
			For $x = 0 to 7 Step 1
			   For $i = 0 to 4 Step 1
				  ControlClick ($HWnD, "","", "left", "1", $W[$i][0], $W[$i][1])
				  Sleep(100)
			   Next
			Next
			Sleep(300)
		 EndSelect
	  EndIf
	  ExitLoop
   WEnd
EndFunc

Func DropCombo($W)
   While 1
	  If $RunState = False Then ExitLoop
	  If CheckTroop("Giant") Then
		 ControlClick ($HWnD, "","", "left", "1", $Giant[0], $Giant[1])
		 Sleep(500)
		 For $i = 1 to 5 Step 1
			ControlClick ($HWnD, "","", "left", "1", $W[$i][0], $W[$i][1])
			Sleep(500)
		 Next
		 Sleep(2000)
	  EndIf
	  If $RunState = False Then ExitLoop
	  If CheckTroop("Barbarian") Then
		 ControlClick ($HWnD, "","", "left", "1", $Barbarian[0], $Barbarian[1])
		 Sleep(300)
		 For $x = 0 to 7 Step 1
			For $i = 0 to 4 Step 1
			   ControlClick ($HWnD, "","", "left", "1", $W[$i][0], $W[$i][1])
			   Sleep(100)
			Next
		 Next
		 Sleep(500)
	  EndIf
	  If $RunState = False Then ExitLoop
	  If CheckTroop("Archer") Then
		 ControlClick ($HWnD, "","", "left", "1", $Archer[0], $Archer[1])
		 Sleep(300)
		 For $x = 0 to 7 Step 1
			For $i = 0 to 4 Step 1
			   ControlClick ($HWnD, "","", "left", "1", $W[$i][0], $W[$i][1])
			   Sleep(100)
			Next
		 Next
		 Sleep(500)
	  EndIf
	  If $RunState = False Then ExitLoop
	  If CheckTroop("Goblin") Then
		 ControlClick ($HWnD, "","", "left", "1", $Goblin[0], $Goblin[1])
		 Sleep(300)
		 For $x = 0 to 7 Step 1
			For $i = 0 to 4 Step 1
			   ControlClick ($HWnD, "","", "left", "1", $W[$i][0], $W[$i][1])
			   Sleep(100)
			Next
		 Next
		 Sleep(500)
	  EndIf
	  ExitLoop
   WEnd
EndFunc

Func ReadValue()
   While 1
	  If $RunState = False Then ExitLoop
	  If Mod($SearchCount,10) = 0 Then ClearBox()
	  getBlueStacksPos()
	  $Gold = getGold($x_default, $y_default)
	  $Elixir = getElixir($x_default, $y_default + 29)
	  $Trophy = getTrophy($x_default, $y_default + 90)
	  If $Trophy <> "" Then
		 $Dark = getDarkElixir($x_default, $y_default + 57)
	  Else
		 $Dark = 0
		 $Trophy = getTrophy($x_default, $y_default + 60)
	  EndIf
	  If $RunState = False Then ExitLoop
	  GUICtrlSetData($Results, "(" & $SearchCount+1 & ") [G]: " & $Gold & Tab($Gold,12) & "[E]: " & $Elixir & Tab($Elixir,12) & "[D]: " & $Dark & Tab($Dark,12) & "[T]: " & $Trophy & @CRLF, -1)
	  $SearchCount += 1 ; Counter for number of searches
	  ExitLoop
   WEnd
EndFunc

Func CompareValue()
   Select
   Case $SearchMode = 1
	  If $Gold >= $MinGold And $Elixir >= $MinElixir Then
		 $SearchCheck = 1
	  Else
		 $SearchCheck = 0
	  EndIf
   Case $SearchMode = 2
	  If $Gold >= $MinGold OR $Elixir >= $MinElixir Then
		 $SearchCheck = 1
	  Else
		 $SearchCheck = 0
	  EndIf
   Case $SearchMode = 3
	  If $Dark >= $MinDark Then
		 $SearchCheck = 1
	  Else
		 $SearchCheck = 0
	  EndIf
   Case $SearchMode = 4
	  If $Trophy >= $MinTrophy Then
		 $SearchCheck = 1
	  Else
		 $SearchCheck = 0
	  EndIf
   Case $SearchMode = 5
	  If $Gold >= $MinGold And $Elixir >= $MinElixir And $Dark >= $MinDark Then
		 $SearchCheck = 1
	  Else
		 $SearchCheck = 0
	  EndIf
   Case $SearchMode = 6
	  If $Gold >= $MinGold And $Elixir >= $MinElixir Then
		 $SearchCheck = 1
	  ElseIf $Dark >= $MinDark Then
		 $SearchCheck = 1
	  Else
		 $SearchCheck = 0
	  EndIf
   EndSelect
EndFunc
#EndRegion ##### ATTACK #####

#Region ##### MINI FUNCTION #####

Func CheckScreenChange($a, $b, $c, $d, $e)
   $Pixel = PixelChecksum($a*$BSsize[0],$b*$BSsize[1], $c*$BSsize[0], $d*$BSsize[1], 2, $hWnD)
   Sleep($e)
   $Pixel1 = PixelChecksum($a*$BSsize[0],$b*$BSsize[1], $c*$BSsize[0], $d*$BSsize[1], 2, $hWnD)
   If $Pixel = $Pixel1 Then
	  Return False
   Else
	  Return True
   EndIf
EndFunc

Func MainScreen()
   If Not CheckScreenChange(0.25, 0.25, 0.75, 0.75, 500) Then
	  ControlClick ($HWnD, "","", "left", "1", 293*$x_ratio, 329*$y_ratio)
	  ControlClick ($HWnD, "","", "left", "1", 400*$x_ratio, 408*$y_ratio)
	  GUICtrlSetData($Results, "Waiting for Clash of Clans to load" & @CRLF, -1)
	  For $i = 0 to 4 Step 1
		 GUICtrlSetData($Results, " . ", -1)
		 Sleep(1000)
	  Next
	  $Pixel1 = _ColorCheckVariation(Hex(PixelGetColor(90, 644, $HWnD), 6), Hex(0xCA6E13, 6), 50)
	  $Pixel2 = _ColorCheckVariation(Hex(PixelGetColor(59, 171, $HWnD),6), Hex(0xC95E12, 6), 50)
	  $Pixel3 = _ColorCheckVariation(Hex(PixelGetColor(90, 644, $HWnD), 6), Hex(0x53240C, 6), 50)
	  $Pixel4 = _ColorCheckVariation(Hex(PixelGetColor(59, 171, $HWnD),6), Hex(0x5C2807, 6), 50)
	  While $Pixel1+$Pixel2+$Pixel3+$Pixel4<2
		 GUICtrlSetData($Results, " . ", -1)
		 Sleep(1000)
		 $Pixel1 = _ColorCheckVariation(Hex(PixelGetColor(90, 644, $HWnD), 6), Hex(0xCA6E13, 6), 50)
		 $Pixel2 = _ColorCheckVariation(Hex(PixelGetColor(59, 171, $HWnD),6), Hex(0xC95E12, 6), 50)
		 $Pixel3 = _ColorCheckVariation(Hex(PixelGetColor(90, 644, $HWnD), 6), Hex(0x53240C, 6), 50)
		 $Pixel4 = _ColorCheckVariation(Hex(PixelGetColor(59, 171, $HWnD),6), Hex(0x5C2807, 6), 50)
	  WEnd
	  Sleep(1000)
	  If Not CheckScreenChange(0.25, 0.25, 0.75, 0.75, 500) Then
		 ControlClick ($HWnD, "","", "left", "1", 400*$x_ratio, 408*$y_ratio)
		 Sleep(500)
	  EndIf
	  GUICtrlSetData($Results, @CRLF, -1)
   EndIf
   $Pixel1 = _ColorCheckVariation(Hex(PixelGetColor(90, 644, $HWnD), 6), Hex(0xCA6E13, 6), 50)
   $Pixel2 = _ColorCheckVariation(Hex(PixelGetColor(59, 171, $HWnD),6), Hex(0xC95E12, 6), 50)
   If $Pixel1 And $Pixel2 And CheckScreenChange(0.25, 0.25, 0.75, 0.75, 500) Then
	  GUICtrlSetData($Results, "In Main Screen" & @CRLF, -1)
   EndIf
EndFunc

Func Idle()
   While 1
	  If $RunState = False Then ExitLoop
	  GUICtrlSetData($Results, "Waiting for Full Army" & @CRLF, -1)
	  While Not $FullArmy
		 If $RunState = False Then ExitLoop
		 For $t = 0 to 5 Step 1
			If $RunState = False Then ExitLoop
			GUICtrlSetData($Results, (6-$t)*5 & " ", -1)
			Sleep(1000)
			For $i = 0 to 3 Step 1
			   If $RunState = False Then ExitLoop
			   GUICtrlSetData($Results, ".", -1)
			   Sleep(1000)
			Next
			If $RunState = False Then ExitLoop
			GUICtrlSetData($Results, " ", -1)
		 Next
		 If $RunState = False Then ExitLoop
		 GUICtrlSetData($Results, "0", -1)
		 GUICtrlSetData($Results, @CRLF, -1)
		 If $RunState = False Then ExitLoop
		 ZoomOut()
		 If $RunState = False Then ExitLoop
		 Sleep(1000)
		 Collect()
		 If $RunState = False Then ExitLoop
		 Sleep(1000)
		 Train()
		 If $RunState = False Then ExitLoop
	  WEnd
	  ExitLoop
   WEnd
EndFunc

Func Collect()
   While 1
	  GUICtrlSetData($Results, "Begin Collecting" & @CRLF, -1)
	  If $RunState = False Then ExitLoop
	  Local $Collector = PixelSearch(0, 0, 860, 720, 0xB0B875, 1, 1, $HWnD)
	  While IsArray($Collector)
		 If $RunState = False Then ExitLoop
		 ControlClick($HWnD, "","", "left", "1", $Collector[0], $Collector[1])
		 Sleep(500)
		 $Collector = PixelSearch(0, 0, 860, 720, 0xB0B875, 1, 1, $HWnD)
	  WEnd
	  If $RunState = False Then ExitLoop
	  GUICtrlSetData($Results, "Collecting Complete" & @CRLF, -1)
	  ExitLoop
   WEnd
EndFunc

Func ReturnHome()
   While 1
	  While GoldChange()
		 Sleep(1000)
		 If $RunState = False Then ExitLoop
	  WEnd
	  If $RunState = False Then ExitLoop
	  ControlClick ($HWnD, "","", "left", "1", 70*$x_ratio, 454*$y_ratio)
	  Sleep(1000)
	  ControlClick ($HWnD, "","", "left", "1", 482*$x_ratio, 350*$y_ratio)
	  Sleep(1000)
	  $Date = @MDAY & "." & @MON & "." & @YEAR
	  $Time = @HOUR & "." & @MIN
	  _ScreenCapture_CaptureWnd(@ScriptDir & "\Loots\" & $Date & " at " & $Time & ".jpg", $hWnd)
	  ControlClick ($HWnD, "","", "left", "1", 400*$x_ratio, 450*$y_ratio)
	  GUICtrlSetData($Results, "Return Home" & @CRLF, -1)
	  Sleep(4000)
	  ClearBox()
	  ExitLoop
   WEnd
EndFunc

Func GoldChange()
   While 1
	  getBlueStacksPos()
	  $Gold1 = getGold($x_default, $y_default)
	  Sleep(30000)
	  If $RunState = False Then ExitLoop
	  $Gold2 = getGold($x_default, $y_default)
	  If $Gold1 = $Gold2 Then
		 Return False
	  Else
		 Return True
		 GUICtrlSetData($Results, "Gold change detected. Waiting." & @CRLF, -1)
	  EndIf
	  ExitLoop
   WEnd
EndFunc


Func ZoomOut()
   $Pixel1 = _ColorCheckVariation(Hex(PixelGetColor(127, 248, $HWnD), 6), Hex(0xE8C656, 6), 20)
   $Pixel2 = _ColorCheckVariation(Hex(PixelGetColor(61, 298, $HWnD),6), Hex(0xAC8C42, 6), 20)
   $Pixel3 = _ColorCheckVariation(Hex(PixelGetColor(577, 130, $HWnD),6), Hex(0xD5A04F, 6), 20)
   $Pixel4 = _ColorCheckVariation(Hex(PixelGetColor(739, 251, $HWnD),6), Hex(0xECCE61, 6), 20)
   If $Pixel1 = True And $Pixel2 = True And $Pixel3 = True And $Pixel4 = True Then
	  GUICtrlSetData($Results, "Maxed Zoom Out" & @CRLF, -1)
   Else
	  GUICtrlSetData($Results, "Zoom Out" & @CRLF, -1)
	  $i = 0
	  While 1
		 $Pixel1 = _ColorCheckVariation(Hex(PixelGetColor(127, 248, $HWnD), 6), Hex(0xE8C656, 6), 20)
		 $Pixel2 = _ColorCheckVariation(Hex(PixelGetColor(61, 298, $HWnD),6), Hex(0xAC8C42, 6), 20)
		 $Pixel3 = _ColorCheckVariation(Hex(PixelGetColor(577, 130, $HWnD),6), Hex(0xD5A04F, 6), 20)
		 $Pixel4 = _ColorCheckVariation(Hex(PixelGetColor(739, 251, $HWnD),6), Hex(0xECCE61, 6), 20)
		 If $Pixel1 = True And $Pixel2 = True And $Pixel3 = True And $Pixel4 = True Then
			ExitLoop
		 Else
			ControlSend($HWnD, "", "", "{DOWN}", 0)
			$i += 1
		 EndIf
		 If $i = 50 Then
			ExitLoop
		 EndIf
		 If $RunState = False Then ExitLoop
		 Sleep(500)
	  WEnd
	  GUICtrlSetData($Results, "Zoom Out Complete" & @CRLF, -1)
   EndIf
EndFunc


Func Button($hex)
   $Count = 0
   $Pixel = PixelSearch(0,0,900,700,$hex,0,1,$HWnD) ;Attack! button
   While Not IsArray($Pixel) And $Count < 5
	  $Pixel = PixelSearch(0,0,900,700,$hex,0,1,$HWnD) ;Attack! button
	  Sleep(200)
	  $Count += 1
   WEnd
   If $Count < 5 Then
	  ControlClick ($HWnD, "","", "left", "1", $Pixel[0], $Pixel[1])
   EndIf
   Sleep(1000)
EndFunc

Func Terminate()
   Exit
EndFunc

Func FindPos(ByRef $Pos)
   Opt ("MouseCoordMode", 2)
   Local $x = 1
   While $x = 1
	  If _IsPressed("01") Then
		 $Pos = MouseGetPos()
		 $x = 0
	  EndIf
   WEnd
   Opt ("MouseCoordMode", 0)
EndFunc

Func ClearBox()
   GUICtrlDelete($Results)
   $Results = GUICtrlCreateEdit("", 10, 108, 310, 272, BitOR($SS_SUNKEN,$ES_READONLY, $SS_LEFT))
EndFunc

Func LB()
   ClearBox()
   GUICtrlSetData($Results,"Bot Started" & @CRLF, -1)
   $RunState = True
   GUICtrlSetData($Button,"STOP")
   MainScreen()
   ZoomOut()
   $B1Pos[0] = 0
   $B2Pos[0] = 0
   $B3Pos[0] = 0
   $B4Pos[0] = 0
   LocateBarrack()
   GUICtrlSetData($LBButton,"Locate Barracks")
   GUICtrlSetData($Results, "Barracks located" & @CRLF, -1)
   GUICtrlSetData($Results, "Barrack 01: " & $B1Pos[0] & ", " & $B1Pos[1] & @CRLF, -1)
   GUICtrlSetData($Results, "Barrack 02: " & $B2Pos[0] & ", " & $B2Pos[1] & @CRLF, -1)
   GUICtrlSetData($Results, "Barrack 03: " & $B3Pos[0] & ", " & $B3Pos[1] & @CRLF, -1)
   GUICtrlSetData($Results, "Barrack 04: " & $B4Pos[0] & ", " & $B4Pos[1] & @CRLF, -1)
   $RunState = False
   GUICtrlSetData($Button,"START")
EndFunc

Func Tr()
   ClearBox()
   GUICtrlSetData($Results,"Bot Started" & @CRLF, -1)
   $RunState = True
   GUICtrlSetData($Button,"STOP")
   MainScreen()
   GetInput()
   ZoomOut()
   Train()
   $RunState = False
   GUICtrlSetData($TrButton, "Train")
   GUICtrlSetData($Button,"STOP")
EndFunc

Func Atk()
   ClearBox()
   GUICtrlSetData($Results,"Bot Started" & @CRLF, -1)
   $RunState = True
   GUICtrlSetData($Button,"STOP")
   MainScreen()
   GetInput()
   ZoomOut()
   Attack()
   GUICtrlSetData($AtkButton, "Attack")
   $RunState = False
   GUICtrlSetData($Button,"START")
EndFunc

Func SearchFunction()
   ClearBox()
   GUICtrlSetData($Results,"Bot Started" & @CRLF, -1)
   $RunState = True
   GUICtrlSetData($Button,"STOP")
   GetInput()
   ClearBox()
   ControlClick ($HWnD, "","", "left", "1", 715*$x_ratio, 405*$y_ratio) ;Click Next
   VillageSearch()
   GUICtrlSetData($VSButton, "Village Search")
   $RunState = False
   GUICtrlSetData($Button,"START")
EndFunc

Func DrpTrp()
   ClearBox()
   GUICtrlSetData($Results,"Bot Started" & @CRLF, -1)
   $RunState = True
   GUICtrlSetData($Button,"STOP")
   GetInput()
   AssignTroop()
   DropTroop()
   ReturnHome()
   GUICtrlSetData($DTButton, "Drop Troop")
   $RunState = False
   GUICtrlSetData($Button,"START")
EndFunc

Func KeepAlive()
   While $KeepAlive = True
	  ControlSend($HWnD, "", "", "{DOWN}", 0)
	  Sleep(10000)
	  If $KeepAlive = False Then
		 ExitLoop
	  EndIf
   WEnd
EndFunc

Func Tab($a, $b)
   $Tab = ""
   For $i = StringLen($a) to $b Step 1
	  $Tab &= " "
   Next
   Return $Tab
EndFunc

#cs
Func Pause()
   $Paused = NOT $Paused
   While $Paused
	  Sleep(100)
   TrayTip("Script Paused","SHIFT+1 to Unpause", 0, $TIP_ICONASTERISK)
   WEnd
EndFunc

Func Restart()
   ControlClick ($HWnD, "","", "left", "1", 125, 575)
   Sleep(2000)
   ControlClick ($HWnD, "","", "left", "1", 125, 577)
   Sleep(2000)
   ControlClick ($HWnD, "","", "left", "1", 205, 575)
   Sleep(2000)
   MouseClickDrag("left", 700, 300, 700, 120)
   Sleep(2000)
   ControlClick ($HWnD, "","", "left", "1", 290, 160)
   Sleep(50000)
EndFunc

Func Initiate()
   ControlClick ($HWnD, "","", "left", "1", 290, 150) ;Click BlueStacks
   Sleep(60000)
   ZoomOut()
   Sleep(10000)
EndFunc
#ce
#EndRegion ##### MINI FUNCTION ######


