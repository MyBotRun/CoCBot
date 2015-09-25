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
#include "GkevinOD.au3"

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

$aPos = ControlGetPos("BlueStacks App Player", "", "[CLASS:BlueStacksApp; INSTANCE:1]")
$tPoint = DllStructCreate("int X;int Y")
DllStructSetData($tpoint, "X", $aPos[0])
DllStructSetData($tpoint, "Y", $aPos[1])
_WinAPI_ClientToScreen(WinGetHandle(WinGetTitle("BlueStacks App Player")), $tPoint)

$x_BS = DllStructGetData($tpoint, "X")
$y_BS = DllStructGetData($tpoint, "Y")
$x_default = DllStructGetData($tpoint, "X") + 51
$y_default = DllStructGetData($tpoint, "Y") + 66

Global $RunState = False, $KeepAlive = False, $FullArmy = False
Global $Gold, $Elixir, $Dark, $Trophy, $MinGold = 80000, $MinElixir = 80000, $MinDark = 0, $MinTrophy = 0, $SearchMode = 1, $SearchCheck = 0

Global $Attack = 0xF0E5D6, $FindAMatch = 0xF8E0A7
Global $Config = @ScriptDir & "\config.ini"
Global $Left = 50.23, $Top = 67.5, $Right = 613.95, $Bottom = 431.67
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
$s1 = GUICtrlCreateRadio("G + E", 15, 7)
$s2 = GUICtrlCreateRadio("G / E", 15, 25)
$s3 = GUICtrlCreateRadio("D", 70, 7)
$s4 = GUICtrlCreateRadio("T", 70, 25)
$s5 = GUICtrlCreateRadio("G E D", 105, 7)
$s6 = GUICtrlCreateRadio("GE / D", 105, 25)
GUICtrlSetState($s1, $GUI_CHECKED)
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
$Barrack01 = GUICtrlCreateCombo("Barrack 01", 167, 49, 70, 30, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarian|Archer|Goblin|Giant")
_GUICtrlComboBox_SelectString(-1, "Archer")
$Barrack02 = GUICtrlCreateCombo("Barrack 02", 167, 73, 70, 30, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarian|Archer|Goblin|Giant")
_GUICtrlComboBox_SelectString(-1, "Archer")
$Barrack03 = GUICtrlCreateCombo("Barrack 03", 240, 49, 70, 30, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarian|Archer|Goblin|Giant")
_GUICtrlComboBox_SelectString(-1, "Barbarian")
$Barrack04 = GUICtrlCreateCombo("Barrack 04", 240, 73, 70, 30, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
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
				  GUICtrlSetData($Results, "Bot Started.." & @CRLF, -1)
			   ElseIf $RunState = False Then
				  GUICtrlSetData($Button,"START")
				  GUICtrlSetData($Results, "Bot Stopped" & @CRLF, -1)
			   EndIf
			Case $LBButton
			   GUICtrlSetData($LBButton,"Locating...")
			   GUICtrlSetData($Results, "Bot Started.." & @CRLF, -1)
			Case $TrButton
			   GUICtrlSetData($TrButton,"Training...")
			   GUICtrlSetData($Results, "Bot Started.." & @CRLF, -1)
			Case $AtkButton
			   GUICtrlSetData($AtkButton,"Attacking...")
			   GUICtrlSetData($Results, "Bot Started.." & @CRLF, -1)
			Case $VSButton
			   GUICtrlSetData($VSButton,"Searching...")
			   GUICtrlSetData($Results, "Bot Started.." & @CRLF, -1)
			Case $DTButton
			   GUICtrlSetData($DTButton,"Dropping...")
			   ;GUICtrlSetData($Results, "Bot Started.." & @CRLF, -1)
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
   While 1
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  MainScreen()	;Check if main screen
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  GetInput()	;Read user's input
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  ZoomOut()
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  LocateBarrack()	;If barrack not located, ask user to manually click on barrack to locate position
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  Train()			;Locate Barrack, Train Barrack
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  ClearBox()
	  While Not $FullArmy
		 Idle()
	  WEnd
	  If $RunState = False Then
		 ExitLoop
	  EndIf
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
   $B1Pos[0] = IniRead($Config, "Barrack 01", "X", "0")
   $B1Pos[1] = IniRead($Config, "Barrack 01", "Y", "0")
   $B2Pos[0] = IniRead($Config, "Barrack 02", "X", "0")
   $B2Pos[1] = IniRead($Config, "Barrack 02", "Y", "0")
   $B3Pos[0] = IniRead($Config, "Barrack 03", "X", "0")
   $B3Pos[1] = IniRead($Config, "Barrack 03", "Y", "0")
   $B4Pos[0] = IniRead($Config, "Barrack 04", "X", "0")
   $B4Pos[1] = IniRead($Config, "Barrack 04", "Y", "0")
   If $B1Pos[0]*$B2Pos[0]*$B3Pos[0]*$B4Pos[0] <> 0 Then
	  GUICtrlSetData($Results, "Barracks' position loaded successfully" & @CRLF, -1)
	  GUICtrlSetData($Results, "Barrack 01: " & $B1Pos[0] & ", " & $B1Pos[1] & @CRLF, -1)
	  GUICtrlSetData($Results, "Barrack 02: " & $B2Pos[0] & ", " & $B2Pos[1] & @CRLF, -1)
	  GUICtrlSetData($Results, "Barrack 03: " & $B3Pos[0] & ", " & $B3Pos[1] & @CRLF, -1)
	  GUICtrlSetData($Results, "Barrack 04: " & $B4Pos[0] & ", " & $B4Pos[1] & @CRLF, -1)
   EndIf
EndFunc

#Region ##### TRAIN #####
Func LocateBarrack()
   Local $ClickCheck, $LocateCheck = 0
   While 1
	  While 1
		 If $RunState = False Then
			ExitLoop(2)
		 EndIf
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
		 If $RunState = False Then
			ExitLoop(2)
		 EndIf
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
		 If $RunState = False Then
			ExitLoop(2)
		 EndIf
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
		 If $RunState = False Then
			ExitLoop(2)
		 EndIf
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
	  If $RunState = False Then
		 ExitLoop
	  EndIf

	  ControlClick ($HWnD, "","", "left", "1", $x, $y)
	  Sleep(1000)
	  ControlClick ($HWnD, "","", "left", "1", 560*$x_ratio, 490*$y_ratio)
	  Sleep(1000)
	  $Pixel = PixelGetColor(351*$x_ratio, 455*$y_ratio, $HWnD)
	  If $Pixel = 13645880 OR $Pixel = 13645881 OR $Pixel = 13645888 OR $Pixel = 13645889 OR $Pixel = 13645890 OR $Pixel = 13645891 Then
		 $FullArmy = True
	  EndIf
	  Select
	  Case $z = "Barbarian"
		 For $i = 1 To 65 Step 1
			ControlClick ($HWnD, "","", "left", "1", 220*$x_ratio, 270*$y_ratio)
			If $RunState = False Then
			   ExitLoop
			EndIf
			Sleep(50)
		 Next
	  Case $z = "Archer"
		 For $i = 1 To 65 Step 1
			ControlClick ($HWnD, "","", "left", "1", 310*$x_ratio, 270*$y_ratio)
			If $RunState = False Then
			   ExitLoop
			EndIf
			Sleep(50)
		 Next
	  Case $z = "Goblin"
		 For $i = 1 To 65 Step 1
			ControlClick ($HWnD, "","", "left", "1", 490*$x_ratio, 270*$y_ratio)
			If $RunState = False Then
			   ExitLoop
			EndIf
			Sleep(50)
		 Next
	  Case $z = "Giant"
		 For $i = 1 To 15 Step 1
			ControlClick ($HWnD, "","", "left", "1", 400*$x_ratio, 270*$y_ratio)
			If $RunState = False Then
			   ExitLoop
			EndIf
			Sleep(50)
		 Next
	  EndSelect
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  Sleep(1000)
	  ControlClick ($HWnD, "","", "left", "1", 656*$x_ratio, 113*$y_ratio)
	  Sleep(1000)
	  ExitLoop
   WEnd
EndFunc

Func Train()
   GUICtrlSetData($Results,"Begin Training" & @CRLF, -1)
   $FullArmy = False
   If $B1Pos[0] <> 0 And $B1Troop <> "Barrack 01" Then
	  TrainBarrack($B1Pos[0],$B1Pos[1],$B1Troop)
   EndIf
   If $B2Pos[0] <> 0 And $B2Troop <> "Barrack 02" Then
	  TrainBarrack($B2Pos[0],$B2Pos[1],$B2Troop)
   EndIf
   If $B3Pos[0] <> 0  And $B3Troop <> "Barrack 03" Then
	  TrainBarrack($B3Pos[0],$B3Pos[1],$B3Troop)
   EndIf
   If $B4Pos[0] <> 0  And $B4Troop <> "Barrack 04" Then
	  TrainBarrack($B4Pos[0],$B4Pos[1],$B4Troop)
   EndIf
   If $FullArmy Then
   GUICtrlSetData($Results, "Army Full" & @CRLF, -1)
   EndIf
   GUICtrlSetData($Results, "Training Complete" & @CRLF, -1)
EndFunc
#EndRegion ##### TRAIN #####

#Region ##### ATTACK #####
Func Attack()
   While 1
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  AssignTroop()
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  PrepareAttack()
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  GUICtrlSetData($Results, "Attack started. Begin searching.." & @CRLF, -1)
	  VillageSearch()
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  Sleep(5000)
	  DropTroop()
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  ReturnHome()
	  ExitLoop
   WEnd
EndFunc

Func PrepareAttack()
   While 1
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  ControlClick ($HWnD, "","", "left", "1", 50*$x_ratio, 500*$y_ratio) ;Click Attack
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  Sleep(2000)
	  ControlClick ($HWnD, "","", "left", "1", 190*$x_ratio, 420*$y_ratio) ;Click Find a Match
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  Sleep(2000)
	  ControlClick ($HWnD, "","", "left", "1", 470*$x_ratio, 330*$y_ratio) ;Click Break Shield
	  ExitLoop
   WEnd
EndFunc

Func CheckSearch()
   Sleep(2000)
   $GoldCheck = ""
   $i = 0
   While $GoldCheck = ""
	  $i += 1
	  If $i = 75 Then
		 If CheckScreenChange(0.25,0.25,0.75,0.75,500) Then
			ControlClick ($HWnD, "","", "left", "1", 715*$x_ratio, 405*$y_ratio) ;Click Next
			$i = 0
		 Else
			ControlClick ($HWnD, "","", "left", "1", 293*$x_ratio, 329*$y_ratio)
			Sleep(6000)
			Start()
			$RunState = False
			ExitLoop
		 EndIf
	  EndIf
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  Local $countY = 0
	  $GoldCheck = getGold($x_default, $y_default + $countY)
	  While $GoldCheck = "" And $countY <= 4
		 $countY += 1
		 $GoldCheck = getGold($x_default, $y_default + $countY)
	  WEnd
	  Sleep(200)
	  If $RunState = False Then
		 ExitLoop
	  EndIf
   WEnd
  ;GUICtrlSetData($Results, "Finish check" & @CRLF, -1)
EndFunc


Func VillageSearch()
   While 1
	  Global $SearchCount = 0
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  CheckSearch()
	  If $RunState = False Then
	  ExitLoop
	  EndIf
	  ReadValue()
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  CompareValue()
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  While $SearchCheck = 0
		 If $RunState = False Then
			ExitLoop
		 EndIf
		 ControlClick ($HWnD, "","", "left", "1", 715*$x_ratio, 405*$y_ratio) ;Click Next
		 If $RunState = False Then
			ExitLoop
		 EndIf
		 CheckSearch()
		 If $RunState = False Then
			ExitLoop
		 EndIf
		 ReadValue()
		 If $RunState = False Then
			ExitLoop
		 EndIf
		 CompareValue()
		 If $RunState = False Then
			ExitLoop
		 EndIf
	  WEnd
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  GUICtrlSetData($Results, "Enemy Found!" & @CRLF, -1)
	  ;TrayTip ("Enemy Found!","Requirement met:  Gold: " & $Gold & ". Elixir: " & $Elixir, 0, $TIP_ICONASTERISK)
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
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  DropSingle("Giant",$UpLeft)
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  DropSingle("Barbarian", $UpLeft)
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  DropSingle("Archer", $UpLeft)
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  DropSingle("Giant",$UpRight)
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  DropSingle("Barbarian", $UpRight)
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  DropSingle("Archer", $UpRight)
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  DropSingle("Barbarian", $UpLeft)
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  DropSingle("Archer", $UpLeft)
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  GUICtrlSetData($Results, "Finish dropping troops. Waiting for battle end." & @CRLF, -1)
	  ExitLoop
   WEnd
EndFunc

Func DropSingle($T, $W)
   While 1
	  If $RunState = False Then
		 ExitLoop
	  EndIf
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
		 If $RunState = False Then
			ExitLoop
		 EndIf
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
		 If $RunState = False Then
			ExitLoop
		 EndIf
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
		 If $RunState = False Then
			ExitLoop
		 EndIf
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
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  If CheckTroop("Giant") Then
		 ControlClick ($HWnD, "","", "left", "1", $Giant[0], $Giant[1])
		 Sleep(500)
		 For $i = 1 to 5 Step 1
			ControlClick ($HWnD, "","", "left", "1", $W[$i][0], $W[$i][1])
			Sleep(500)
		 Next
		 Sleep(2000)
	  EndIf
	  If $RunState = False Then
		 ExitLoop
	  EndIf
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
	  If $RunState = False Then
		 ExitLoop
	  EndIf
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
	  If $RunState = False Then
		 ExitLoop
	  EndIf
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
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  If Mod($SearchCount,10) = 0 Then
		 ClearBox()
	  EndIf
	  $countY = 0
	  Global $Gold = 0, $Elixir = 0, $Dark = 0, $Trophy = 0
	  $Gold = getGold($x_default, $y_default + $countY)
	  While $Gold = "" And $countY <= 4
		 $countY += 1
		 $Gold = getGold($x_default, $y_default + $countY)
	  WEnd

	  $Elixir = getElixir($x_default, $y_default + $countY + 29)
	  $Trophy = getTrophy($x_default, $y_default + $countY + 90)

	  If $Trophy <> "" Then
		 $Dark = getDarkElixir($x_default, $y_default + $countY + 57)
	  Else
		 $Dark = 0
		 $Trophy = getTrophy($x_default, $y_default + $countY + 60)
	  EndIf
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

#cs
Func MainScreen()
   While 1
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  GUICtrlSetData($Results, "Waiting for Clash of Clans to load..." & @CRLF, -1)
	  $Pixel = PixelGetColor(630*$x_ratio, 390*$y_ratio, $HWnD)
	  If Hex($Pixel,6) = 282828 Or $Pixel = 2962704 Then
		 ControlClick ($HWnD, "","", "left", "1", 293*$x_ratio, 329*$y_ratio)
		 If $RunState = False Then
			ExitLoop
		 EndIf
		 Sleep(5000)
	  EndIf
	  $Pixel = PixelSearch(0,0,900,700,0xF8ED90,0,1,$HWnD)
	  If IsArray($Pixel) Then
		 ControlClick ($HWnD, "","", "left", "1", 400*$x_ratio, 450*$y_ratio)
		 If $RunState = False Then
			ExitLoop
		 EndIf
		 Sleep(5000)
	  EndIf
	  $Pixel = PixelSearch(0,0,900,700,$Attack,0,1,$HWnD)
	  While Not IsArray($Pixel)
		 $Pixel = PixelSearch(0,0,900,700,$Attack,0,1,$HWnD)
		 If $RunState = False Then
			ExitLoop
		 EndIf
		 Sleep(200)
	  WEnd
	  GUICtrlSetData($Results, "In main screen" & @CRLF, -1)
	  ExitLoop
   WEnd
EndFunc
#ce
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
	  GUICtrlSetData($Results, "Waiting for Clash of Clans to load..." & @CRLF, -1)
	  Sleep(6000)
   EndIf
   While Not CheckScreenChange(0.25, 0.25, 0.75, 0.75, 500)
	  ControlClick ($HWnD, "","", "left", "1", 400*$x_ratio, 408*$y_ratio)
	  Sleep(1000)
   WEnd
   While Not CheckScreenChange(0.25, 0.25, 0.75, 0.75, 500)
	  Sleep(1000)
   WEnd
   GUICtrlSetData($Results, "In Main Screen" & @CRLF, -1)
EndFunc

Func Idle()
   While Not $FullArmy
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  Train()
	  If $RunState = False OR $FullArmy Then
		 ExitLoop
	  EndIf
	  Sleep(30000)
   WEnd
EndFunc

Func ReturnHome()
   #cs
   While CheckScreenChange(0.25, 0.9, 0.75, 0.95)
	  Sleep(1000)
   WEnd
   GUICtrlSetData($Results, "Return Home" & @CRLF, -1)
   ControlClick ($HWnD, "","", "left", "1", 400*$x_ratio, 450*$y_ratio)
   #ce
   While 1
	  While GoldChange()
		 Sleep(1000)
		 If $RunState = False Then
			ExitLoop
		 EndIf
	  WEnd
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  ControlClick ($HWnD, "","", "left", "1", 70*$x_ratio, 454*$y_ratio)
	  Sleep(1000)
	  ControlClick ($HWnD, "","", "left", "1", 482*$x_ratio, 350*$y_ratio)
	  Sleep(1000)
	  ControlClick ($HWnD, "","", "left", "1", 400*$x_ratio, 450*$y_ratio)
	  GUICtrlSetData($Results, "Return Home" & @CRLF, -1)
	  Sleep(4000)
	  ExitLoop
   WEnd
EndFunc

Func GoldChange()
   While 1
      Local $countY = 0
	  $Gold1 = getGold($x_default, $y_default + $countY)
	  While $Gold1 = "" And $countY <= 4
		  $countY += 1
		  $Gold1 = getGold($x_default, $y_default + $countY)
	  WEnd
	  Sleep(30000)
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  $Gold2 = Number(getGold($x_default, $y_default+$countY))
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
	  If $RunState = False Then
		 ExitLoop
	  EndIf
	  Sleep(500)
   WEnd
   GUICtrlSetData($Results, "Zoom Out Complete" & @CRLF, -1)
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
   GUICtrlSetData($Results,"Bot Started.." & @CRLF, -1)
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
   GUICtrlSetData($Results,"Bot Started.." & @CRLF, -1)
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
   GUICtrlSetData($Results,"Bot Started.." & @CRLF, -1)
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
   GUICtrlSetData($Results,"Bot Started.." & @CRLF, -1)
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
   GUICtrlSetData($Results,"Bot Started.." & @CRLF, -1)
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


