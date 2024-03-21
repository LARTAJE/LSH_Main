--// Protect Gui

if not syn or not protectgui then
    getgenv().protectgui = function() end
end

--/#

Key = "EuAmoODivisãoKarreta";

repeat task.wait() until game:IsLoaded();

repeat
    setthreadidentity(8);
    task.wait();
until getthreadidentity() == 8;

--// Keys System

local AvalibleKeys = {
"EuAmoODivisãoKarreta"
}

if not table.find(AvalibleKeys, Key) then game.Players.LocalPlayer:Kick("Invalid key") end
--]]
--/#

local Started = tick()
local is_synapse_function = isexecutorclosure

local gameId = game.GameId;
local jobId, placeId = game.JobId, game.PlaceId;
local userId = game.Players.LocalPlayer.UserId;

local LocalPlayer = game.Players.LocalPlayer
local PlayerGui = game.Players.LocalPlayer.PlayerGui
local Character = LocalPlayer.Character
local mouse = LocalPlayer:GetMouse()


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local GetPlayers = Players.GetPlayers

local GetMouseLocation = UserInputService.GetMouseLocation

local CharacterRoot = Character:WaitForChild("HumanoidRootPart")
local VirtualInputManager = Instance.new("VirtualInputManager")

local Cam = workspace.CurrentCamera
local GetPartsObscuringTarget = Cam.GetPartsObscuringTarget

local Events = ReplicatedStorage:WaitForChild("Events",5)
local Tutorial = workspace:WaitForChild("Tutorial")

local Map
local Bunker_LootAutoFarmPath

if Tutorial then
	Map = Tutorial
	Bunker_LootAutoFarmPath = Map
else
	Map = workspace:WaitForChild("Map",5)
	Bunker_LootAutoFarmPath = Map.Special.Bunker.Streaming
end


local NPCs = workspace:WaitForChild("NPCs")
local Hostile_NPCs = NPCs:WaitForChild("Hostile")
local Other_NPCs = NPCs:WaitForChild("Other")

--local Sense = loadstring(game:HttpGet('https://raw.githubusercontent.com/LARTAJE/LSH_Main/main/LSH_SIRIUS_SENSE_LIBRARY.lua'))()

local AutoLootLOLOLL = false
local AutoLockPikcLOLO = false
local NotifItems = false

local PlayerDeathBagsLootTable = {}
local BunkerLoot = {}
local ProxPrompts = {}
local LootTables = {}
local InstancessLol = {}


local ExpectedArguments = {
    Raycast = {
        ArgCountRequired = 3,
        Args = {
            "Instance", "Vector3", "Vector3", "RaycastParams"
        }
    }
}
--]]

local ValidTargetParts = {"Head", "Torso"};
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}

local GetChildren = game.GetChildren
local GetPlayers = Players.GetPlayers

local WorldToScreen = Cam.WorldToScreenPoint
local WorldToViewportPoint = Cam.WorldToViewportPoint
local GetPartsObscuringTarget = Cam.GetPartsObscuringTarget

local FindFirstChild = game.FindFirstChild
local RenderStepped = RunService.RenderStepped
local GuiInset = GuiService.GetGuiInset

local resume = coroutine.resume 
local create = coroutine.create

local mouse_box = Drawing.new("Square")
mouse_box.Visible = true 
mouse_box.ZIndex = 999 
mouse_box.Color = Color3.fromRGB(255, 0, 0)
mouse_box.Thickness = 20 
mouse_box.Size = Vector2.new(10,10)
mouse_box.Filled = true 


local SilentAIMFov = Drawing.new("Circle")
SilentAIMFov.Thickness = 1
SilentAIMFov.NumSides = 100
SilentAIMFov.Radius = 360
SilentAIMFov.Filled = false
SilentAIMFov.Visible = false
SilentAIMFov.ZIndex = 999
SilentAIMFov.Transparency = 1
SilentAIMFov.Color = Color3.fromRGB(255,255,255)


--]]
local GuiLoaded
local ToLoot

--/#

--// Ui lib

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'LackSkill Hub',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

--/#

--// Tabs

local Tabs = {
    Main = Window:AddTab('Main'), 
    ESP = Window:AddTab('ESP'),
	['UI Settings'] = Window:AddTab('UI Settings'),
}
--/#

