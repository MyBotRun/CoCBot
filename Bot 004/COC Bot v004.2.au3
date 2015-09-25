#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#Include <GUIEdit.au3>
#Include <GUIComboBox.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <ScreenCapture.au3>
#include <Date.au3>
#include <Misc.au3>

#RequireAdmin

#Region ### START Koda GUI section ###
$frmBot = GUICreate("COC Bot Pre-Alpha v004.2", 417, 392, 207, 158)
$tabMain = GUICtrlCreateTab(8, 8, 401, 355)
$pageGeneral = GUICtrlCreateTabItem("General")
$txtLog = GUICtrlCreateEdit("", 16, 40, 385, 240, BitOR($ES_AUTOVSCROLL,$ES_NOHIDESEL,$ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL))
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Controls = GUICtrlCreateGroup("Controls", 16, 290, 185, 65)
$btnStart = GUICtrlCreateButton("Start", 30, 314, 75, 25)
$btnStop = GUICtrlCreateButton("Stop", 110, 314, 75, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$otherSettings = GUICtrlCreateGroup("Other Settings", 208, 290, 185, 65)
$lblMaxTrophy = GUICtrlCreateLabel("Max Trophy :", 230, 320, 66, 17)
$txtMaxTrophy = GUICtrlCreateInput("3000", 298, 318, 71, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Bot will lose tropies if your trophy is greater than this.")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$pageSearchSetting = GUICtrlCreateTabItem("Search Settings")
$btnSearchMode = GUICtrlCreateButton("Search Mode", 24, 327, 368, 25)
GUICtrlSetTip(-1, "Does not attack. Searches for base that meets conditions.")
$Conditions = GUICtrlCreateGroup("Conditions", 16, 40, 193, 185)
$chkMeetDE = GUICtrlCreateCheckbox("Meet Dark Elixir", 40, 88, 97, 17)
$chkMeetTrophy = GUICtrlCreateCheckbox("Meet Trophy Count", 40, 112, 113, 17)
$chkMeetGxE = GUICtrlCreateCheckbox("Meet Gold and Elixir", 40, 64, 113, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$lblConditions = GUICtrlCreateLabel("Check the boxes that you want to meet. The bot will stop at a base when it meets the conditions. If all unchecked, bot will stop if gold or elixir that is met.", 26, 143, 172, 72, $SS_CENTER)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Resources = GUICtrlCreateGroup("Resources", 208, 40, 193, 185)
$lblMinGold = GUICtrlCreateLabel("Minimum Gold: ", 216, 64, 76, 17)
$lblMinElixir = GUICtrlCreateLabel("Minimum Elixir:", 216, 88, 72, 17)
$lblMinDarkElixir = GUICtrlCreateLabel("Minimum Dark Elixir:", 216, 112, 98, 17)
$lblMinTrophy = GUICtrlCreateLabel("Minimum Trophy Count:", 216, 136, 115, 17)
$txtMinGold = GUICtrlCreateInput("80000", 330, 62, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
$txtMinElixir = GUICtrlCreateInput("80000", 330, 86, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
$txtMinDarkElixir = GUICtrlCreateInput("0", 330, 110, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
$txtMinTrophy = GUICtrlCreateInput("0", 330, 134, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
GUICtrlSetLimit(-1, 2)
$lblResources = GUICtrlCreateLabel("Bot will stop when a base is found with resources higher or equal to the minimum resources.", 220, 164, 168, 51, $SS_CENTER)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$OtherSearchSettings = GUICtrlCreateGroup("Other Seach Settings", 15, 225, 385, 95)
$chkAlertSearch = GUICtrlCreateCheckbox("Alert when Base Found", 30, 250, 132, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$pageAttackSettings = GUICtrlCreateTabItem("Attack Settings")
$WeakBaseSettings = GUICtrlCreateGroup("Weak Base Settings", 15, 35, 130, 230)
$lblMortar = GUICtrlCreateLabel("Max Mortar Lvl:", 20, 58, 77, 17)
$cmbMortar = GUICtrlCreateCombo("", 100, 55, 35, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8", "5")
GUICtrlSetState(-1, $GUI_DISABLE)
$lblWizardTower = GUICtrlCreateLabel("Wiz Tower Lvl:", 20, 83, 75, 17)
$cmbWizTower = GUICtrlCreateCombo("", 100, 80, 35, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8", "4")
GUICtrlSetState(-1, $GUI_DISABLE)
$lblCannon = GUICtrlCreateLabel("Cannon Lvl:", 20, 108, 61, 17)
$lblArcher = GUICtrlCreateLabel("Archer Lvl:", 20, 133, 55, 17)
$chkWithKing = GUICtrlCreateCheckbox("Attack their King", 20, 180, 112, 17, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_RIGHTBUTTON))
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetState(-1, $GUI_DISABLE)
$chkWithQueen = GUICtrlCreateCheckbox("Attack their Queen", 20, 200, 112, 17, BitOR($GUI_SS_DEFAULT_CHECKBOX,$BS_RIGHTBUTTON))
GUICtrlSetState(-1, $GUI_DISABLE)
$cmbCannon = GUICtrlCreateCombo("", 100, 105, 35, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13", "8")
GUICtrlSetState(-1, $GUI_DISABLE)
$cmbArcher = GUICtrlCreateCombo("", 100, 130, 35, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13", "8")
GUICtrlSetState(-1, $GUI_DISABLE)
$lblWeakDescription = GUICtrlCreateLabel("Bot will attack bases that meet requirement.", 17, 225, 125, 32, $SS_CENTER)
$lblxBow = GUICtrlCreateLabel("X-Bow Lvl:", 20, 158, 55, 17)
$cmbxBow = GUICtrlCreateCombo("", 100, 155, 35, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "0|1|2|3|4|5|6|7|8|9|10|11|12|13", "0")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$AttackMode = GUICtrlCreateGroup("Attack Mode", 150, 35, 250, 115)
$radDeadBases = GUICtrlCreateRadio("Dead Bases - Meets condition, full collectors", 155, 55, 238, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$radWeakBases = GUICtrlCreateRadio("Weak Bases - Meets condition and able 50%", 155, 85, 228, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$radAllBases = GUICtrlCreateRadio("All Bases - Attack all that meets search.", 155, 115, 228, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$HeroesSettings = GUICtrlCreateGroup("Royals Settings", 150, 155, 250, 110)
$chkKingAttackDead = GUICtrlCreateCheckbox("Atk Dead Bases", 165, 195, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$chkKingAttackWeakBases = GUICtrlCreateCheckbox("Atk Weak Bases", 165, 215, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$chkKingAttackAllBases = GUICtrlCreateCheckbox("Atk All Bases", 165, 235, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$lblKingSettings = GUICtrlCreateLabel("King Settings:", 165, 175, 69, 17)
$lblQueenSettings = GUICtrlCreateLabel("Queen Settings:", 285, 175, 80, 17)
$chkQueenAttackDeadBases = GUICtrlCreateCheckbox("Atk Dead Bases", 285, 195, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$chkQueenAttackWeakBases = GUICtrlCreateCheckbox("Atk Weak Bases", 285, 215, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$chkQueenAttackAllBases = GUICtrlCreateCheckbox("Atk All Bases", 285, 235, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$DeploySettings = GUICtrlCreateGroup("Deploy Settings", 15, 270, 385, 85)
$chkAttackTH = GUICtrlCreateCheckbox("Attack Townhall (Outside)", 250, 325, 142, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$cmbDeploy = GUICtrlCreateCombo("", 30, 290, 360, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Attack on two sides, penetrates through base|Attack on three sides, gets outer and some inside of base|Attack on all sides equally, gets most of outer base", "Attack on all sides equally, gets most of outer base")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$pageDonateSettings = GUICtrlCreateTabItem("Donate Settings")
$Donation = GUICtrlCreateGroup("", 15, 30, 385, 325)
$Barbarians = GUICtrlCreateGroup("Barbarians", 20, 70, 120, 235)
$Checkbox1 = GUICtrlCreateCheckbox("Donate to All", 30, 95, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$txtDonateBarbarians = GUICtrlCreateEdit("", 25, 120, 110, 179, BitOR($ES_WANTRETURN,$WS_VSCROLL))
GUICtrlSetData(-1, StringFormat("barbarians\r\nbarb\r\nany"))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Keywords for donating Barbarians")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Archers = GUICtrlCreateGroup("Archers", 148, 70, 120, 235)
$Checkbox2 = GUICtrlCreateCheckbox("Donate to All", 155, 95, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$txtDonateArchers = GUICtrlCreateEdit("", 153, 120, 110, 179, BitOR($ES_WANTRETURN,$WS_VSCROLL))
GUICtrlSetData(-1, StringFormat("archers\r\narch\r\nany"))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Keywords for donating Archers")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Giants = GUICtrlCreateGroup("Giants", 275, 70, 120, 235)
$Checkbox3 = GUICtrlCreateCheckbox("Donate to All", 285, 95, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$txtDonateGiants = GUICtrlCreateEdit("", 280, 120, 110, 179, BitOR($ES_WANTRETURN,$WS_VSCROLL))
GUICtrlSetData(-1, StringFormat("giants\r\ngiant\r\nany"))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Keywords for donating Giants")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$chkDonateGiants = GUICtrlCreateCheckbox("Donate Giants", 275, 305, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$chkDonateArchers = GUICtrlCreateCheckbox("Donate Archers", 149, 305, 97, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$chkDonateBarbarians = GUICtrlCreateCheckbox("Donate Barbarians", 20, 305, 112, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$chkRequest = GUICtrlCreateCheckbox("Request for :", 30, 45, 82, 17)
GUICtrlSetState(-1, $GUI_DISABLE)
$txtRequest = GUICtrlCreateInput("any", 115, 45, 276, 21)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip(-1, "Request for input.")
$btnLocateClanCastle = GUICtrlCreateButton("Locate Clan Castle Manually", 25, 325, 365, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$pageTroopSettings = GUICtrlCreateTabItem("Troop Settings")
$Barracks = GUICtrlCreateGroup("Troops", 20, 40, 185, 215)
$lblBarbarians = GUICtrlCreateLabel("Barbarians :", 30, 68, 60, 17)
$lblArchers = GUICtrlCreateLabel("Archers :", 30, 93, 46, 17)
$lblGoblins = GUICtrlCreateLabel("Goblins :", 30, 118, 45, 17)
$txtBarbarians = GUICtrlCreateInput("30", 115, 65, 56, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
GUICtrlSetState(-1, $GUI_DISABLE)
$txtBarrack2 = GUICtrlCreateInput("60", 115, 90, 56, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
GUICtrlSetState(-1, $GUI_DISABLE)
$txtBarrack3 = GUICtrlCreateInput("10", 115, 115, 56, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
GUICtrlSetState(-1, $GUI_DISABLE)
$lblPercentBarbarians = GUICtrlCreateLabel("%", 175, 68, 12, 17)
$lblPercentArchers = GUICtrlCreateLabel("%", 175, 93, 12, 17)
$lblPercentGoblins = GUICtrlCreateLabel("%", 175, 118, 12, 17)
$lblBarracks = GUICtrlCreateLabel("Must equal 100% to fully distribute the troops with maximum amount efficiency. Bot will use this if custom troops is selected", 40, 175, 140, 67, $SS_CENTER)
$cmbTroopComp = GUICtrlCreateCombo("", 45, 145, 131, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Archers+Barbarians|Arch+Barb+Goblins|A+B+Goblins+Giants|A+B+G+G+Wall Breaker|Custom Troops|Use Barracks", "Use Barracks")
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$OtherTroops = GUICtrlCreateGroup("Other Troops", 210, 40, 185, 85)
$lblGiants = GUICtrlCreateLabel("Number of Giants:", 215, 68, 89, 17)
$lblWallBreakers = GUICtrlCreateLabel("Number of Wall Breakers:", 215, 93, 125, 17)
$Input1 = GUICtrlCreateInput("4", 340, 65, 46, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetState(-1, $GUI_DISABLE)
$Input2 = GUICtrlCreateInput("4", 340, 90, 46, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group1 = GUICtrlCreateGroup("Barracks", 210, 130, 185, 125)
$lblBarrack1 = GUICtrlCreateLabel("Barrack 1:", 220, 153, 53, 17)
$lblBarrack2 = GUICtrlCreateLabel("Barrack 2:", 220, 178, 53, 17)
$lblBarrack3 = GUICtrlCreateLabel("Barrack 3:", 220, 203, 53, 17)
$lblBarrack4 = GUICtrlCreateLabel("Barrack 4:", 220, 228, 53, 17)
$cmbBarrack1 = GUICtrlCreateCombo("", 275, 150, 110, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarians|Archers|Giants|Goblins", "Barbarians")
$cmbBarrack2 = GUICtrlCreateCombo("", 275, 175, 110, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarians|Archers|Giants|Goblins", "Barbarians")
$cmbBarrack3 = GUICtrlCreateCombo("", 275, 200, 110, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarians|Archers|Giants|Goblins", "Archers")
$cmbBarrack4 = GUICtrlCreateCombo("", 275, 225, 110, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Barbarians|Archers|Giants|Goblins", "Archers")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$BarrackSettings = GUICtrlCreateGroup("Barrack Settings", 20, 255, 375, 100)
$btnLocateBarracks = GUICtrlCreateButton("Locate Barracks Manually", 30, 320, 355, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreateTabItem("")
$statLog = _GUICtrlStatusBar_Create($frmBot)
_GUICtrlStatusBar_SetSimple($statLog)
_GUICtrlStatusBar_SetText($statLog, "Status : Idle")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
;---------------------------------------------------
#Region #####Global Variables#####
   Global $version = "Pre-Alpha v004.2"
   Global $config = @ScriptDir & "\config.ini"
   Global $Restart = False
   Global $RunState = False
   ;---------------------------------------------------------------------------------------------------
   Global $BSpos[2] ; Inside BlueStacks positions relative to the screen
   Global $CtrlHandle ; BlueStacks control handle
   ;---------------------------------------------------------------------------------------------------
;Search Settings
   Global $searchGold, $searchElixir, $searchDark, $searchTrophy ;Resources of bases when searching
   Global $MinGold, $MinElixir, $MinDark, $MinTrophy ; Minimum Resources conditions
   Global $chkConditions[3] ;Conditions (meet gold...)

   Global $SearchCount = 0 ;Number of searches
;Attack Settings
   Global $fullArmy ;Check for full army or not
   Global $deploySettings ;Method of deploy found in attack settings
;Donate Settings
;Troop Settings
   Global $barrackPos[4][2] ;Positions of each barracks
   Global $barrackTroop[4] ;Barrack troop set

   ;Apply the configs------------------------------
   If FileExists($config) Then
	  readConfig()
	  applyConfig()
   EndIf
#EndRegion #####End Global Variables#####
;---------------------------------------------------
#Region ### Button Section ###
   While 1
	  $nMsg = GUIGetMsg()
	  Switch $nMsg
	  Case $GUI_EVENT_CLOSE
		 Exit
		 SaveConfig()
	  Case $btnStart ;Starts the bot--------------------------------------------------
		 SaveConfig()
		 ReadConfig()
		 ApplyConfig()
		 _GUICtrlEdit_SetText($txtLog, "")
		 If WinExists("BlueStacks App Player") Then
			If IsArray(ControlGetPos("BlueStacks App Player", "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")) Then
			   Local $BSsize = [ControlGetPos("BlueStacks App Player", "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")[2], ControlGetPos("BlueStacks App Player", "_ctl.Window", "[CLASS:BlueStacksApp; INSTANCE:1]")[3]]
			   If $BSsize[0] <> 860 Or $BSsize[1] <> 720 Then
				  SetLog("BlueStacks is not set to 860x720!")
				  SetLog("Download the '860x720.reg' file and run it, restart BlueStacks")
				  SetLog("Download the '860x720.reg' here: http://ge.tt/6Twq4O72")
			   Else
				  SetLog("~~~~Welcome to COC Bot " & $version & "!~~~~")
				  SetLog("Bot is starting...")

				  GUICtrlSetState($btnStart, $GUI_DISABLE)
				  GUICtrlSetState($btnLocateBarracks, $GUI_DISABLE)
				  GUICtrlSetState($btnSearchMode, $GUI_DISABLE)

				  GUICtrlSetState($btnStop, $GUI_ENABLE)

				  If _Sleep(2000) Then ExitLoop
				  $RunState = True
				  runBot()
			   EndIf
			Else
			   SetLog("Not in Game!")
			EndIf
		 Else
			SetLog("BlueStacks was not found!")
		 EndIf
	  Case $btnLocateBarracks
		 ZoomOut()
		 LocateBarrack()
	  Case $btnSearchMode
		 GUICtrlSetState($btnStart, $GUI_DISABLE)
		 GUICtrlSetState($btnLocateBarracks, $GUI_DISABLE)
		 GUICtrlSetState($btnSearchMode, $GUI_DISABLE)
		 GUICtrlSetState($btnStop, $GUI_ENABLE)

		 $RunState = True
		 VillageSearch()
		 $RunState = False

		 GUICtrlSetState($btnStart, $GUI_ENABLE)
		 GUICtrlSetState($btnLocateBarracks, $GUI_ENABLE)
		 GUICtrlSetState($btnSearchMode, $GUI_ENABLE)
		 GUICtrlSetState($btnStop, $GUI_DISABLE)
	  EndSwitch
   WEnd
#EndRegion ### End Button Section
;---------------------------------------------------
#Region ### General Functions ###
   Func runBot() ;Bot that runs everything in order
	  While 1
		 $Restart = False
		 checkMainScreen()
		 If _Sleep(1000) Or $RunState = False Then ExitLoop
		 ZoomOut()
		 If _Sleep(1000) Or $RunState = False Then ExitLoop
		 Train()
		 If _Sleep(1000) Or $RunState = False Then ExitLoop
		 Idle()
		 If _Sleep(1000) Or $RunState = False Then ExitLoop
		 AttackMain()
		 If _Sleep(1000) Or $RunState = False Then ExitLoop
	  WEnd
   EndFunc

   Func Idle() ;Sequence that runs until Full Army
	  While 1
		 If $fullArmy = False Then
			SetLog("~~~Waiting for full army~~~")
			While $fullArmy = False
			   checkMainScreen()
			   If _Sleep(1000) Or $RunState = False Then ExitLoop(2)
			   ZoomOut()
			   If _Sleep(1000) Or $RunState = False Then ExitLoop(2)
;~ 			   Collect()											;Collect too buggy to be used
;~ 			   If _Sleep(1000) Or $RunState = False Then ExitLoop(2)
			   Train()
			   If _Sleep(30000) Or $RunState = False Then ExitLoop(2)
			WEnd
		 EndIf
		 ExitLoop
	  WEnd
   EndFunc

   Func checkMainScreen() ;Checks if in main screen
	  getBSPos()
	  If _ColorCheckVariation(Hex(PixelGetColor($BSpos[0] + 284, $BSpos[1] + 28), 6), Hex(0x41B1CD, 6)) = False Then
		 While 1
			SetLog("Not in main screen, Restarting BlueStacks...")

			ProcessClose("HD-Frontend.exe")
			If _Sleep(1000) Or $RunState = False Then ExitLoop

			Local $ProgramFileDir
			Switch @OSArch
			   Case "X86"
				  $ProgramFileDir = "Program Files"
			   Case "X64"
				  $ProgramFileDir = "Program Files (x86)"
			EndSwitch

			If FileExists(@HomeDrive & "\" & $ProgramFileDir & "\BlueStacks\HD-RunApp.exe") Then
			   Run(@HomeDrive & "\" & $ProgramFileDir & "\BlueStacks\HD-RunApp.exe -p com.supercell.clashofclans -a com.supercell.clashofclans.GameApp")
			Else
			   SetLog("Could not automatically load Clash Of Clans")
			   SetLog("Try and open Clash Of Clans Manually")
			EndIf

			If _Sleep(2000) or $RunState = False Then ExitLoop
			SetLog("Waiting for Clash Of Clans to Load")

			Local $counter = 0

			While 1
			   If _Sleep(2000) or $RunState = False Then ExitLoop(2)
			   If WinExists("BlueStacks App Player") Then
				  getBSPos()
				  If _ColorCheckVariation(Hex(PixelGetColor($BSpos[0] + 284, $BSpos[1] + 28), 6), Hex(0x41B1CD, 6)) Then
					 Exitloop(2)
				  EndIf
			   EndIf
			   $counter += 1

			   If $counter >= 50 Then
				  SetLog("Could not automatically load Clash Of Clans")
				  checkMainScreen()
				  ExitLoop(2)
			   EndIf
			WEnd
		 WEnd
	  EndIf
   EndFunc

   Func checkNextButton() ;Checks for Out of Sync or Connection Lost errors
	  getBSpos()
	  Local $Color1 = PixelGetColor($BSpos[0] + 737, $BSpos[1] + 491) ;0xEEA828
	  Local $Color2 = PixelGetColor($BSpos[0] + 740, $BSpos[1] + 514) ;0xD84C00

	  If _ColorCheckVariation(Hex($Color1, 6), Hex(0xEEA828, 6), 10) And _ColorCheckVariation(Hex($Color2, 6), Hex(0xD84C00, 6), 10) Then
		 Return True
	  Else
		 Return False
	  EndIf
   EndFunc

   Func ZoomOut() ;Zooms out
	  SetLog("Zooming Out")
	  Local $i = 0
	  While 1
		 getBSPos()
		 If _Sleep(500) Then ExitLoop
		 If PixelGetColor($BSpos[0]+1, $BSpos[1]+1) = 0x000000 And PixelGetColor($BSpos[0]+850, $BSpos[1]+1) = 0x000000 Then
			SetLog("Zoom Out Complete")
			ExitLoop
		 Else
			ControlSend("BlueStacks App Player", "", "", "{DOWN}", 0)
			$i += 1
			If $i = 20 Then
			   SetLog("Zoom Out Complete")
			   ExitLoop
			EndIf
		 EndIf
	  WEnd
   EndFunc
#EndRegion ### End General Functions ###
;---------------------------------------------------
#Region ### Attack Functions ###
   Func AttackMain() ;Main control for attack functions
	  While 1
		 PrepareSearch()
		 If _Sleep(1000) Or $RunState = False Then ExitLoop
		 VillageSearch()
		 If _Sleep(1000) Or $RunState = False Or $Restart Then ExitLoop

SetLog("This version of the bot does not have an attack algorithm") ;Temporary
$RunState = False													;Temporary
GUICtrlSetState($btnStart, $GUI_ENABLE)								;Temporary
GUICtrlSetState($btnLocateBarracks, $GUI_ENABLE)					;Temporary
GUICtrlSetState($btnStop, $GUI_DISABLE)								;Temporary
SetLog("Bot has stopped")											;Temporary

		 ;Attack()
		 If _Sleep(1000) Or $RunState = False Then ExitLoop
		 ;ReturnMainScreen()
		 ExitLoop
	  WEnd
   EndFunc

   Func VillageSearch()
	  While 1
		 SetLog("===============Searching For Base===============")
		 $SearchCount = 0
		 While 1
			If _Sleep(1000) Or $RunState = False Then ExitLoop(2)

			GetResources() ;Reads Resource Values

			If $Restart = True Then ExitLoop(2)

			If CompareResources() Then
			   ExitLoop
			Else
			   Click(750, 500) ;Click Next
			EndIf
		 WEnd

		 SetLog("===============Searching Complete===============")
		 ExitLoop
	  WEnd
   EndFunc

   Func GetResources() ;Reads resources
	  While 1
		 Local $i = 0
		 While getGold($BSpos[0] + 51, $BSpos[1] + 66) = "" ; Loops until gold is readable
			getBSPos()
			If _Sleep(500) Or $RunState = False Then ExitLoop(2)
			$i += 1
			If $i >= 20 Then ; If gold cannot be read by 10 seconds
			   If checkNextButton() Then ;Checks for Out of Sync or Connection Error during search
				  Click(750, 500) ;Click Next
			   Else
				  SetLog("Cannot locate Next button, Restarting Bot")
				  checkMainScreen()
				  $Restart = True
				  ExitLoop(2)
			   EndIf
			   $i = 0
			EndIf
		 WEnd

		 $searchGold = getGold($BSpos[0] + 51, $BSpos[1] + 66)
		 $searchElixir = getElixir($BSpos[0] + 51, $BSpos[1] + 66 + 29)
		 $searchTrophy = getTrophy($BSpos[0] + 51, $BSpos[1] + 66 + 90)

		 If $searchTrophy <> "" Then
			$searchDark = getDarkElixir($BSpos[0] + 51, $BSpos[01] + 66 + 57)
		 Else
			$searchDark = 0
			$searchTrophy = getTrophy($BSpos[0] + 51, $BSpos[1] + 66 + 60)
		 EndIf

		 SetLog("(" & $SearchCount+1 & ") [G]: " & $searchGold & Tab($searchGold,12) & "[E]: " & $searchElixir & Tab($searchElixir,12) & "[D]: " & $searchDark & Tab($searchDark,12) & "[T]: " & $searchTrophy)
		 $SearchCount += 1 ; Counter for number of searches
		 ExitLoop
	  WEnd
   EndFunc

   Func CompareResources() ;Compares resources and returns true if conditions meet, otherwise returns false
	  Local $G = (Number($searchGold) >= Number($MinGold)), $E = (Number($searchElixir) >= Number($MinElixir)), $D = (Number($searchDark) >= Number($MinDark)), $T = (Number($searchTrophy) >= Number($MinTrophy))
	  Local $Boolean = False

	  If $G Or $E Then $Boolean = True

	  If $chkConditions[0] = 1 Then
		 If $G = False Or $E = False Then $Boolean = False
		 Return $Boolean
	  EndIf

	  If $chkConditions[1] = 1 Then
		 If $D = False Then $Boolean = False
		 Return $Boolean
	  EndIf

	  If $chkConditions[2] = 1 Then
		 If $T = False Then $Boolean = False
		 Return $Boolean
	  EndIf

	  Return $Boolean
   EndFunc

   Func PrepareSearch() ;Click attack button and find match button, will break shield
	  SetLog("Preparing to search")
	  While 1
		 Click(60, 614);Click Attack Button
		 If _Sleep(1000) Or $RunState = False Then ExitLoop
		 Click(217, 510);Click Find a Match Button
		 If _Sleep(1000) Or $RunState = False Then ExitLoop
		 If _ColorCheckVariation(Hex(PixelGetColor(513 + $BSpos[0], 416 + $BSpos[1]), 6), Hex(0x5DAC10, 6), 20) Then
			Click(513, 416);Click Okay To Break Shield
		 EndIf
		 ExitLoop
	  WEnd
   EndFunc
#EndRegion ### End Attack Functions ###
;---------------------------------------------------
#Region ### Troops Settings ###
   Func LocateBarrack()
	  SetLog("Locating Barracks...")
	  Local $MsgBox
	  While 1
		 While 1
			$MsgBox = MsgBox(6+262144, "Locate first barrack", "Click Continue then click on your first barrack. Cancel if not available. Try again to start over.", 0, $frmBot)
			If $MsgBox = 11 Then
				  $barrackPos[0][0] = FindPos()[0]
				  $barrackPos[0][1] = FindPos()[1]
			ElseIf $MsgBox = 10 Then
			   ExitLoop
			EndIf

			$MsgBox = MsgBox(6+262144, "Locate second barrack", "Click Continue then click on your second barrack. Cancel if not available. Try again to start over.", 0, $frmBot)
			If $MsgBox = 11 Then
			   $barrackPos[1][0] = FindPos()[0]
			   $barrackPos[1][1] = FindPos()[1]
			ElseIf $MsgBox = 10 Then
			   ExitLoop
			EndIf

			$MsgBox = MsgBox(6+262144, "Locate third barrack", "Click Continue then click on your third barrack. Cancel if not available. Try again to start over.", 0, $frmBot)
			If $MsgBox = 11 Then
			   $barrackPos[2][0] = FindPos()[0]
			   $barrackPos[2][1] = FindPos()[1]
			ElseIf $MsgBox = 10 Then
			   ExitLoop
			EndIf

			$MsgBox = MsgBox(6+262144, "Locate fourth barrack", "Click Continue then click on your fourth barrack. Cancel if not available. Try again to start over.", 0, $frmBot)
			If $MsgBox = 11 Then
			   $barrackPos[3][0] = FindPos()[0]
			   $barrackPos[3][1] = FindPos()[1]
			ElseIf $MsgBox = 10 Then
			   ExitLoop
			EndIf
			ExitLoop(2)
		 WEnd
	  WEnd
	  SaveConfig()
	  SetLog("-Locating Complete-")
	  SetLog("-Barrack 1 = " & "(" & $barrackPos[0][0] & "," & $barrackPos[0][1] & ")")
	  SetLog("-Barrack 2 = " & "(" & $barrackPos[1][0] & "," & $barrackPos[1][1] & ")")
	  SetLog("-Barrack 3 = " & "(" & $barrackPos[2][0] & "," & $barrackPos[2][1] & ")")
	  SetLog("-Barrack 4 = " & "(" & $barrackPos[3][0] & "," & $barrackPos[3][1] & ")")
   EndFunc

   Func Train()
		 If $barrackPos[0][0] = "" Then
			LocateBarrack()
			SaveConfig()
			If _Sleep(2000) Then Return
		 EndIf
		 SetLog("Training Troops...")

		 While 1
			For $i = 0 to 3
			   If _Sleep(1000) Or $RunState = False Then ExitLoop(2)
			   getBSPos()

			   Click(1, 1) ;Click Away

			   If _Sleep(500) Or $RunState = False Then ExitLoop(2)

			   Click($barrackPos[$i][0], $barrackPos[$i][1]) ;Click Barrack

			   If _Sleep(1000) Or $RunState = False Then ExitLoop(2)

			   Local $TrainPos = PixelSearch($BSpos[0] + 155, $BSpos[1] + 557, $BSpos[0] + 694, $BSpos[1] + 642, 0x687DA1, 5) ;Finds Train Troops button
			   If IsArray($TrainPos) = False Then
				  SetLog("Could not locate Train Troops button")

				  If _Sleep(1000) Or $RunState = False Then ExitLoop(2)

				  $RunState = False
				  GUICtrlSetState($btnStart, $GUI_ENABLE)
				  GUICtrlSetState($btnStop, $GUI_DISABLE)
				  SetLog("Bot has stopped")
				  ExitLoop(2)
			   Else
				  Click($TrainPos[0] - $BSpos[0], $TrainPos[1] - $BSpos[1]) ;Click Train Troops button
				  If _Sleep(1000) Or $RunState = False Then ExitLoop(2)

				  CheckFullArmy()

				  Switch $barrackTroop[$i]
				  Case 0
					 Click(220, 320, 75, 1) ;Barbarian
				  Case 1
					 Click(331, 320, 75, 1) ;Archer
				  Case 2
					 Click(432, 320, 15, 1) ;Giant
				  Case 3
					 Click(546, 320, 75, 1) ;Goblins
				  EndSwitch
			   EndIf
			   If _Sleep(500) Or $RunState = False Then ExitLoop(2)
			   Click(1, 1, 2, 500); Click away twice with 500ms delay
			Next

			SetLog("Training Troops Complete")
			ExitLoop
		 WEnd
   EndFunc

   Func CheckFullArmy()
	  $Pixel = _ColorCheckVariation(Hex(PixelGetColor(327 + $BSpos[0], 520 + $BSpos[1]),6), Hex(0xD03838,6),20)
	  If $Pixel Then
		 $fullArmy = True
	  Else
		 $fullArmy = False
	  EndIf
   EndFunc
#EndRegion ### End Troops Settings ###
;---------------------------------------------------
#Region ### Village Functions ###
;~    Func Collect()
;~ 	  While 1
;~ 		 SetLog("Collecting Resources")
;~ 		 Local $Collector = PixelSearch($BSpos[0], $BSpos[1], $BSpos[0] + 860, $BSpos[1] + 720, 0xB0B875, 1, 1)
;~ 		 If _Sleep(300) Then ExitLoop
;~ 		 While IsArray($Collector)
;~ 			Click($Collector[0] - $BSpos[0], $Collector[1] - $BSpos[1])
;~ 			If _Sleep(300) Then ExitLoop(2)
;~ 			$Collector = PixelSearch($BSpos[0], $BSpos[1], $BSpos[0] + 860, $BSpos[1] + 720, 0xB0B875, 1, 1)
;~ 		 WEnd
;~ 		 SetLog("Collecting Complete")
;~ 		 ExitLoop
;~ 	  WEnd
;~    EndFunc
#EndRegion ### End Village Functions ###
;---------------------------------------------------
#Region ### Other Functions ###
   Func ReadConfig() ;Reads config and sets it to the variables
	  If FileExists($config) Then
;Search Settings------------------------------------------------------------------------
		 $MinGold = IniRead($config, "search", "searchGold", "0")
		 $MinElixir = IniRead($config, "search", "searchElixir", "0")
		 $MinDark = IniRead($config, "search", "searchDark", "0")
		 $MinTrophy = IniRead($config, "search", "searchTrophy", "0")

		 $chkConditions[0] = IniRead($config, "search", "conditionGoldElixir", "0")
		 $chkConditions[1] = IniRead($config, "search", "conditionDark", "0")
		 $chkConditions[2] = IniRead($config, "search", "conditionTrophy", "0")
;Attack Settings-------------------------------------------------------------------------
		 $deploySettings = IniRead($config, "attack", "deploy", "0")
;Donate Settings-------------------------------------------------------------------------

;Troop Settings--------------------------------------------------------------------------
		 For $i = 0 to 3 ;Covers all 4 Barracks
			$barrackPos[$i][0] = IniRead($config, "troop", "xBarrack" & $i+1, "0")
			$barrackPos[$i][1] = IniRead($config, "troop", "yBarrack" & $i+1, "0")
			$barrackTroop[$i] = IniRead($config, "troop", "troop" & $i+1, "0")
		 Next
	  Else
		 Return False
	  EndIf
   EndFunc

   Func applyConfig() ;Applies the data from config to the controls in GUI
;Search Settings------------------------------------------------------------------------
	  GuiCtrlSetData($txtMinGold, $MinGold)
	  GuiCtrlSetData($txtMinElixir, $MinElixir)
	  GuiCtrlSetData($txtMinDarkElixir, $MinDark)
	  GuiCtrlSetData($txtMinTrophy, $MinTrophy)

	  If $chkConditions[0] = 1 Then
		 GuiCtrlSetState($chkMeetGxE, $GUI_CHECKED)
	  ElseIf $chkConditions[0] = 0 Then
		 GuiCtrlSetState($chkMeetGxE, $GUI_UNCHECKED)
	  EndIf

	  If $chkConditions[1] = 1 Then
		 GuiCtrlSetState($chkMeetDE, $GUI_CHECKED)
	  ElseIf $chkConditions[1] = 0 Then
		 GuiCtrlSetState($chkMeetDE, $GUI_UNCHECKED)
	  EndIf

	  If $chkConditions[2] = 1 Then
		 GuiCtrlSetState($chkMeetTrophy, $GUI_CHECKED)
	  ElseIf $chkConditions[2] = 0 Then
		 GuiCtrlSetState($chkMeetTrophy, $GUI_UNCHECKED)
	  EndIf
;Attack Settings-------------------------------------------------------------------------
	  _GUICtrlComboBox_SetCurSel($cmbDeploy, $deploySettings)
;Donate Settings-------------------------------------------------------------------------

;Troop Settings--------------------------------------------------------------------------
	  _GUICtrlComboBox_SetCurSel($cmbBarrack1, $barrackTroop[0])
	  _GUICtrlComboBox_SetCurSel($cmbBarrack2, $barrackTroop[1])
	  _GUICtrlComboBox_SetCurSel($cmbBarrack3, $barrackTroop[2])
	  _GUICtrlComboBox_SetCurSel($cmbBarrack4, $barrackTroop[3])
   EndFunc

   Func SaveConfig() ;Saves the controls settings to the config
;Search Settings------------------------------------------------------------------------
		 IniWrite($config, "search", "searchGold", GUICtrlRead($txtMinGold))
		 IniWrite($config, "search", "searchElixir", GUICtrlRead($txtMinElixir))
		 IniWrite($config, "search", "searchDark", GUICtrlRead($txtMinDarkElixir))
		 IniWrite($config, "search", "searchTrophy", GUICtrlRead($txtMinTrophy))

		 If GUICtrlRead($chkMeetGxE) = $GUI_CHECKED Then
			IniWrite($config, "search", "conditionGoldElixir", 1)
		 Else
			IniWrite($config, "search", "conditionGoldElixir", 0)
		 EndIf

		 If GUICtrlRead($chkMeetDE) = $GUI_CHECKED Then
			IniWrite($config, "search", "conditionDark", 1)
		 Else
			IniWrite($config, "search", "conditionDark", 0)
		 EndIf

		 If GUICtrlRead($chkMeetTrophy) = $GUI_CHECKED Then
			IniWrite($config, "search", "conditionTrophy", 1)
		 Else
			IniWrite($config, "search", "conditionTrophy", 0)
		 EndIf
;Attack Settings-------------------------------------------------------------------------
		 IniWrite($config, "attack", "deploy",  _GUICtrlComboBox_GetCurSel($cmbDeploy))
;Donate Settings-------------------------------------------------------------------------

;Troop Settings--------------------------------------------------------------------------
		 IniWrite($config, "troop", "troop1",  _GUICtrlComboBox_GetCurSel($cmbBarrack1))
		 IniWrite($config, "troop", "troop2",  _GUICtrlComboBox_GetCurSel($cmbBarrack2))
		 IniWrite($config, "troop", "troop3",  _GUICtrlComboBox_GetCurSel($cmbBarrack3))
		 IniWrite($config, "troop", "troop4",  _GUICtrlComboBox_GetCurSel($cmbBarrack4))
		 For $i = 0 to 3 ;Covers all 4 Barracks
			IniWrite($config, "troop", "xBarrack" & $i+1, $barrackPos[$i][0])
			IniWrite($config, "troop", "yBarrack" & $i+1, $barrackPos[$i][1])
		 Next
   EndFunc
;========================================================================================
   Func SetLog($string) ;Sets the text for the log
	  _GUICtrlEdit_AppendText($txtLog, Time() & $string & @CRLF)
	  _GUICtrlStatusBar_SetText($statLog, "Status : " & $string)
   EndFunc

   Func Time() ;Gives the time in '[00:00:00 AM/PM]' format
	  Return "[" & _NowTime(3) & "] "
   EndFunc

   Func getBSPos()
	  $aPos = ControlGetPos("BlueStacks App Player", "", "[CLASS:BlueStacksApp; INSTANCE:1]")
	  $tPoint = DllStructCreate("int X;int Y")
	  DllStructSetData($tpoint, "X", $aPos[0])
	  DllStructSetData($tpoint, "Y", $aPos[1])
	  _WinAPI_ClientToScreen(WinGetHandle(WinGetTitle("BlueStacks App Player")), $tPoint)

	  $BSpos[0] = DllStructGetData($tpoint, "X")
	  $BSpos[1] = DllStructGetData($tpoint, "Y")

	  $CtrlHandle = ControlGetHandle("BlueStacks App Player", "", "BlueStacksApp1")
   EndFunc

Func _Sleep($iDelay)
   $iBegin = TimerInit()
	  While TimerDiff($iBegin) < $iDelay
		 Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
			   Exit
			   SaveConfig()
			Case $btnStop
			   $RunState = False
			   GUICtrlSetState($btnStart, $GUI_ENABLE)
			   GUICtrlSetState($btnLocateBarracks, $GUI_ENABLE)
			   GUICtrlSetState($btnSearchMode, $GUI_ENABLE)

			   GUICtrlSetState($btnStop, $GUI_DISABLE)
			   SetLog("Bot has stopped")
			   Return True
		 EndSwitch
	  WEnd
   Return False
EndFunc

Func Click($x, $y, $times = 1, $speed = 0)
   If $times <> 1 Then
	  For $i = 0 To ($times - 1)
		 ControlClick("BlueStacks App Player", "", "", "left", "1", $x, $y)
		 If _Sleep($speed) Or $RunState = False Then ExitLoop
	  Next
   Else
	  ControlClick("BlueStacks App Player", "", "", "left", "1", $x, $y)
   EndIf
EndFunc

Func FindPos()
   Local $Pos[2]
   While 1
	  If _IsPressed("01") Then
		 $Pos[0] = MouseGetPos()[0] - $BSpos[0]
		 $Pos[1] = MouseGetPos()[1] - $BSpos[1]
		 Return $Pos
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
#EndRegion ### End Other Functions ###
;---------------------------------------------------
#Region ### Get Resources Functions ###
;==============================================================================================================
;===Main Function==============================================================================================
;--------------------------------------------------------------------------------------------------------------
;Checks if the color components exceed $sVari and returns true if they are below $sVari.
;--------------------------------------------------------------------------------------------------------------

Func getGold($x_start, $y_start)
   Global $hDll = DllOpen("gdi32.dll")
   Global $vDC = _PixelGetColor_CreateDC($hDll)
   _PixelGetColor_CaptureRegion($vDC, 0, 0, $x_start + 90, $y_start + 20)
   ;-----------------------------------------------------------------------------
   Local $x = $x_start, $y = $y_start
   Local $Gold, $i = 0
   While getDigit($x, $y + $i, "Gold") = ""
	  If $i >= 15 Then ExitLoop
	  $i += 1
   WEnd
   $x = $x_start
   $Gold &= getDigit($x, $y + $i, "Gold")
   $Gold &= getDigit($x, $y + $i, "Gold")
   $Gold &= getDigit($x, $y + $i, "Gold")
   $x += 6
   $Gold &= getDigit($x, $y + $i, "Gold")
   $Gold &= getDigit($x, $y + $i, "Gold")
   $Gold &= getDigit($x, $y + $i, "Gold")
   Return $Gold
EndFunc

Func getElixir($x_start, $y_start)
   Global $hDll = DllOpen("gdi32.dll")
   Global $vDC = _PixelGetColor_CreateDC($hDll)
   _PixelGetColor_CaptureRegion($vDC, 0, 0, $x_start + 90, $y_start + 20)
   ;-----------------------------------------------------------------------------
   Local $x = $x_start, $y = $y_start
   Local $Elixir, $i = 0
   While getDigit($x, $y + $i, "Elixir") = ""
	  If $i >= 15 Then ExitLoop
	  $i += 1
   WEnd
   $x = $x_start
   $Elixir &= getDigit($x, $y + $i, "Elixir")
   $Elixir &= getDigit($x, $y + $i, "Elixir")
   $Elixir &= getDigit($x, $y + $i, "Elixir")
   $x += 6
   $Elixir &= getDigit($x, $y + $i, "Elixir")
   $Elixir &= getDigit($x, $y + $i, "Elixir")
   $Elixir &= getDigit($x, $y + $i, "Elixir")
   Return $Elixir
EndFunc

Func getDarkElixir($x_start, $y_start)
	Global $hDll = DllOpen("gdi32.dll")
	Global $vDC = _PixelGetColor_CreateDC($hDll)
	_PixelGetColor_CaptureRegion($vDC, 0, 0, $x_start + 90, $y_start + 20)
	;-----------------------------------------------------------------------------
	Local $x = $x_start, $y = $y_start
	Local $DarkElixir, $i = 0
    While getDigit($x, $y + $i, "DarkElixir") = ""
	   If $i >= 15 Then ExitLoop
	   $i += 1
    WEnd
    $x = $x_start
	$DarkElixir &= getDigit($x, $y + $i, "DarkElixir")
	$DarkElixir &= getDigit($x, $y + $i, "DarkElixir")
	$DarkElixir &= getDigit($x, $y + $i, "DarkElixir")
	$x += 6
	$DarkElixir &= getDigit($x, $y + $i, "DarkElixir")
	$DarkElixir &= getDigit($x, $y + $i, "DarkElixir")
	$DarkElixir &= getDigit($x, $y + $i, "DarkElixir")
	Return $DarkElixir
EndFunc

Func getTrophy($x_start, $y_start)
	Global $hDll = DllOpen("gdi32.dll")
	Global $vDC = _PixelGetColor_CreateDC($hDll)
	_PixelGetColor_CaptureRegion($vDC, 0, 0, $x_start + 90, $y_start + 20)
	;-----------------------------------------------------------------------------
	Local $x = $x_start, $y = $y_start
	Local $Trophy, $i = 0
    While getDigit($x, $y + $i, "Trophy") = ""
	   If $i >= 15 Then ExitLoop
	   $i += 1
    WEnd
    $x = $x_start
	$Trophy &= getDigit($x, $y + $i, "Trophy")
	$Trophy &= getDigit($x, $y + $i, "Trophy")
	Return $Trophy
EndFunc

;==============================================================================================================
;==============================================================================================================
;===Color Variation============================================================================================
;--------------------------------------------------------------------------------------------------------------
;Checks if the color components exceed $sVari and returns true if they are below $sVari.
;--------------------------------------------------------------------------------------------------------------

Func _ColorCheckVariation($nColor1, $nColor2, $sVari=5)
	$Red1 = Dec(StringMid(String($nColor1), 1, 2))
	$Blue1 = Dec(StringMid(String($nColor1), 3, 2))
	$Green1 = Dec(StringMid(String($nColor1), 5, 2))

	$Red2 = Dec(StringMid(String($nColor2), 1, 2))
	$Blue2 = Dec(StringMid(String($nColor2), 3, 2))
	$Green2 = Dec(StringMid(String($nColor2), 5, 2))

	If abs($Blue1 - $Blue2) > $sVari Then Return False
	If abs($Green1 - $Green2) > $sVari Then Return False
	If abs($Red1 - $Red2) > $sVari Then Return False
	Return True
EndFunc

;==============================================================================================================
;===Check Pixels===============================================================================================
;--------------------------------------------------------------------------------------------------------------
;Using _ColorCheckVariation, checks compares multiple pixels and returns true if they all pass _ColorCheckVariation.
;--------------------------------------------------------------------------------------------------------------

Func boolPixelSearch($pixel1, $pixel2, $pixel3)
	Local $Color1 = _PixelGetColor_GetPixel($vDC, $pixel1[0], $pixel1[1])
	Local $Color2 =	_PixelGetColor_GetPixel($vDC, $pixel2[0], $pixel2[1])
	Local $Color3 = _PixelGetColor_GetPixel($vDC, $pixel3[0], $pixel3[1])
	If _ColorCheckVariation($Color1, $pixel1[2], 10) And _ColorCheckVariation($Color2, $pixel2[2], 10) And _ColorCheckVariation($Color3, $pixel3[2], 10) Then Return True
	Return False
EndFunc

;==============================================================================================================
;===Get Digit Gold=============================================================================================
;--------------------------------------------------------------------------------------------------------------
;Finds pixel color pattern of specific X and Y values, returns digit if pixel color pattern found.
;--------------------------------------------------------------------------------------------------------------

Func getDigit(ByRef $x, $y, $type)
	Local $width = 0

	;Search for digit 0
	$width = 13
	Select
		Case $type = "Gold"
			Local $c1 = Hex(0x989579, 6), 	$c2 = Hex(0x39382E, 6), $c3 = Hex(0x272720, 6)
		Case $type = "Elixir"
			Local $c1 = Hex(0x978A96, 6), 	$c2 = Hex(0x393439, 6), $c3 = Hex(0x272427, 6)
		Case $type = "DarkElixir"
			Local $c1 = Hex(0x909090, 6), 	$c2 = Hex(0x363636, 6), $c3 = Hex(0x262626, 6)
		Case $type = "Trophy"
			Local $c1 = Hex(0x979797, 6), 	$c2 = Hex(0x393939, 6), $c3 = Hex(0x272727, 6)
	EndSelect
	Local $pixel1[3] = [$x+6, $y+4, $c1], $pixel2[3] = [$x+7, $y+7, $c2], $pixel3[3] = [$x+10, $y+13, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
	  $x += $width ;Adds to x coordinate to get the next digit
	  Return 0
	Else
	  $x -= 1 ;Solves the problem when the spaces between the middle goes from 6 to 5 pixels
	  Local $pixel1[3] = [$x+6, $y+4, $c1], $pixel2[3] = [$x+7, $y+7, $c2], $pixel3[3] = [$x+10, $y+13, $c3]
	  If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
		 $x += $width ;Changes x coordinate for the next digit.
		 Return 0
	  Else
		 $x += 2 ;Solves the problem when there is 1 pixel space between a set of numbers
		 Local $pixel1[3] = [$x+6, $y+4, $c1], $pixel2[3] = [$x+7, $y+7, $c2], $pixel3[3] = [$x+10, $y+13, $c3]
		 If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
			$x += $width
			Return 0
		 Else
			$x -= 1
		 EndIf
	  EndIf
	EndIf

	;Search for digit 1
	$width = 6
	Select
		Case $type = "Gold"
			Local $c1 = Hex(0x979478, 6), 	$c2 = Hex(0x313127, 6), $c3 = Hex(0xD7D4AC, 6)
		Case $type = "Elixir"
			Local $c1 = Hex(0x968895, 6), 	$c2 = Hex(0x312D31, 6), $c3 = Hex(0xD8C4D6, 6)
		Case $type = "DarkElixir"
			Local $c1 = Hex(0x8F8F8F, 6), 	$c2 = Hex(0x2F2F2F, 6), $c3 = Hex(0xCDCDCD, 6)
		Case $type = "Trophy"
			Local $c1 = Hex(0x969696, 6), 	$c2 = Hex(0x313131, 6), $c3 = Hex(0xD8D8D8, 6)
	EndSelect
	Local $pixel1[3] = [$x+1, $y+1, $c1], $pixel2[3] = [$x+1, $y+12, $c2], $pixel3[3] = [$x+4, $y+12, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
	  $x += $width
	  Return 1
	Else
	  $x -= 1
	  Local $pixel1[3] = [$x+1, $y+1, $c1], $pixel2[3] = [$x+1, $y+12, $c2], $pixel3[3] = [$x+4, $y+12, $c3]
	  If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
		 $x += $width
		 Return 1
	  Else
		 $x += 2
		 Local $pixel1[3] = [$x+1, $y+1, $c1], $pixel2[3] = [$x+1, $y+12, $c2], $pixel3[3] = [$x+4, $y+12, $c3]
		 If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
			$x += $width
			Return 1
		 Else
			$x -= 1
		 EndIf
	  EndIf
	EndIf

	;Search for digit 2
	$width = 10
	Select
		Case $type = "Gold"
			Local $c1 = Hex(0xA09E80, 6), 	$c2 = Hex(0xD8D4AC, 6), $c3 = Hex(0x979579, 6)
		Case $type = "Elixir"
			Local $c1 = Hex(0xA0919F, 6), 	$c2 = Hex(0xD8C4D6, 6), $c3 = Hex(0x978A96, 6)
		Case $type = "DarkElixir"
			Local $c1 = Hex(0x989898, 6), 	$c2 = Hex(0xCDCDCD, 6), $c3 = Hex(0x909090, 6)
		Case $type = "Trophy"
			Local $c1 = Hex(0xA0A0A0, 6), 	$c2 = Hex(0xD8D8D8, 6), $c3 = Hex(0x979797, 6)
	EndSelect
	Local $pixel1[3] = [$x+1, $y+7, $c1], $pixel2[3] = [$x+3, $y+6, $c2], $pixel3[3] = [$x+7, $y+7, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
	  $x += $width
	  Return 2
	Else
	  $x -= 1
	  Local $pixel1[3] = [$x+1, $y+7, $c1], $pixel2[3] = [$x+3, $y+6, $c2], $pixel3[3] = [$x+7, $y+7, $c3]
	  If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
		 $x += $width
		 Return 2
	  Else
		 $x += 2
		 Local $pixel1[3] = [$x+1, $y+7, $c1], $pixel2[3] = [$x+3, $y+6, $c2], $pixel3[3] = [$x+7, $y+7, $c3]
		 If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
			$x += $width
			Return 2
		 Else
			$x -= 1
		 EndIf
	  EndIf
	EndIf

	;Search for digit 3
	$width = 10
	Select
		Case $type = "Gold"
			Local $c1 = Hex(0x7F7D65, 6), 	$c2 = Hex(0x070706, 6), $c3 = Hex(0x37362C, 6)
		Case $type = "Elixir"
			Local $c1 = Hex(0x7F737E, 6), 	$c2 = Hex(0x070607, 6), $c3 = Hex(0x373236, 6)
		Case $type = "DarkElixir"
			Local $c1 = Hex(0x797979, 6), 	$c2 = Hex(0x070707, 6), $c3 = Hex(0x343434, 6)
		Case $type = "Trophy"
			Local $c1 = Hex(0x7F7F7F, 6), 	$c2 = Hex(0x070707, 6), $c3 = Hex(0x373737, 6)
	EndSelect
	Local $pixel1[3] = [$x+2, $y+3, $c1], $pixel2[3] = [$x+4, $y+8, $c2], $pixel3[3] = [$x+5, $y+13, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
	  $x += $width
	  Return 3
	Else
	  $x -= 1
	  Local $pixel1[3] = [$x+2, $y+3, $c1], $pixel2[3] = [$x+4, $y+8, $c2], $pixel3[3] = [$x+5, $y+13, $c3]
	  If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
		 $x += $width
		 Return 3
	  Else
		 $x += 2
		 Local $pixel1[3] = [$x+2, $y+3, $c1], $pixel2[3] = [$x+4, $y+8, $c2], $pixel3[3] = [$x+5, $y+13, $c3]
		 If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
			$x += $width
			Return 3
		 Else
			   $x -= 1
		 EndIf
	  EndIf
	EndIf

	;Search for digit 4
	$width = 12
	Select
		Case $type = "Gold"
			Local $c1 = Hex(0x282720, 6), 	$c2 = Hex(0x080806, 6), $c3 = Hex(0x403F33, 6)
		Case $type = "Elixir"
			Local $c1 = Hex(0x282428, 6), 	$c2 = Hex(0x080708, 6), $c3 = Hex(0x403A40, 6)
		Case $type = "DarkElixir"
			Local $c1 = Hex(0x262626, 6), 	$c2 = Hex(0x070707, 6), $c3 = Hex(0x3D3D3D, 6)
		Case $type = "Trophy"
			Local $c1 = Hex(0x282828, 6), 	$c2 = Hex(0x080808, 6), $c3 = Hex(0x404040, 6)
	EndSelect
	Local $pixel1[3] = [$x+2, $y+3, $c1], $pixel2[3] = [$x+3, $y+1, $c2], $pixel3[3] = [$x+1, $y+5, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
	  $x += $width
	  Return 4
	Else
	  $x -= 1
	  Local $pixel1[3] = [$x+2, $y+3, $c1], $pixel2[3] = [$x+3, $y+1, $c2], $pixel3[3] = [$x+1, $y+5, $c3]
	  If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
		 $x += $width
		 Return 4
	  Else
		 $x += 2
		 Local $pixel1[3] = [$x+2, $y+3, $c1], $pixel2[3] = [$x+3, $y+1, $c2], $pixel3[3] = [$x+1, $y+5, $c3]
		 If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
			$x += $width
			Return 4
		 Else
			$x -= 1
		 EndIf
	  EndIf
	EndIf

	;Search for digit 5
	$width = 10
	Select
		Case $type = "Gold"
			Local $c1 = Hex(0x060604, 6), 	$c2 = Hex(0x040403, 6), $c3 = Hex(0xB7B492, 6)
		Case $type = "Elixir"
			Local $c1 = Hex(0x060606, 6), 	$c2 = Hex(0x040404, 6), $c3 = Hex(0xB7A7B6, 6)
		Case $type = "DarkElixir"
			Local $c1 = Hex(0x060606, 6), 	$c2 = Hex(0x040404, 6), $c3 = Hex(0xAFAFAF, 6)
		Case $type = "Trophy"
			Local $c1 = Hex(0x060606, 6), 	$c2 = Hex(0x040404, 6), $c3 = Hex(0xB7B7B7, 6)
	EndSelect
	Local $pixel1[3] = [$x+5, $y+4, $c1], $pixel2[3] = [$x+4, $y+9, $c2], $pixel3[3] = [$x+6, $y+12, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
	  $x += $width
	  Return 5
	Else
	  $x -= 1
	  Local $pixel1[3] = [$x+5, $y+4, $c1], $pixel2[3] = [$x+4, $y+9, $c2], $pixel3[3] = [$x+6, $y+12, $c3]
	  If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
		 $x += $width
		 Return 5
	  Else
		 $x += 2
		 Local $pixel1[3] = [$x+5, $y+4, $c1], $pixel2[3] = [$x+4, $y+9, $c2], $pixel3[3] = [$x+6, $y+12, $c3]
		 If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
			$x += $width
			Return 5
		 Else
			$x -= 1
		 EndIf
	  EndIf
	EndIf

	;Search for digit 6
	$width = 11
	Select
		Case $type = "Gold"
			Local $c1 = Hex(0x070605, 6), 	$c2 = Hex(0x040403, 6), $c3 = Hex(0x181713, 6)
		Case $type = "Elixir"
			Local $c1 = Hex(0x070707, 6), 	$c2 = Hex(0x040404, 6), $c3 = Hex(0x181618, 6)
		Case $type = "DarkElixir"
			Local $c1 = Hex(0x060606, 6), 	$c2 = Hex(0x030303, 6), $c3 = Hex(0x161616, 6)
		Case $type = "Trophy"
			Local $c1 = Hex(0x070707, 6), 	$c2 = Hex(0x040404, 6), $c3 = Hex(0x181818, 6)
	EndSelect
	Local $pixel1[3] = [$x+5, $y+4, $c1], $pixel2[3] = [$x+5, $y+9, $c2], $pixel3[3] = [$x+8, $y+5, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
	  $x += $width
	  Return 6
	Else
	  $x -= 1
	  Local $pixel1[3] = [$x+5, $y+4, $c1], $pixel2[3] = [$x+5, $y+9, $c2], $pixel3[3] = [$x+8, $y+5, $c3]
	  If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
		 $x += $width
		 Return 6
	  Else
		 $x += 2
		 Local $pixel1[3] = [$x+5, $y+4, $c1], $pixel2[3] = [$x+5, $y+9, $c2], $pixel3[3] = [$x+8, $y+5, $c3]
		 If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
			$x += $width
			Return 6
		 Else
			$x -= 1
		 EndIf
	  EndIf
	EndIf

	;Search for digit 7
	$width = 10
	Select
		Case $type = "Gold"
			Local $c1 = Hex(0x5E5C4B, 6), 	$c2 = Hex(0x87856C, 6), $c3 = Hex(0x5D5C4B, 6)
		Case $type = "Elixir"
			Local $c1 = Hex(0x5F565E, 6), 	$c2 = Hex(0x877B86, 6), $c3 = Hex(0x5F565E, 6)
		Case $type = "DarkElixir"
			Local $c1 = Hex(0x5A5A5A, 6), 	$c2 = Hex(0x818181, 6), $c3 = Hex(0x5A5A5A, 6)
		Case $type = "Trophy"
			Local $c1 = Hex(0x5F5F5F, 6), 	$c2 = Hex(0x878787, 6), $c3 = Hex(0x5F5F5F, 6)
	EndSelect
	Local $pixel1[3] = [$x+5, $y+11, $c1], $pixel2[3] = [$x+4, $y+3, $c2], $pixel3[3] = [$x+7, $y+7, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
	  $x += $width
	  Return 7
	Else
	  $x -= 1
	  Local $pixel1[3] = [$x+5, $y+11, $c1], $pixel2[3] = [$x+4, $y+3, $c2], $pixel3[3] = [$x+7, $y+7, $c3]
	  If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
		 $x += $width
		 Return 7
	  Else
		 $x += 2
		 Local $pixel1[3] = [$x+5, $y+11, $c1], $pixel2[3] = [$x+4, $y+3, $c2], $pixel3[3] = [$x+7, $y+7, $c3]
		 If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
			$x += $width
			Return 7
		 Else
			$x -= 1
		 EndIf
	  EndIf
	EndIf

	;Search for digit 8
	$width = 11
	Select
		Case $type = "Gold"
			Local $c1 = Hex(0x27261F, 6), 	$c2 = Hex(0x302F26, 6), $c3 = Hex(0x26261F, 6)
		Case $type = "Elixir"
			Local $c1 = Hex(0x272427, 6), 	$c2 = Hex(0x302B2F, 6), $c3 = Hex(0x26261F, 6)
		Case $type = "DarkElixir"
			Local $c1 = Hex(0x252525, 6), 	$c2 = Hex(0x2D2D2D, 6), $c3 = Hex(0x242424, 6)
		Case $type = "Trophy"
			Local $c1 = Hex(0x272727, 6), 	$c2 = Hex(0x303030, 6), $c3 = Hex(0x262626, 6)
	EndSelect
	Local $pixel1[3] = [$x+5, $y+3, $c1], $pixel2[3] = [$x+5, $y+10, $c2], $pixel3[3] = [$x+1, $y+6, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
	  $x += $width
	  Return 8
	Else
	  $x -= 1
	  Local $pixel1[3] = [$x+5, $y+3, $c1], $pixel2[3] = [$x+5, $y+10, $c2], $pixel3[3] = [$x+1, $y+6, $c3]
	  If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
		 $x += $width
		 Return 8
	  Else
		 $x += 2
		 Local $pixel1[3] = [$x+5, $y+3, $c1], $pixel2[3] = [$x+5, $y+10, $c2], $pixel3[3] = [$x+1, $y+6, $c3]
		 If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
			$x += $width
			Return 8
		 Else
			$x -= 1
		 EndIf
	  EndIf
	EndIf

	;Search for digit 9
	$width = 11
	Select
		Case $type = "Gold"
			Local $c1 = Hex(0x302F26, 6), 	$c2 = Hex(0x050504, 6), $c3 = Hex(0x272720, 6)
		Case $type = "Elixir"
			Local $c1 = Hex(0x302C30, 6), 	$c2 = Hex(0x050505, 6), $c3 = Hex(0x282427, 6)
		Case $type = "DarkElixir"
			Local $c1 = Hex(0x2E2E2E, 6), 	$c2 = Hex(0x050505, 6), $c3 = Hex(0x262626, 6)
		Case $type = "Trophy"
			Local $c1 = Hex(0x303030, 6), 	$c2 = Hex(0x050505, 6), $c3 = Hex(0x272727, 6)
	EndSelect
	Local $pixel1[3] = [$x+5, $y+5, $c1], $pixel2[3] = [$x+5, $y+9, $c2], $pixel3[3] = [$x+8, $y+12, $c3]
	If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
	  $x += $width
	  Return 9
	Else
	  $x -= 1
	  Local $pixel1[3] = [$x+5, $y+5, $c1], $pixel2[3] = [$x+5, $y+9, $c2], $pixel3[3] = [$x+8, $y+12, $c3]
	  If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
		 $x += $width
		 Return 9
	  Else
		 $x += 2
		 Local $pixel1[3] = [$x+5, $y+5, $c1], $pixel2[3] = [$x+5, $y+9, $c2], $pixel3[3] = [$x+8, $y+12, $c3]
		 If boolPixelSearch($pixel1, $pixel2, $pixel3) Then
			$x += $width
			Return 9
		 Else
			$x -= 1
		 EndIf
	  EndIf
	EndIf
	Return ""
EndFunc

;==============================================================================================================
;===Other Functions============================================================================================
;==============================================================================================================

Func _PixelGetColor_CreateDC($hDll = "gdi32.dll")
	$iPixelGetColor_MemoryContext = DllCall($hDll, "int", "CreateCompatibleDC", "int", 0)
	If @error Then Return SetError(@error,0,0)
	Return $iPixelGetColor_MemoryContext[0]
EndFunc

Func _PixelGetColor_CaptureRegion($iPixelGetColor_MemoryContext, $iLeft = 0, $iTop = 0, $iRight = -1, $iBottom = -1, $fCursor = False, $hDll = "gdi32.dll")
	$HBITMAP = _ScreenCapture_Capture("", $iLeft, $iTop, $iRight, $iBottom, $fCursor)
	DllCall($hDll, "hwnd", "SelectObject", "int", $iPixelGetColor_MemoryContext, "hwnd", $HBITMAP)
	Return $HBITMAP
EndFunc

Func _PixelGetColor_GetPixel($iPixelGetColor_MemoryContext,$iX,$iY, $hDll = "gdi32.dll")
	$iColor = DllCall($hDll,"int","GetPixel","int",$iPixelGetColor_MemoryContext,"int",$iX,"int",$iY)
	If $iColor[0] = -1 then Return SetError(1,0,-1)
	$sColor = Hex($iColor[0],6)
	Return StringRight($sColor,2) & StringMid($sColor,3,2) & StringLeft($sColor,2)
EndFunc
#EndRegion ### End Get Resources Functions ###