--// Protect Gui

if not syn or not protectgui then
	getgenv().protectgui = function()

	end
end

--/#
repeat task.wait() until game:IsLoaded();
repeat
	setthreadidentity(8);
	task.wait();
until getthreadidentity() == 8;

--// Keys System

local AvalibleKeys = {
	"EuAmoODivisãoKarreta"
}

if not getgenv().Key then
	game.Players.LocalPlayer:Kick("Missing script key")
end

if not table.find(AvalibleKeys, getgenv().Key) then
	 game.Players.LocalPlayer:Kick("Invalid key")
 end
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
local Lighting = game.Lighting
local GetPlayers = Players.GetPlayers

local GetMouseLocation = UserInputService.GetMouseLocation

local CharacterRoot = Character:WaitForChild("HumanoidRootPart")
local VirtualInputManager = Instance.new("VirtualInputManager")

local Cam = workspace.CurrentCamera
local GetPartsObscuringTarget = Cam.GetPartsObscuringTarget

local Events = ReplicatedStorage:WaitForChild("Events",5)
local Tutorial = workspace:FindFirstChild("Tutorial")
local Arena = game.Workspace:WaitForChild("Arena")
local waveSurvival_m = game.Workspace:WaitForChild("WaveSurvival").NPCs
local MeleeStorage = game:GetService("ReplicatedStorage"):WaitForChild("MeleeStorage")

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

local ESPFramework = loadstring(game:HttpGet("https://raw.githubusercontent.com/NougatBitz/Femware-Leak/main/ESP.lua", true))()
--Aint creditin dis shit 💀

local AutoLootLOLOLL = false
local AutoLockPikcLOLO = false
local NotifItems = false

local PlayerDeathBagsLootTable = {}
local BunkerLoot = {}
local ProxPrompts = {}
local LootTables = {}
local InstancessLol = {}
local PlayersInServer = {}