--// UI Stuff

local LeftSideTab1_ = Tabs.Main:AddLeftTabbox()
local LeftSideTab1 = Tabs.Main:AddLeftTabbox()
local LeftSideTab2 = Tabs.Main:AddLeftTabbox()
local LeftSideTab3 = Tabs.Main:AddLeftTabbox()
local LeftSideTab4 = Tabs.Main:AddLeftTabbox()
local LeftSideTab5 = Tabs.Main:AddLeftTabbox()

local RightSideTab1 = Tabs.Main:AddRightTabbox()
local RightSideTab2 = Tabs.Main:AddRightTabbox()

--//ESP TABS

local ESP_LeftSideTab1 = Tabs.ESP:AddLeftTabbox()

--// Even more tabs

local Movement = LeftSideTab1_:AddTab('Movement')
local AutoLoot = LeftSideTab1:AddTab('AutoLoot')
local Notificate = LeftSideTab2:AddTab('Notify items')
local QualityOfLive = LeftSideTab3:AddTab('Quality Of Live')
local Missions = LeftSideTab4:AddTab('Missions')
local SilentAim = RightSideTab1:AddTab('Silent Aim')
local Misc = RightSideTab2:AddTab('Misc')
local AutofarmTab = LeftSideTab5:AddTab('Auto farms')

--//ESPs
local ESP_MAIN = ESP_LeftSideTab1:AddTab('ESP')

ESP_MAIN:AddToggle('Esp', {
    Text = 'Enabled',
    Default = false,
    Tooltip = 'ESP toggle.',
})

ESP_MAIN:AddToggle('BoxEsp', {
    Text = 'Box ESP',
    Default = false,
    Tooltip = 'Show box esp toggle.',
})
--[[
ESP_MAIN:AddToggle("HighlightTarget",
{ Text = "Player ESP color" }):AddColorPicker('HighlightColor',
{ Default = Color3.new(255,1,1)});
--]]
ESP_MAIN:AddToggle('NameEsp', {
    Text = 'Show names',
    Default = false,
    Tooltip = 'Shows players names.',
})

ESP_MAIN:AddToggle('HealthBarESP', {
    Text = 'Show health bars',
    Default = false,
    Tooltip = 'Enables health bars.',
})

ESP_MAIN:AddToggle('ShowDistanceESP', {
    Text = 'Show distance',
    Default = false,
    Tooltip = 'Enables tracers.',
})

ESP_MAIN:AddToggle('TracerEsp', {
    Text = 'Show tracers',
    Default = false,
    Tooltip = 'Enables tracers.',
})

--//#

--// Esp toggle settings
--[[
Toggles.Esp:OnChanged(function(state)
	Sense.teamSettings.enemy.enabled = state
end)

Toggles.BoxEsp:OnChanged(function(state)
	Sense.teamSettings.enemy.box = state
end)

Toggles.NameEsp:OnChanged(function(state)
	Sense.teamSettings.enemy.name = state
end)

Toggles.TracerEsp:OnChanged(function(state)
	Sense.teamSettings.enemy.distance = state
end)

Options.HighlightColor:OnChanged(function(state)
	Sense.teamSettings.enemy.boxColor[1] = state
	Sense.teamSettings.enemy.nameColor[1] = state
end)
--]]
--/#

--// SilentAim

SilentAim:AddToggle('SilentAimToggle', {
    Text = 'Enabled',
    Default = false,
    Tooltip = 'Enables Silent aim.',
})

SilentAim:AddDropdown('TargetPart', {
    Values = {'Head', 'Torso','Random'},
    Default = 1,
    Multi = false,
    Text = 'Silent Aim TargetParts',
    Tooltip = 'Silent aim target parts',
})


SilentAim:AddToggle('VisibleCheck', {
    Text = 'Visible Check',
    Default = true,
    Tooltip = 'Checks if target player is in vision.',
})

SilentAim:AddToggle('TargetNPCs', {
    Text = 'Target npcs',
    Default = false,
    Tooltip = 'Silent aim targets npcs.',
})

SilentAim:AddToggle('ShowFOV', {
    Text = 'Show FOV',
    Default = false,
    Tooltip = 'Draws a circle of the desired fov value.',
})



