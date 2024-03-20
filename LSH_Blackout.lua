
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

local LocalPlayer = game.Players.LocalPlayer
local PlayerGui = game.Players.LocalPlayer.PlayerGui
local Character = LocalPlayer.Character
local mouse = LocalPlayer:GetMouse()

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharacterRoot = Character:WaitForChild("HumanoidRootPart")
local VirtualInputManager = Instance.new("VirtualInputManager")

local Events = ReplicatedStorage:WaitForChild("Events")
local Map = workspace:WaitForChild("Map")
local Bunker_LootAutoFarmPath = Map.Special.Bunker.Streaming
local NPCs = workspace:WaitForChild("NPCs")
local Other_NPCs = NPCs:WaitForChild("Other")

local AutoLootLOLOLL = false
local AutoLockPikcLOLO = false
local NotifItems = false

local PlayerDeathBagsLootTable = {}
local BunkerLoot = {}
local ProxPrompts = {}
local LootTables = {}
local InstancessLol = {}
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}

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
--// Even more tabs

local Movement = LeftSideTab1_:AddTab('Movement')
local AutoLoot = LeftSideTab1:AddTab('AutoLoot')
local Notificate = LeftSideTab2:AddTab('Notify items')
local QualityOfLive = LeftSideTab3:AddTab('Quality Of Live')
local Missions = LeftSideTab4:AddTab('Missions')
local AutofarmTab = LeftSideTab5:AddTab('Auto farms')
--//#

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

    Default = 15,
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

local ItemsTypes = {
	["Energy Bar"] = "Food",
	["Energy Drink"] = "Food",
	["Soda"] = "Food",
	["Medkit"] = "Healing",
	["Trauma Pad"] = "Healing",
	["Lockpick"] = "Misc",
	["Tactical Leggings"] = "Armour",
}

--// Events

local PickUpEvent = Events:WaitForChild("Loot"):WaitForChild("LootObject")
local StartTask = Events:WaitForChild("Stations"):WaitForChild("StartTask")
local MinigameResult = Events:WaitForChild("Loot"):WaitForChild("MinigameResult")
--/#

--// Functions 

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
	Events:WaitForChild("Player"):WaitForChild("Ragdoll"):FireServer()
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

local function CollectLootFromLootTable(LootTable)
	local ItemsInLootTable = LootTable:GetChildren()
	local CurrentItemIndex = 1

	--[[
	for _, Item in pairs(ItemsInLootTable) do
		PickUpItem(LootTable,Item,true)
		task.wait(1)
	end
    --]]

	task.wait(1)
	PickUpItem(LootTable,"Cash",nil)
	task.wait(1)
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

for _, ProxPrompt in pairs(workspace:WaitForChild("Map"):GetDescendants()) do
	
	if ProxPrompt:IsA("ProximityPrompt") then
		table.insert(ProxPrompts,ProxPrompt)
		ProxPrompt:SetAttribute("_Original_HoldTime", ProxPrompt.HoldDuration)

		ProxPrompt.Triggered:Connect(function()

			if ProxPrompt.Name == "LockMinigame" then

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

for _,Lootinstancee in pairs(Bunker_LootAutoFarmPath:GetDescendants()) do
	if Lootinstancee.Parent.Name == "Loot" then
		table.insert(BunkerLoot,Lootinstancee)
	end
end

--/#

--//Events

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

local BunkerAutoFarmAt = 1
local autoFarmWaitTick = tick()

RunService.Heartbeat:Connect(function()
	task.wait()

	if not LocalPlayer.Character:FindFirstChild("Humanoid") then return end
	if LocalPlayer.Character.Humanoid.Health <= 0 then return end

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
	else
		CharacterRoot.Anchored = false
	end

end)