local ExpectedArguments = {
	FindPartOnRayWithIgnoreList = {
		ArgCountRequired = 3,
		Args = {
			"Instance", "Ray", "table", "boolean", "boolean"
		}
	},
	FindPartOnRayWithWhitelist = {
		ArgCountRequired = 3,
		Args = {
			"Instance", "Ray", "table", "boolean"
		}
	},
	FindPartOnRay = {
		ArgCountRequired = 2,
		Args = {
			"Instance", "Ray", "Instance", "boolean", "boolean"
		}
	},
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
Library:Notify("Script loading", 5)
task.wait(math.random(1,4)) --Fake loading lol (kinda since it crashes if it loads to fast)

--// Tabs

local Tabs = {
	Main = Window:AddTab('Main'), 
	ESP = Window:AddTab('ESP'),
	['UI Settings'] = Window:AddTab('UI Settings'),
}
--/#

--// UI Stuff

local LeftSideTab0 = Tabs.Main:AddLeftTabbox()
local LeftSideTab1_ = Tabs.Main:AddLeftTabbox()
local LeftSideTab1 = Tabs.Main:AddLeftTabbox()
local LeftSideTab2 = Tabs.Main:AddLeftTabbox()
local LeftSideTab3 = Tabs.Main:AddLeftTabbox()
local LeftSideTab4 = Tabs.Main:AddLeftTabbox()
local LeftSideTab5 = Tabs.Main:AddLeftTabbox()

local RightSideTab1 = Tabs.Main:AddRightTabbox()
local RightSideTab2 = Tabs.Main:AddRightTabbox()
local RightSideTab3 = Tabs.Main:AddRightTabbox()

--//ESP TABS

local ESP_LeftSideTab1 = Tabs.ESP:AddLeftTabbox()
local ESP_LeftSideTab2 = Tabs.ESP:AddRightTabbox()
--// Even more tabs

local Combat = LeftSideTab0:AddTab('Combat')
local Movement = LeftSideTab1_:AddTab('Movement')
local AutoLoot = LeftSideTab1:AddTab('AutoLoot')
local Notificate = LeftSideTab2:AddTab('Notify items')
local QualityOfLive = LeftSideTab3:AddTab('Quality Of Live')
local Missions = LeftSideTab4:AddTab('Missions')
local SilentAim = RightSideTab1:AddTab('Silent Aim')
local Misc = RightSideTab2:AddTab('Misc')
local Teleport = RightSideTab3:AddTab('Teleport')
local AutofarmTab = LeftSideTab5:AddTab('Auto farms')

--// Combat

Combat:AddToggle('KillAura', {
	Text = 'KillAura',
	Default = false,
	Tooltip = 'Kill aura toggle.',
})

Combat:AddToggle('KillAura_Target_Players', {
	Text = 'Target players',
	Default = false,
	Tooltip = 'Target players toggle.',
})

Combat:AddToggle('KillAura_Target_NPCS', {
	Text = 'Target npcs',
	Default = false,
	Tooltip = 'Target npcs toggle.',
})

Combat:AddSlider('KillAura_Range', {
	Text = 'Range',

	Default = 50,
	Min = 0,
	Max = 100,
	Rounding = 1,

	Compact = false,
})

Combat:AddDropdown('KillAura_TargetPart', {
	Values = {'Head', 'Torso'},
	Default = 1,
	Multi = false,
	Text = 'KillAura TargetPart',
	Tooltip = 'KillAura Targets x Part',
})

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

local ESP_SETTIGS = ESP_LeftSideTab2:AddTab('Settings')

ESP_SETTIGS:AddToggle('Player_ESP', {
	Text = 'Show Players',
	Default = false,
	Tooltip = 'Shows Players in esp.',
})

ESP_SETTIGS:AddToggle('NPC_ESP', {
	Text = 'Show NPCs',
	Default = false,
	Tooltip = 'Shows NPCs in esp.',
})

ESP_SETTIGS:AddToggle('Merchant_ESP', {
	Text = 'Show Merchants',
	Default = false,
	Tooltip = 'Shows Merchants in esp.',
})

ESP_SETTIGS:AddToggle('Broker_ESP', {
	Text = 'Show Brokers',
	Default = false,
	Tooltip = 'Shows Brokers in esp.',
})

ESP_SETTIGS:AddToggle('Faction_Merchants_ESP', {
	Text = 'Show Faction Merchants',
	Default = false,
	Tooltip = 'Shows Faction Merchants in esp.',
})

--//#

--// Esp toggle settings

Toggles.Player_ESP:OnChanged(function(state)
	ESPFramework.Players = state
end)

Toggles.Merchant_ESP:OnChanged(function(state)
	ESPFramework.Merchant_ESP = state
end)

Toggles.Broker_ESP:OnChanged(function(state)
	ESPFramework.Broker_ESP = state
end)

Toggles.Faction_Merchants_ESP:OnChanged(function(state)
	ESPFramework.Factions_Merchant_ESP = state
end)

Toggles.Esp:OnChanged(function(state)
	ESPFramework.Color = Color3.fromRGB(255,255,255)
	ESPFramework.FaceCamera = true
	ESPFramework:Toggle(state)
end)

Toggles.NPC_ESP:OnChanged(function(state)
	ESPFramework.NPC_ESP = state
end)

Toggles.BoxEsp:OnChanged(function(state)
	ESPFramework.Boxes = state
end)

Toggles.NameEsp:OnChanged(function(state)
	ESPFramework.Names = state
end)

Toggles.TracerEsp:OnChanged(function(state)
	ESPFramework.Tracers = state
end)

Toggles.ShowDistanceESP:OnChanged(function(state)
	ESPFramework.Distance = state
end)

Toggles.HealthBarESP:OnChanged(function(state)
	ESPFramework.Health = state
end)

--// SilentAim

SilentAim:AddToggle('SilentAimToggle', {
	Text = 'Enabled',
	Default = false,
	Tooltip = 'Enables Silent aim.',
})

SilentAim:AddToggle('InstaHit', {
	Text = 'Instant hit',
	Default = false,
	Tooltip = 'Bullets teleports to players.',
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
	Text = 'Target NPCs',
	Default = false,
	Tooltip = 'Silent aim targets npcs.',
})

SilentAim:AddToggle('IgnoreFriends', {
	Text = 'Ignore friends',
	Default = false,
	Tooltip = 'Filters people youre friends with.',
})

SilentAim:AddToggle('ShowFOV', {
	Text = 'Show FOV',
	Default = false,
	Tooltip = 'Draws a circle of the desired fov value.',
})

SilentAim:AddToggle('ShowSilentTarget', {
	Text = 'Show Silent Aim target',
	Default = false,
	Tooltip = 'Shows the silent aim current target (can cause fps loss on low end pcs).',
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

Movement:AddToggle('Noclip', {
	Text = 'Noclip',
	Default = false,
	Tooltip = 'Noclip.',
})

Movement:AddToggle('StopNoclipOnRagdoll', {
	Text = 'Stop Noclip on ragdoll',
	Default = false,
	Tooltip = 'Stops noclipping when ragdolled.',
})

--/#

--// AutoLoot Stuff

AutoLoot:AddToggle('AutoLootToggle', {
	Text = 'Enabled',
	Default = false,
	Tooltip = 'Enables auto lotting.',
})

AutoLoot:AddDropdown('AutoLootFilter', {
	Values = {'Cash', 'Valuables', 'Food','Healing', 'Utility' ,'Misc','Melee', 'Gun', 'Explosive' , 'Armor', 'Keycard', 'Flare','Contraband'},
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

QualityOfLive:AddToggle('Fullbright', {
	Text = 'Fullbright',
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
	Default = false, --false
	Tooltip = 'Notificates when a selected item spawns.',
})

Notificate:AddToggle('NotificateHightlightLoot', {
	Text = 'Hightlight loot',
	Default = false, --false
	Tooltip = 'Hightlighs the loot that was notifyedd.',
})

Notificate:AddToggle('NotificateAddToESP', {
	Text = 'ESP loot',
	Default = false, --false
	Tooltip = 'Shows loot in the ESP (Must have ESP enabled).',
})

Notificate:AddDropdown('NotificateItemsFilter', {
	Values = {'Food','Healing', 'Utility' ,'Misc','Melee', 'Gun', 'Explosive' , 'Armor', 'Keycard', 'Flare','Contraband'},
	Default = 1,
	Multi = true,
	Text = 'Notification Filter',
	Tooltip = 'Allowed types to notificate.',
})



Toggles.NotificateAddToESP:OnChanged(function(state)
	ESPFramework.Notificate_Items = state
end)

--/#

--// AutoFarm
AutofarmTab:AddToggle('Bunker_AutoFarm', {
	Text = 'Bunker Auto-farm',
	Default = false, --false
	Tooltip = 'Auto Loots all of bunker',
})

AutofarmTab:AddToggle('Arena_AutoFarm', {
	Text = 'Arena Auto-farm',
	Default = false, --false
	Tooltip = 'Auto do Arenas',
})

AutofarmTab:AddToggle('RedRaid_AutoFarm', {
	Text = 'Wave survival Auto-farm',
	Default = false, --false
	Tooltip = 'Auto do Red Raids',
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

--// Locals

local ItemStats = {

	--//# Food

	["Energy Bar"] = {
		Type = "Food",
		Contraband = false
	},

	["Energy Drink"] = {
		Type = "Food",
		Contraband = false
	},

	["Coffee"] = {
		Type = "Food",
		Contraband = false
	},

	["Soda"] = {
		Type = "Food",
		Contraband = false
	},

	["Canned Beans"] = {
		Type = "Food",
		Contraband = false
	},

	["Canned Corn"] = {
		Type = "Food",
		Contraband = false
	},
	--/#

	--// Healing

	["Medkit"] = {
		Type = "Healing",
		Contraband = false
	},

	["Bandage"] = {
		Type = "Healing",
		Contraband = false
	},

	["Trauma Pad"] = {
		Type = "Healing",
		Contraband = false
	},
	--/#


	--// Misc

	["Lockpick"] = {
		Type = "Misc",
		Contraband = false
	},

	["Bounty Card"] = {
		Type = "Misc",
		Contraband = false
	},
	--/#

	--// Melees


	["Bat"] = {
		Type = "Melee",
		Contraband = false
	},

	["Tomahawk"] = {
		Type = "Melee",
		Contraband = false
	},

	["Spear"] = {
		Type = "Melee",
		Contraband = false
	},

	["Tactical Knife"] = {
		Type = "Melee",
		Contraband = false
	},

	["Greataxe"] = {
		Type = "Melee",
		Contraband = false
	},

	["Katana"] = {
		Type = "Melee",
		Contraband = false
	},

	["Sledgehammer"] = {
		Type = "Melee",
		Contraband = false
	},

	["Photon Blades"] = {
		Type = "Melee",
		Contraband = true
	},

	--// Guns


	["725"] = {
		Type = "Gun",
		Contraband = false
	},

	["M4A1"] = {
		Type = "Gun",
		Contraband = false
	},
	["AWM"] = {
		Type = "Gun",
		Contraband = false
	},

	["Crossbow"] = {
		Type = "Gun",
		Contraband = false
	},

	["FAMAS"] = {
		Type = "Gun",
		Contraband = false
	},

	["M1911"] = {
		Type = "Gun",
		Contraband = false
	},
	["MP5"] = {
		Type = "Gun",
		Contraband = false
	},
	["SCAR-17"] = {
		Type = "Gun",
		Contraband = false
	},
	["SCAR-20"] = {
		Type = "Gun",
		Contraband = false
	},
	["SPAS-12"] = {
		Type = "Gun",
		Contraband = false
	},
	["TAC-14"] = {
		Type = "Gun",
		Contraband = false
	},
	["G3"] = {
		Type = "Gun",
		Contraband = false
	},
	["G17"] = {
		Type = "Gun",
		Contraband = false
	},

	["G18"] = {
		Type = "Gun",
		Contraband = false
	},

	["MAC-11"] = {
		Type = "Gun",
		Contraband = false
	},

	["AK-47"] = {
		Type = "Gun",
		Contraband = false
	},

	["UZI"] = {
		Type = "Gun",
		Contraband = false
	},

	["M24"] = {
		Type = "Gun",
		Contraband = false
	},


	["Deagle"] = {
		Type = "Gun",
		Contraband = false
	},

	["Photon Accelerator"] = {
		Type = "Gun",
		Contraband = true
	},
	--/#


	--// Explosives

	["GL-06"] = {
		Type = "Explosive",
		Contraband = false
	},

	["RPG-18"] = {
		Type = "Explosive",
		Contraband = true
	},
	--/#

	--// Utility

	["Ammo Box"] = {
		Type = "Utility",
		Contraband = false
	},

	["Flashbang"] = {
		Type = "Utility",
		Contraband = false
	},

	["Grenade"] = {
		Type = "Utility",
		Contraband = false
	},

	["Incendiary"] = {
		Type = "Utility",
		Contraband = false
	},

	["Smoke"] = {
		Type = "Utility",
		Contraband = false
	},


	--// Armor

	["Light Tactical Armor"] = {
		Type = "Armor",
		Contraband = false
	},

	["Heavy Tactical Armor"] = {
		Type = "Armor",
		Contraband = false
	},

	["Operator Helmet"] = {
		Type = "Armor",
		Contraband = true
	},

	["Operator Vest"] = {
		Type = "Armor",
		Contraband = true
	},

	["Operator Leggings"] = {
		Type = "Armor",
		Contraband = true
	},

	["Tactical Leggings"] = {
		Type = "Armor",
		Contraband = false
	},

	["Tactical Helmet"] = {
		Type = "Armor",
		Contraband = false
	},

	["Small Backpack"] = {
		Type = "Armor",
		Contraband = false
	},

	["Large Backpack"] = {
		Type = "Armor",
		Contraband = false
	},

	["Night-Vision Goggles"] = {
		Type = "Armor",
		Contraband = false
	},

	["Anti-Flash Goggles"] = {
		Type = "Armor",
		Contraband = false
	},

	["Gas Mask"] = {
		Type = "Armor",
		Contraband = false
	},
	--/#


	--// Keycards

	["Purple Keycard"] = {
		Type = "Keycard",
		Contraband = false
	},

	["Green Keycard"] = {
		Type = "Keycard",
		Contraband = false
	},

	["Blue Keycard"] = {
		Type = "Keycard",
		Contraband = false
	},

	["Red Keycard"] = {
		Type = "Keycard",
		Contraband = false
	},
	--/#

	--// Flares

	["Red Flare Gun"] = {
		Type = "Flares",
		Contraband = false
	},

	["Green Flare Gun"] = {
		Type = "Flares",
		Contraband = false
	},

}
--]]
--// Events

local PickUpEvent = Events:WaitForChild("Loot"):WaitForChild("LootObject")
local StartTask = Events:WaitForChild("Stations"):WaitForChild("StartTask")
local MinigameResult = Events:WaitForChild("Loot"):WaitForChild("MinigameResult")
local DamageEvent = Events:WaitForChild("Player"):WaitForChild("Damage")
local RagdollEvent = Events:WaitForChild("Player"):WaitForChild("Ragdoll")
local HitEvent = MeleeStorage:WaitForChild("Events"):WaitForChild("Hit")
local SwingEvent = MeleeStorage:WaitForChild("Events"):WaitForChild("Swing")
--/#

--// Admin detector sound

local AdminSound = Instance.new('Sound')
AdminSound.Volume = 2
AdminSound.Parent = CoreGui
AdminSound.SoundId = 'rbxassetid://225320558'
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

local function HightlightOBJ(OBJ,timeT)
	local HL = Instance.new("Highlight")
	HL.FillTransparency = 0.75
	HL.Parent = OBJ
	game:GetService("Debris"):AddItem(HL, timeT)
end

local function OnPlayerDisconnect(Plr)
	table.remove(PlayersInServer,table.find(PlayersInServer,Plr))
end

local OnAdminJoined = function(Plr)
	table.insert(PlayersInServer,Plr)

	local IsInGroup = function(Plr, Id)
		local Success, Response = pcall(Plr.IsInGroup, Plr, Id)
		if Success then 
			return Response 
		end
		return false
	end

	local GetRoleInGroup = function(Plr, Id)
		local Success, Response = pcall(Plr.GetRoleInGroup, Plr, Id)
		if Success then
			return Response
		end
		return false
	end

	local GroupStates = { 
		["CrimAdminGroup"] = IsInGroup(Plr, 10911475),
		["Blackout"] = IsInGroup(Plr, 6568965),
	}

	if GroupStates.Criminality or GroupStates.Blackout then
		local Role = GetRoleInGroup(Plr, 6568965)

		if Role ~= "Member" or GroupStates.CrimAdminGroup then

			if Toggles.AdminDetector.Value then
				Player:Kick("[LackSkill Hub] - Detected an Admin/Contributor within the server!")
				return
			end


			AdminSound:Play()
			Library:Notify(Plr.Name.." Is a Admin/Contributor, please be careful!")
		else
			AdminSound:Play()
			Library:Notify(Plr.Name.." Joined, be careful!")
		end

	end
end


local function ItemAdded(Item,Method)

	if Toggles.NotificateItemsToggle.Value == true then

		local ItemStat = ItemStats[Item.Name]

		if ItemStat and (Options.NotificateItemsFilter.Value[ItemStat.Type] == true) or ItemStat.Contraband == true and (Options.NotificateItemsFilter.Value["Contraband"] == true) then
			Library:Notify("Item ".. Item.Name.. " Dropped", 10)

			if Toggles.NotificateHightlightLoot.Value == true then
				HightlightOBJ(Item.Parent.Parent,10)
			end

			if Toggles.NotificateAddToESP.Value == true then

				ESPFramework:Add(Item.Parent.Parent,{
					Name = Item.Parent.Parent.Parent.Name,
					Color = Color3.fromRGB(255, 135, 239),
					ColorDynamic = false,
					IsEnabled = "Notificate_Items",
				})

			end

		end

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

local function Swing()
	SwingEvent:InvokeServer()
end

local function Hit(__ZCharacter,PartToHit)
	local args = {
		[1] = __ZCharacter[PartToHit],
		[2] = __ZCharacter[PartToHit].Position
	}
	HitEvent:FireServer(unpack(args))
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

local function IsPlayerVisible(Player)
	local PlayerCharacter = Player.Character
	local LocalPlayerCharacter = LocalPlayer.Character

	if not (PlayerCharacter or LocalPlayerCharacter) then return end 

	local PlayerRoot = FindFirstChild(PlayerCharacter, Options.TargetPart.Value) or FindFirstChild(PlayerCharacter, "HumanoidRootPart")

	if not PlayerRoot then return end 

	local CastPoints, IgnoreList = {PlayerRoot.Position, LocalPlayerCharacter, PlayerCharacter}, {LocalPlayerCharacter, PlayerCharacter}
	local ObscuringObjects = #GetPartsObscuringTarget(Cam, CastPoints, IgnoreList)

	return ((ObscuringObjects == 0 and true) or (ObscuringObjects > 0 and false))
end

local function getClosestPlayer()
	if not Options.TargetPart.Value then return end
	local Closest
	local DistanceToMouse

	for _, Player in next, GetPlayers(Players) do
		if Player == LocalPlayer then continue end

		local _Character = Player.Character
		if not _Character then continue end

		--if Toggles.VisibleCheck.Value and not IsPlayerVisible(Player) then continue end
		--if Toggles.IgnoreFriends.Value and Player:IsFriendsWith(LocalPlayer.UserId) then continue end

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
	--ESPFramework:AddObjectListener.createObject(NPCChar,)
end

local function NPCRemoved(NPCChar)
	--ESPFramework:AddObjectListener.removeObject(NPCChar,)
end

local function CollectLootFromLootTable(LootTable)
	local ItemsInLootTable = LootTable:GetChildren()
	local CurrentItemIndex = 1


	for _, Item in pairs(ItemsInLootTable) do
		local ItemStat = ItemStats[Item.Name]

		if ItemStat and (Options.AutoLootFilter.Value[ItemStat.Type] == true) or ItemStat.Contraband == true and (Options.AutoLootFilter.Value[ItemStat.Contraband] == true) then
			PickUpItem(LootTable,Item,true)
			task.wait(0.5)
		end

	end


	if Options.AutoLootFilter.Value["Cash"] == true then
		task.wait(0.5)
		PickUpItem(LootTable,"Cash",nil)
	end

	if Options.AutoLootFilter.Value["Valuables"] == true then
		task.wait(0.5)
		PickUpItem(LootTable,"Valuables",nil)
	end

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

local function ArenaInstanceAdded(INNNSTANCE)
	if Toggles.Arena_AutoFarm.Value == true then

		if INNNSTANCE:FindFirstChild("Head") and INNNSTANCE:IsA("Model") then
			CharacterRoot.CFrame = (INNNSTANCE["HumanoidRootPart"].CFrame + Vector3.new(0,4,0))-- + (INNNSTANCE["HumanoidRootPart"].CFrame.LookVector * -2)
			Swing()
			Hit(INNNSTANCE, "Head")
			task.wait(0.05) 
		end

	end
end

local function RedRaidInstanceAdded(INNNSTANCE)
	if Toggles.RedRaid_AutoFarm.Value == true then

		if INNNSTANCE:FindFirstChild("Head") and INNNSTANCE:IsA("Model") then
			CharacterRoot.CFrame = (INNNSTANCE["HumanoidRootPart"].CFrame + Vector3.new(0,4,0))-- + (INNNSTANCE["HumanoidRootPart"].CFrame.LookVector * -2)
			Swing()
			Hit(INNNSTANCE, "Head")
			task.wait(0.05) 
		end

	end
end

local function SetUpLootTables(_LootTable)
	table.insert(LootTables, _LootTable)

	_LootTable.ChildAdded:Connect(function(Item)
		ItemAdded(Item)
	end)

	for __,Item in(_LootTable:GetChildren()) do
		ItemAdded(Item)
	end
end

local function PromptSetUp(ProxPrompt)
	table.insert(ProxPrompts,ProxPrompt)
	ProxPrompt:SetAttribute("_Original_HoldTime", ProxPrompt.HoldDuration)
	II_C()
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

--// Start Missions

Missions:AddButton('Start Cargo Ambush', function()
	StartMission("StealCargo", true)
end)

--[[
Teleport:AddDropdown('DropDownTeleport', {
	Values = PlayersInServer,
	Default = 1,
	Multi = false,
	Text = 'Players',
	Tooltip = 'Teleport to selected player.',
})

Teleport:AddButton('TeleportToPlayer', function()
	local TargetRoot = PlayersInServer.Character:FindFirstChild("HumanoidRootPart")

	if TargetRoot then
		CharacterRoot.CFrame = TargetRoot.CFrame
	end

end)
--]]

Misc:AddToggle('HiddenFling', {
	Text = 'Hidden fling',
	Default = false,
	Tooltip = 'Flings... and its hidden!.',
})

Misc:AddToggle('DisableFDMG_RAGDOLL', {
	Text = 'Disable Ragdoll',
	Default = false,
	Tooltip = 'Disables ragdoll and adicionaly disable fall damage!.',
})

Misc:AddButton('Suicide', function()

	Damage(1000,{
		["Head"] = 1000
	})

end)

Toggles.SpeedToggle:OnChanged(function()
	if (not Toggles.SpeedToggle.Value) then
		Character.Humanoid.WalkSpeed = 16
		return;
	end;

	Character.Humanoid.WalkSpeed = Options.SpeedhackSlider.Value
end)

Toggles.Fullbright:OnChanged(function()
	--Lighting.Ambient = Color3.new(201, 129, 123)
end)

Toggles.FlyToggle:OnChanged(function()

	if (not Toggles.FlyToggle.Value) then
		return;
	end;

	Fly()

end)

--/#

--// Setup Connections

for _, ProxPrompt in pairs(game:GetDescendants()) do

	if ProxPrompt:IsA("ProximityPrompt") then
		PromptSetUp(ProxPrompt)
	end

end

for _, LootTable in pairs(game:GetDescendants()) do

	if LootTable.Name == "LootTable" then
		SetUpLootTables(LootTable)
	end

end

for _, PlrDeathBLootTable in pairs(workspace.Debris.Loot:GetDescendants()) do
	if PlrDeathBLootTable.Name == "LootTable" then
		SetUpLootTables(PlrDeathBLootTable)
	end
end

for _, Lootinstancee in pairs(game:GetDescendants()) do

	if Lootinstancee.Parent.Name == "Loot" then
		table.insert(BunkerLoot, Lootinstancee)
	end

end

--/#

--//Events
ESPFramework:AddObjectListener(Hostile_NPCs,{ --Vulture
	Name = "Military Scout",
	Color = Color3.fromRGB(10,25,25),
	ColorDynamic = false,
	IsEnabled = "NPC_ESP",
})

ESPFramework:AddObjectListener(Hostile_NPCs,{ --Vulture
	Name = "Military Guard",
	Color = Color3.fromRGB(10,10,10),
	ColorDynamic = false,
	IsEnabled = "NPC_ESP",
})

--
ESPFramework:AddObjectListener(Hostile_NPCs,{ --Vulture
	Name = "Vulture Scout",
	Color = Color3.fromRGB(255,1,25),
	ColorDynamic = false,
	IsEnabled = "NPC_ESP",
})

ESPFramework:AddObjectListener(Hostile_NPCs,{ --Vulture
	Name = "Vulture Guard",
	Color = Color3.fromRGB(200,1,25),
	ColorDynamic = false,
	IsEnabled = "NPC_ESP",
})

--
ESPFramework:AddObjectListener(Hostile_NPCs,{ --Rebels
	Name = "Rebel Scout",
	Color = Color3.fromRGB(25,25,255),
	ColorDynamic = false,
	IsEnabled = "NPC_ESP",
})

ESPFramework:AddObjectListener(Hostile_NPCs,{ --Rebels
	Name = "Rebel Guard",
	Color = Color3.fromRGB(25,25,200),
	ColorDynamic = false,
	IsEnabled = "NPC_ESP",
})
--
ESPFramework:AddObjectListener(Other_NPCs,{ --Merchants
	Name = "Merchant",
	Color = Color3.fromRGB(25,200,0),
	ColorDynamic = false,
	IsEnabled = "Merchant_ESP",
})

ESPFramework:AddObjectListener(Other_NPCs,{ --Brokers
	Name = "Broker",
	Color = Color3.fromRGB(25,200,0),
	ColorDynamic = false,
	IsEnabled = "Broker_ESP",
})
--
ESPFramework:AddObjectListener(Other_NPCs,{ --Faction Rebel Merchants
	Name = "Rebel Merchant",
	Color = Color3.fromRGB(255,255,0),
	ColorDynamic = false,
	IsEnabled = "Factions_Merchant_ESP",
})

ESPFramework:AddObjectListener(Other_NPCs,{ --Faction Vulture Merchants
	Name = "Vulture Merchant",
	Color = Color3.fromRGB(255,255,0),
	ColorDynamic = false,
	IsEnabled = "Factions_Merchant_ESP",
})

workspace.Debris.Loot.ChildAdded:Connect(function(LootBag)
	local LoooottableeOMG = LootBag:WaitForChild("LootTable", 5)
    if not LoooottableeOMG then return end
	table.insert(LootTables, LoooottableeOMG)
	SetUpLootTables(LoooottableeOMG)
end)

--[[
game.DescendantAdded:Connect(function(OBJa)
	if OBJ:IsA("ProximityPrompt") then
		PromptSetUp(OBJ)
	elseif OBJ.Name == "LootTable" then
		table.insert(LootTables, OBJ)

		OBJ.ChildAdded:Connect(function(Item)
			ItemAdded(Item)
		end)

	end
end)
--]]
Hostile_NPCs.ChildAdded:Connect(NPCAdded)

Hostile_NPCs.ChildRemoved:Connect(NPCRemoved)

LocalPlayer.CharacterAdded:Connect(function()
	Character = LocalPlayer.Character
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

	local Arguments = {...}
	local self = Arguments[1]

	local chance = CalculateChance(Options.SilentAimHitChanceSlider.Value)

	if self == workspace and not checkcaller() and chance == true and Method == "Raycast" and Toggles.SilentAimToggle.Value == true then
		if ValidateArguments(Arguments, ExpectedArguments.Raycast) and Arguments[4]["FilterDescendantsInstances"][1] == LocalPlayer.Character and Arguments[4]["FilterDescendantsInstances"][2] == workspace.Debris then
			local A_Origin = Arguments[2]
			local HitPart = getClosestPlayer()

			--[[
			if Toggles.ShowSilentTarget.Value == true then
		
				if HitPart then
					local Root = HitPart.Parent.PrimaryPart or HitPart
					local RootToViewportPoint, IsOnScreen = WorldToViewportPoint(Cam, Root.Position);
			
					mouse_box.Visible = IsOnScreen
					mouse_box.Position = Vector2.new(RootToViewportPoint.X, RootToViewportPoint.Y)
				else 
					mouse_box.Visible = false 
					mouse_box.Position = Vector2.new()
				end
			else
				mouse_box.Visible = false 
				mouse_box.Position = Vector2.new()
			end--]]

			if HitPart then
				Arguments[3] = getDirection(A_Origin, HitPart.Position)
                if Toggles.InstaHit.Value then
                    Arguments[2] = HitPart.Position
                end
				return oldNamecall(unpack(Arguments))
			else
				return oldNamecall(...)
			end
		else
			return oldNamecall(...)
		end
	else
		return oldNamecall(...)
	end

	return oldNamecall(...)
end))
--/#

local BunkerAutoFarmAt = 1
local autoFarmWaitTick = tick()

if Tutorial then
	Map.ChildAdded:Connect(function(Char)
		if Char:FindFirstChildOfClass("Humanoid") then
			Char.Parent = Hostile_NPCs --Client-sided but its only tutorial dud no one fucking cares
		end
	end)
end

--// Admin detection connection
Players.PlayerAdded:Connect(OnAdminJoined)
Players.PlayerRemoving:Connect(OnPlayerDisconnect)

for _,v in pairs(Players:GetPlayers()) do
	if v == Player then continue end
	table.insert(PlayersInServer,v)
	task.spawn(OnAdminJoined, v)
end
--/#

--// Fullbright

Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
	if Toggles.Fullbright.Value then
		--Lighting.Ambient = Color3.new(1,1,1)
	end
end)
--/#

RunService.Heartbeat:Connect(function()
	task.wait()

	Cam = workspace.CurrentCamera

	if LocalPlayer.Character then
		Character = LocalPlayer.Character
		CharacterRoot = Character:WaitForChild("HumanoidRootPart")
	end

	if not Character:FindFirstChild("Humanoid") then return end
	if Character.Humanoid.Health <= 0 then return end

	if Toggles.ShowFOV.Value then
		SilentAIMFov.Visible = Toggles.ShowFOV.Value
		SilentAIMFov.Radius = Options.SilentAimFovSlider.Value
		SilentAIMFov.Position = Vector2MousePosition() + Vector2.new(0, 36)
	else
		SilentAIMFov.Visible = false
	end

	if Toggles.BreakAI.Value == true then
		CharacterRoot.Velocity = (CharacterRoot.CFrame.LookVector.Unit * 20) + Vector3.new(0,-1000,0);
	end

	if Toggles.SpeedToggle.Value == true then
		Character.Humanoid.WalkSpeed = Options.SpeedhackSlider.Value
	end

	if Toggles.KillAura.Value == true then
		local KillAuraChars = {}

        if Toggles.KillAura_Target_Players.Value == true then
            for _,Instances in pairs(game.Players:GetPlayers()) do
                local Hum = Instances.Character:FindFirstChild("Humanoid")
    
                if Hum and Hum.Health > 1 then
                    table.insert(KillAuraChars, Instances.Character)
                end
    
            end
        end

		if Toggles.KillAura_Target_NPCS.Value == true then
			
			for _,Instances in pairs(waveSurvival_m:GetChildren()) do
				local Hum = Instances:FindFirstChild("Humanoid")
	
				if Hum and Hum.Health > 1 then
					table.insert(KillAuraChars, Instances)
				end
	
			end

			for _,Instances in pairs(Hostile_NPCs:GetChildren()) do
				local Hum = Instances:FindFirstChild("Humanoid")
	
				if Hum and Hum.Health > 1 then
					table.insert(KillAuraChars, Instances)
				end
	
			end

			for _,Instances in pairs(Arena:GetChildren()) do
				local Hum = Instances:FindFirstChild("Humanoid")
	
				if Hum and Hum.Health > 1 then
					table.insert(KillAuraChars, Instances)
				end
	
			end
			
		end

		for i = 2, #KillAuraChars do
			local KillAuraTargetCharacter = KillAuraChars[i]
       
			if KillAuraTargetCharacter and KillAuraTargetCharacter:FindFirstChild("Humanoid") and KillAuraTargetCharacter.Humanoid.Health > 0 and KillAuraTargetCharacter:FindFirstChild("HumanoidRootPart") and (CharacterRoot.Position - KillAuraTargetCharacter:FindFirstChild("HumanoidRootPart").Position).Magnitude <= Options.KillAura_Range.Value then
				Swing()
				Hit(KillAuraTargetCharacter, Options.KillAura_TargetPart.Value)
			end
	
		end

	end

    if Toggles.HiddenFling.Value == true then
        local vel = CharacterRoot.Velocity
        local movel = 0.1

        CharacterRoot.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
        RunService.RenderStepped:Wait()
        CharacterRoot.Velocity = vel
        RunService.RenderStepped:Wait()
        CharacterRoot.Velocity = vel + Vector3.new(0, movel, 0)
        movel = movel * -1
    end

    if Toggles.DisableFDMG_RAGDOLL.Value == true then
      Character:WaitForChild("RagdollClient").Enabled = false
    else
        Character:WaitForChild("RagdollClient").Enabled = true
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

	if Toggles.Arena_AutoFarm.Value == true then
		for _,Instances in pairs(Arena:GetChildren()) do
			local Hum = Instances:FindFirstChild("Humanoid")

			if Hum and Hum.Health > 1 then
				ArenaInstanceAdded(Instances)
				return
			end

		end
	end

	if Toggles.RedRaid_AutoFarm.Value == true then

		for _,Instances in pairs(waveSurvival_m:GetChildren()) do
			local Hum = Instances:FindFirstChild("Humanoid")

			if Hum and Hum.Health > 1 then
				RedRaidInstanceAdded(Instances)
				return
			end

		end

	end

end)