SilentAim:AddSlider('SilentAimFovSlider', {
    Text = 'FOV',

    Default = 100,
    Min = 0,
    Max = 300,
    Rounding = 1,

    Compact = false,
})

SilentAim:AddSlider('SilentAimHitChanceSlider', {
    Text = 'Hit chance',

    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 1,

    Compact = false,
})

--/#

--// Movement

Movement:AddToggle('FlyToggle', {
    Text = 'Fly',
    Default = false,
    Tooltip = 'Enables fly.',
})

Movement:AddSlider('FlySpeed', {
    Text = 'Fly Speed',

    Default = 15,
    Min = 0,
    Max = 100,
    Rounding = 1,

    Compact = false,
})

Movement:AddToggle('SpeedToggle', {
    Text = 'Speed Hack',
    Default = false,
    Tooltip = 'Enables speed hack.',
})

Movement:AddSlider('SpeedhackSlider', {
    Text = 'Speed',

    Default = 20,
    Min = 0,
    Max = 100,
    Rounding = 1,

    Compact = false,
})

--/#

--// AutoLoot Stuff

AutoLoot:AddToggle('AutoLootToggle', {
    Text = 'Enabled',
    Default = false,
    Tooltip = 'Enables auto lotting.',
})

AutoLoot:AddDropdown('AutoLootFilter', {
    Values = {'Cash', 'Valuables', 'Food','Healing','Misc','Melees', 'Guns', 'Armors', 'Keycards'},
    Default = 1,
    Multi = true,
    Text = 'Loot Filter',
    Tooltip = 'Allowed types to auto pick up.',
})
--/#

--// QoL

QualityOfLive:AddToggle('AutoLockpickToggle', {
    Text = 'Auto lockpick',
    Default = false, --false
    Tooltip = 'AutoLockpicks when starting the minigame.',
})

QualityOfLive:AddToggle('OpenlootOnLockpick', {
    Text = 'Open loot On Lockpick',
    Default = false, --false
    Tooltip = 'when lockpicking is done auto opens loot gui.',
})

QualityOfLive:AddToggle('BreakAI', {
    Text = 'Break AI',
    Default = false, --false
    Tooltip = 'Breaks the mob AI lol.',
})

QualityOfLive:AddToggle('NoHD', {
    Text = 'Insta interact',
    Default = false, --false
    Tooltip = 'Sets all Proximity Prompts hold duration to 0.',
})

--/#

--// Notify Items

Notificate:AddToggle('NotificateItemsToggle', {
    Text = 'Enabled',
    Default = true, --false
    Tooltip = 'Notificates when a selected item spawns.',
})

Notificate:AddDropdown('NotificateItemsFilter', {
    Values = { 'Food','Healing','Misc','Melees', 'Guns', 'Armors', 'Keycards'},
    Default = 1,
    Multi = true,
    Text = 'Notification Filter',
    Tooltip = 'Allowed types to notificate.',
})

--/#

--// AutoFarm
AutofarmTab:AddToggle('Bunker_AutoFarm', {
    Text = 'Bunker Auto-farm',
    Default = false, --false
    Tooltip = 'Auto Loots all of bunker',
})

Library:SetWatermarkVisibility(true)
Library:SetWatermark('LackSkill Hub')

