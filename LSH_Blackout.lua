
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

--/#

local Started = tick()
local is_synapse_function = isexecutorclosure

local gameId = game.GameId;
local jobId, placeId = game.JobId, game.PlaceId;
local userId = game.Players.LocalPlayer.UserId;

--// Locals

local ItemsTypes = {
	["Energy Bar"] = "Food",
	["Energy Drink"] = "Food",
	["Soda"] = "Food",
	["Medkit"] = "Healing",
	["Trauma Pad"] = "Healing",
	["Lockpick"] = "Misc",
	["Tactical Leggings"] = "Armour",
}

local GuiLoaded
local LocalPlayer = game.Players.LocalPlayer
local PlayerGui = game.Players.LocalPlayer.PlayerGui
local Character = LocalPlayer.Character
local CharacterRoot = Character:WaitForChild("HumanoidRootPart")
local LootTables = {}
local PlayerDeathBagsLootTable = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local Map = workspace:WaitForChild("Map")
local NPCs = workspace:WaitForChild("NPCs")
local Other_NPCs = NPCs:WaitForChild("Other")
local NotifItems = false
local LootAreas = {}
local ToLoot
--/#

--// Services

local RunService = game:GetService("RunService")
--/#

--// Events

local PickUpEvent = Events:WaitForChild("Loot"):WaitForChild("LootObject")
local StartTask = Events:WaitForChild("Stations"):WaitForChild("StartTask")
local MinigameResult = Events:WaitForChild("Loot"):WaitForChild("MinigameResult")
--/#

--// Functions 

local function PickUpItem(LootTable,Item,Method)
	PickUpEvent:FireServer(LootTable,Item,Method)
end

local function LockPick(Target,Method)
	MinigameResult:FireServer(Target,Method)
end

local function ItemAdded(Item,Method)
	
	if NotifItems then
		Library:Notify("Item ".. Item.Name.. " Spawned", 25)
	end

end

local function StartMission(Mission, TPBack)
	local BrokerRootPart = Other_NPCs:FindFirstChild("Broker"):WaitForChild("HumanoidRootPart")
	
	if TPBack then
		local OriginalPos = CharacterRoot.CFrame
		CharacterRoot.CFrame = BrokerRootPart.CFrame
		task.delay(0.15,function()
			CharacterRoot.CFrame = OriginalPos
		end)
	else
		CharacterRoot.CFrame = BrokerRootPart.CFrame
	end

	task.wait(.1)

	StartTask:FireServer(BrokerRootPart, Mission)
	
end

--/#

Library:Notify("Loaded functions", 3)

--// Setup Connections

for _, LootArea in pairs(workspace:WaitForChild("Map"):GetDescendants()) do
	if LootArea.Name == "Loot" then
		table.insert(LootAreas, LootTable)
	end
end

for _, LootTable in pairs(workspace:WaitForChild("Map"):GetDescendants()) do
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

Library:Notify("Loaded Connections", 3)
--/#

--//Events

workspace.Debris.Loot.ChildAdded:Connect(function(Bag)
	local LootTable = Bag:WaitForChild("LootTable")

	LootTable.ChildAdded:Connect(function(Item)
		ItemAdded(Item)
	end)

	for __,Item in(LootTable:GetChildren()) do
		ItemAdded(Item)
	end

end)

Library:Notify("Loaded events", 3)
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

local LeftSideTab1 = Tabs.Main:AddLeftTabbox()
local LeftSideTab2 = Tabs.Main:AddLeftTabbox()
local LeftSideTab3 = Tabs.Main:AddLeftTabbox()
local LeftSideTab4 = Tabs.Main:AddLeftTabbox()
--// Even more tabs

local AutoLoot = LeftSideTab1:AddTab('AutoLoot')
local Notificate = LeftSideTab2:AddTab('Notify items')
local QualityOfLive = LeftSideTab3:AddTab('Quality Of Live')
local Missions = LeftSideTab4:AddTab('Missions')

--//#

--// AutoLoot Stuff

AutoLoot:AddToggle('AutoLootToggle', {
    Text = 'Enabled',
    Default = false,
    Tooltip = 'Enables auto lotting',
})

AutoLoot:AddDropdown('AutoLootFilter', {
    Values = { 'Food','Healing','Misc','Melees', 'Guns', 'Armors', 'Keycards'},
    Default = 1,
    Multi = true,
    Text = 'Loot Filter',
    Tooltip = 'Allowed types to auto pick up',
})
--/#

--// QoL

QualityOfLive:AddToggle('AutoLockpickToggle', {
    Text = 'Auto lockpick',
    Default = false, --false
    Tooltip = 'AutoLockpicks when starting the minigame',
})

--/#

--// Notify Items

Notificate:AddToggle('NotificateItemsToggle', {
    Text = 'Enabled',
    Default = true, --false
    Tooltip = 'Notificates when a selected item spawns',
})

NotifItems = Toggles.NotificateItemsToggle.Value

Toggles.NotificateItemsToggle:OnChanged(function()
	NotifItems = Toggles.NotificateItemsToggle.Value
end)

Notificate:AddDropdown('NotificateItemsFilter', {
    Values = { 'Food','Healing','Misc','Melees', 'Guns', 'Armors', 'Keycards'},
    Default = 1,
    Multi = true,
    Text = 'Notification Filter',
    Tooltip = 'Allowed types to notificate',
})

PlayerGui.Minigames.MinigameState.Changed:Connect(function()

	if Toggles.AutoLockpickToggle.Value then

		for _,Instance in pairs(LootAreas) do
			print(Instance)
			for __, Target in pairs(Instance:GetChildren) do
				LockPick(Target,true)
			end
		end
		
	end

end)

--/#

--// Start Missions

Missions:AddButton('Start Cargo Ambush', function()
	StartMission("StealCargo", true)
end)

Options.AutoLootFilter:OnChanged(function()
--[[
	for index, value in next, Options.AutoLootFilter.Value do
        print(index, value)
    end
--]]
end)

Toggles.AutoLootToggle:OnChanged(function()

end)

Library:SetWatermarkVisibility(true)
Library:SetWatermark('LackSkill Hub')

Library:OnUnload(function()
    print('Unloaded!')
    Library.Unloaded = true
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

Library:Notify("Loaded UI", 5)
Library:Notify("Script loaded in ".. (tick() - Started), 5)