Library:OnUnload(function()
    print('Unloaded!')
    Library.Unloaded = true
	script:Destroy()
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' }) 

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings() 
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 
ThemeManager:SetFolder('LackSkillHub')
SaveManager:SetFolder('LackSkillHub/Blackout')
SaveManager:BuildConfigSection(Tabs['UI Settings']) 
ThemeManager:ApplyToTab(Tabs['UI Settings'])

--/#

--/#

--// Locals
--[[
local ItemsTypes = {

	["Food"] = {
		["Energy Bar"],
		["Energy Drink"],
		["Coffee"],
		["Soda"],
		["Canned Beans"],
		["Canned Corn"],
	},

	["Healing"] = {
		["Medkit"],
		["Bandage"],
		["Trauma Pad"],
	},

	["Misc"] = {
		["Lockpick"],
		["Bounty Card"],
	},

	["Melee"] = {
		["Bat"],
		["Tomahawk"],
		["Spear"],
		["Tactical Knife"],
		["Greataxe"],
		["Katana"],
		["Sledgehammer"],
	},

	["Gun"] = {
		["725"],
		["M4A1"],
		["AWM"],
		["Crossbow"],
		["FAMAS"],
		["M1911"],
		["MP5"],
		["SCAR-17"],
		["SCAR-20"],
		["SPAS-12"],
		["TAC-14"],
		["G3"],
		["G17"],
		["G18"],
		["MAC-11"],
		["AK-47"],
		["UZI"],
		["M24"],
		["Deagle"],
	},

	["Explosive"] = {
		["GL-06"],
	},

	["Utility"] = {
		["Ammo Box"],
		["Flashbang"],
		["Grenade"],
		["Incendiary"],
		["Smoke"],
	},

	["Armor"] = {
		["Light Tactical Armor"],
		["Heavy Tactical Armor"],
		["Tactical Leggings"],
	    ["Tactical Helmet"],
		["Small Backpack"]
		["Large Backpack"],
		["Night-Vision Goggles"],
		["Anti-Flash Goggles"],
		["Gas Mask"],
	},

	["Keycard"] = {
		["Purple Keycard"],
		["Green Keycard"],
		["Blue Keycard"],
		["Red Keycard"],
	},

	["Flares"] = {
		["Red Flare Gun"],
	},

}
--]]
--// Events

local PickUpEvent = Events:WaitForChild("Loot"):WaitForChild("LootObject")
local StartTask = Events:WaitForChild("Stations"):WaitForChild("StartTask")
local MinigameResult = Events:WaitForChild("Loot"):WaitForChild("MinigameResult")
local DamageEvent = Events:WaitForChild("Player"):WaitForChild("Damage")
local RagdollEvent = Events:WaitForChild("Player"):WaitForChild("Ragdoll")
--/#

--// Functions

local function getPositionOnScreen(Vector)
    local Vec3, OnScreen = WorldToScreen(Cam, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end

local function getDirection(Origin, Position)
    return (Position - Origin).Unit * 1000
end

local function getMousePosition()
    return GetMouseLocation(UserInputService)
end

local function PickUpItem(LootTable,Item,Method)
	PickUpEvent:FireServer(LootTable,Item,Method)
end

local function OpenLoot(Target)
	fireproximityprompt(Target.LootBase.OpenLootTable)
end

local function LockPick(Target,Method)
	MinigameResult:FireServer(Target,Method)
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
end

local function RagdollChar()
	RagdollEvent:FireServer()
end

local function ItemAdded(Item,Method)
	
	if Toggles.NotificateItemsToggle.Value == true then
		Library:Notify("Item ".. Item.Name.. " Dropped", 10)
	end

end

local speed = Options.FlySpeed.Value

local function Fly()
	    local torso = Character.Torso
		local bg = Instance.new("BodyGyro", torso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = torso.CFrame
		local bv = Instance.new("BodyVelocity", torso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		
		repeat task.wait()
			Character.Humanoid.PlatformStand = true
			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0.1,0)
			end
			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/150),0,0)
		until not Toggles.FlyToggle.Value

		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = Options.FlySpeed.Value
		bg:Destroy()
		bv:Destroy()
		Character.Humanoid.PlatformStand = false
end


local function CalculateChance(Percentage)
    Percentage = math.floor(Percentage)
    local chance = math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100) / 100
    return chance <= Percentage / 100
end

local function TPtoLootAndPickUp(PartToTp, TPBack)

	if TPBack then
		local OriginalPos = CharacterRoot.CFrame
		CharacterRoot.CFrame = PartToTp.CFrame + PartToTp.CFrame.LookVector * -2
		task.delay(1,function()
			CharacterRoot.CFrame = OriginalPos
		end)
	else
		CharacterRoot.CFrame = PartToTp.CFrame + PartToTp.CFrame.LookVector * -2
	end

	task.wait(2)

	LockPick(PartToTp.Parent,true)
	OpenLoot(PartToTp.Parent)
end
--[[
local function IsPlayerVisible(Player)
	local PlayerCharacter

	if typeof(Player) == "Model" then
		PlayerCharacter = Player
	else
		PlayerCharacter = Player.Character
	end
    
    local LocalPlayerCharacter = LocalPlayer.Character
    
    if not (PlayerCharacter or LocalPlayerCharacter) then return end 
    
    local PlayerRoot = FindFirstChild(PlayerCharacter, Options.TargetPart.Value) or FindFirstChild(PlayerCharacter, "HumanoidRootPart")
    
    if not PlayerRoot then return end 
    
    local CastPoints, IgnoreList = {PlayerRoot.Position, LocalPlayerCharacter, PlayerCharacter}, {LocalPlayerCharacter, PlayerCharacter}
    local ObscuringObjects = #GetPartsObscuringTarget(Cam, CastPoints, IgnoreList)
    
    return ((ObscuringObjects == 0 and true) or (ObscuringObjects > 0 and false))
end
--]]
--game:GetService("ReplicatedStorage").GunStorage.Mods

local function ValidateArguments(Args, RayMethod)
    local Matches = 0
    if #Args < RayMethod.ArgCountRequired then
        return false
    end
    for Pos, Argument in next, Args do
        if typeof(Argument) == RayMethod.Args[Pos] then
            Matches = Matches + 1
        end
    end
    return Matches >= RayMethod.ArgCountRequired
end

local function Vector2MousePosition()
	return Vector2.new(mouse.X, mouse.Y)
end

local function getClosestPlayer()
    if not Options.TargetPart.Value then return end
    local Closest
    local DistanceToMouse

	local Chars = {}

	for _, Player in next, GetPlayers(Players) do
		table.insert(Chars,Player.Character)
	end

	for _, NPCs in next, Hostile_NPCs:GetChildren() do
		table.insert(Chars,NPCs)
	end

    for _, __Character in next, Chars do
        if __Character == Character then continue end

        local _Character = __Character
       
		if not _Character then continue end
        
        if Toggles.VisibleCheck.Value and not IsPlayerVisible(_Character) then continue end

        local HumanoidRootPart = FindFirstChild(_Character, "HumanoidRootPart")
        local Humanoid = FindFirstChild(_Character, "Humanoid")
       
		if not HumanoidRootPart or not Humanoid or Humanoid and Humanoid.Health <= 0 then continue end

        local ScreenPosition, OnScreen = getPositionOnScreen(HumanoidRootPart.Position)
        
		if not OnScreen then continue end

        local Distance = (getMousePosition() - ScreenPosition).Magnitude
       
		if Distance <= (DistanceToMouse or Options.SilentAimFovSlider.Value or 2000) then
            Closest = ((Options.TargetPart.Value == "Random" and _Character[ValidTargetParts[math.random(1, #ValidTargetParts)]]) or _Character[Options.TargetPart.Value])
            DistanceToMouse = Distance
        end

    end

    return Closest
end

--]]

local function StartMission(Mission, TPBack)
	local BrokerRootPart = Other_NPCs:FindFirstChild("Broker"):WaitForChild("HumanoidRootPart")
	
	if TPBack then
		local OriginalPos = CharacterRoot.CFrame
		CharacterRoot.CFrame = BrokerRootPart.CFrame
		task.delay(0.3,function()
			CharacterRoot.CFrame = OriginalPos
		end)
	else
		CharacterRoot.CFrame = BrokerRootPart.CFrame
	end

	--task.wait(.2)

	StartTask:FireServer(BrokerRootPart, Mission)
	
end

local function Damage(Damage,LimbDamageTable)
	DamageEvent:FireServer(Damage,LimbDamageTable)
end

local function NPCAdded(NPCChar)
	--Sense.EspInterface.createObject(NPCChar)
end

local function NPCRemoved(NPCChar)
	--Sense.EspInterface.removeObject(NPCChar)
end

local function CollectLootFromLootTable(LootTable)
	local ItemsInLootTable = LootTable:GetChildren()
	local CurrentItemIndex = 1

	
	for _, Item in pairs(ItemsInLootTable) do
		PickUpItem(LootTable,Item,true)
		task.wait(1)
	end
    --]]

	task.wait(0.6)
	PickUpItem(LootTable,"Cash",nil)
	task.wait(0.6)
	PickUpItem(LootTable,"Valuables",nil)
end

local function II_C()

	if Toggles.NoHD.Value then
		for _,HPrompt in pairs(ProxPrompts) do
			HPrompt.HoldDuration = 0
		end
	else
		for _,HPrompt in pairs(ProxPrompts) do
			HPrompt.HoldDuration = HPrompt:GetAttribute("_Original_HoldTime")
		end
	end

end

--// Start Missions

Missions:AddButton('Start Cargo Ambush', function()
	StartMission("StealCargo", true)
end)

Misc:AddButton('Suicide', function()
	
	Damage(1000,{
		["Head"] = 1000
	})

end)

--// More Toggles & stuff
Options.AutoLootFilter:OnChanged(function()
--[[
	for index, value in next, Options.AutoLootFilter.Value do
        print(index, value)
    end
--]]
end)

Toggles.SpeedToggle:OnChanged(function()
	if (not Toggles.SpeedToggle.Value) then
	 Character.Humanoid.WalkSpeed = 16
	 return;
	end;

	Character.Humanoid.WalkSpeed = Options.SpeedhackSlider.Value
end)

Toggles.FlyToggle:OnChanged(function()
	
	if (not Toggles.FlyToggle.Value) then
		return;
	end;

	Fly()
	
end)

--/#

--// Setup Connections

for _, ProxPrompt in pairs(Map:GetDescendants()) do
	
	if ProxPrompt:IsA("ProximityPrompt") then
		table.insert(ProxPrompts,ProxPrompt)
		ProxPrompt:SetAttribute("_Original_HoldTime", ProxPrompt.HoldDuration)

		ProxPrompt.Triggered:Connect(function()

			if ProxPrompt.Name == "LockMinigame" then
				if ProxPrompt:GetAttribute("Unlocked") then
					task.wait(0.5)
					OpenLoot(ToLockPick)
				end
				if Toggles.AutoLockpickToggle.Value == true then
					local ToLockPick = ProxPrompt.Parent.Parent.Parent
					task.wait(1)
					LockPick(ToLockPick,true)
					
					if Toggles.OpenlootOnLockpick.Value == true then
						OpenLoot(ToLockPick)
					end

				end

			elseif ProxPrompt.Name == "OpenLootTable" then
				local PromptLootTable = ProxPrompt.Parent:FindFirstChild("LootTable")

				if Toggles.AutoLootToggle.Value == true then
					task.wait(0.6)
					CollectLootFromLootTable(PromptLootTable)
				end

			end

		end)

	end

end

for _, LootTable in pairs(Map:GetDescendants()) do
	if LootTable.Name == "LootTable" then
		table.insert(LootTables, LootTable)
		
		LootTable.ChildAdded:Connect(function(Item)
			ItemAdded(Item)
		end)

		for __,Item in(LootTable:GetChildren()) do
			ItemAdded(Item)
		end

	end
end

for _, PlrDeathBLootTable in pairs(workspace.Debris.Loot:GetDescendants()) do
	if PlrDeathBLootTable.Name == "LootTable" then

		PlrDeathBLootTable.ChildAdded:Connect(function(Item)
			ItemAdded(Item)
		end)

		for __,Item in(PlrDeathBLootTable:GetChildren()) do
			ItemAdded(Item)
		end

	end
end

for _,Lootinstancee in pairs(Bunker_LootAutoFarmPath:GetDescendants()) do
	if Lootinstancee.Parent.Name == "Loot" then
		table.insert(BunkerLoot, Lootinstancee)
	end
end

--/#

--//Events

Hostile_NPCs.ChildAdded:Connect(NPCAdded)

Hostile_NPCs.ChildRemoved:Connect(NPCRemoved)

LocalPlayer.CharacterAdded:Connect(function()
	Character = LocalPlayer.Character
end)

workspace.Debris.Loot.ChildAdded:Connect(function(Bag)
	local LootTable = Bag:WaitForChild("LootTable",5)

	if not LootTable then return end

	LootTable.ChildAdded:Connect(function(Item)
		ItemAdded(Item)
	end)

	for __,Item in(LootTable:GetChildren()) do
		ItemAdded(Item)
	end

end)

Toggles.NoHD:OnChanged(function()
	II_C()
end)

II_C()

mouse.KeyDown:connect(function(keyY)

	if keyY:lower() == "w" then
		ctrl.f = 1
	elseif keyY:lower() == "s" then
		ctrl.b = -1
	elseif keyY:lower() == "a" then
		ctrl.l = -1
	elseif keyY:lower() == "d" then
		ctrl.r = 1
	end

end)

mouse.KeyUp:connect(function(keyY)

	if keyY:lower() == "w" then
		ctrl.f = 0
	elseif keyY:lower() == "s" then
		ctrl.b = 0
	elseif keyY:lower() == "a" then
		ctrl.l = 0
	elseif keyY:lower() == "d" then
		ctrl.r = 0
	end

end)

--/#


Library:Notify("Loaded UI", 5)
Library:Notify("Script loaded in ".. (tick() - Started), 5)

--// Hooks
local oldNamecall

oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
	local Method = getnamecallmethod()
	
	if Method ~= "Raycast" or Toggles.SilentAimToggle.Value == false then
		return oldNamecall(...)
	end
	
    local Arguments = {...}
    local self = Arguments[1]

    local chance = CalculateChance(Options.SilentAimHitChanceSlider.Value)

    if self == workspace and not checkcaller() and chance == true then

        if ValidateArguments(Arguments, ExpectedArguments.Raycast)-- and Arguments[4]["FilterDescendantsInstances"][1] == LocalPlayer.Character-- and Arguments[4]["FilterDescendantsInstances"][2] == workspace.Debris
		 then
			local A_Origin = Arguments[2]

			local HitPart = getClosestPlayer()

			if HitPart then
				Arguments[3] = getDirection(A_Origin, HitPart.Position)

				return oldNamecall(unpack(Arguments))
			else
				return oldNamecall(...)
			end
			
		else
			return oldNamecall(...)
		end
		
    end

end))

--/#

local BunkerAutoFarmAt = 1
local autoFarmWaitTick = tick()

if Tutorial then
	Map.ChildAdded:Connect(function(Char)
		if Char.Parent:FindFirstChildOfClass("Humanoid") then
			Char.Parent = Hostile_NPCs --Client-sided but its only tutorial dud no one fucking cares
		end
	end)
end

RunService.Heartbeat:Connect(function()
	task.wait()

	Cam = workspace.CurrentCamera

	if Toggles.ShowFOV.Value then
		SilentAIMFov.Visible = Toggles.ShowFOV.Value
		SilentAIMFov.Radius = Options.SilentAimFovSlider.Value
		SilentAIMFov.Position = Vector2MousePosition() + Vector2.new(0, 36)
	end

	if getClosestPlayer() then
		--print()
		local Root = getClosestPlayer().Parent.PrimaryPart or getClosestPlayer()
		local RootToViewportPoint, IsOnScreen = WorldToViewportPoint(Cam, Root.Position);

		mouse_box.Visible = IsOnScreen
		mouse_box.Position = Vector2.new(RootToViewportPoint.X, RootToViewportPoint.Y)
	else 
		mouse_box.Visible = false 
		mouse_box.Position = Vector2.new()
	end
	
	--]]

	if not Character:FindFirstChild("Humanoid") then return end
	if Character.Humanoid.Health <= 0 then return end
	
	--[[
	if (not Toggles.FlyToggle.Value) then
		Character.Humanoid.PlatformStand = false
	end
    --]]

	if Toggles.BreakAI.Value == true then
		CharacterRoot.Velocity = (CharacterRoot.CFrame.LookVector.Unit * 20) + Vector3.new(0,-1000,0);
	end

	if Toggles.SpeedToggle.Value == true then
		Character.Humanoid.WalkSpeed = Options.SpeedhackSlider.Value
	end

    if Toggles.Bunker_AutoFarm.Value == true and (tick() - autoFarmWaitTick) > 3 then
		local LootModel = BunkerLoot[BunkerAutoFarmAt]
		TPtoLootAndPickUp(LootModel.LootBase,false)
		BunkerAutoFarmAt += 1
		autoFarmWaitTick = tick()

		if BunkerAutoFarmAt >= #BunkerLoot then
			BunkerAutoFarmAt = 1
		end
	end

end)

--Sense.Load()
