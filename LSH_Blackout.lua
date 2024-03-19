
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

local sharedRequires = {};

sharedRequires['1131354b3faa476e8cf67a829e7e64a41ecd461a3859adfe16af08354df80d2b'] = (function()
	local Signal = {}
	Signal.__index = Signal
	Signal.ClassName = "Signal"
	
	function Signal.new()
		local self = setmetatable({}, Signal)
	
		self._bindableEvent = Instance.new("BindableEvent")
		self._argData = nil
		self._argCount = nil
	
		return self
	end
	
	function Signal.isSignal(object)
		return typeof(object) == 'table' and getmetatable(object) == Signal;
	end;

	function Signal:Fire(...)
		self._argData = {...}
		self._argCount = select("#", ...)
		self._bindableEvent:Fire()
		self._argData = nil
		self._argCount = nil
	end

	function Signal:Connect(handler)
		if not self._bindableEvent then return error("Signal has been destroyed"); end --Fixes an error while respawning with the UI injected
	
		if not (type(handler) == "function") then
			error(("connect(%s)"):format(typeof(handler)), 2)
		end
	
		return self._bindableEvent.Event:Connect(function()
			handler(unpack(self._argData, 1, self._argCount))
		end)
	end

	function Signal:Wait()
		self._bindableEvent.Event:Wait()
		assert(self._argData, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
		return unpack(self._argData, 1, self._argCount)
	end
	
	function Signal:Destroy()
		if self._bindableEvent then
			self._bindableEvent:Destroy()
			self._bindableEvent = nil
		end
	
		self._argData = nil
		self._argCount = nil
	end
	
	return Signal
end)();

sharedRequires['4d7f148d62e823289507e5c67c750b9ae0f8b93e49fbe590feb421847617de2f'] = (function()

	local Signal = sharedRequires['1131354b3faa476e8cf67a829e7e64a41ecd461a3859adfe16af08354df80d2b'];
	local tableStr = "table";
	local classNameStr = "Maid";
	local funcStr = "function";
	local threadStr = "thread";
	
	local Maid = {}
	Maid.ClassName = "Maid"

	function Maid.new()
		return setmetatable({
			_tasks = {}
		}, Maid)
	end
	
	function Maid.isMaid(value)
		return type(value) == tableStr and value.ClassName == classNameStr
	end

	function Maid.__index(self, index)
		if Maid[index] then
			return Maid[index]
		else
			return self._tasks[index]
		end
	end
                           it is destroyed.
	function Maid:__newindex(index, newTask)
		if Maid[index] ~= nil then
			error(("'%s' is reserved"):format(tostring(index)), 2)
		end
	
		local tasks = self._tasks
		local oldTask = tasks[index]
	
		if oldTask == newTask then
			return
		end
	
		tasks[index] = newTask
	
		if oldTask then
			if type(oldTask) == "function" then
				oldTask()
			elseif typeof(oldTask) == "RBXScriptConnection" then
				oldTask:Disconnect();
			elseif typeof(oldTask) == 'table' then
				oldTask:Remove();
			elseif (Signal.isSignal(oldTask)) then
				oldTask:Destroy();
			elseif (typeof(oldTask) == 'thread') then
				task.cancel(oldTask);
			elseif oldTask.Destroy then
				oldTask:Destroy();
			end
		end
	end

	function Maid:GiveTask(task)
		if not task then
			error("Task cannot be false or nil", 2)
		end
	
		local taskId = #self._tasks+1
		self[taskId] = task
	
		return taskId
	end

	function Maid:DoCleaning()
		local tasks = self._tasks
	
		for index, task in pairs(tasks) do
			if typeof(task) == "RBXScriptConnection" then
				tasks[index] = nil
				task:Disconnect()
			end
		end

		local index, taskData = next(tasks)
		while taskData ~= nil do
			tasks[index] = nil
			if type(taskData) == funcStr then
				taskData()
			elseif typeof(taskData) == "RBXScriptConnection" then
				taskData:Disconnect()
			elseif (Signal.isSignal(taskData)) then
				taskData:Destroy();
			elseif typeof(taskData) == tableStr then
				taskData:Remove();
			elseif (typeof(taskData) == threadStr) then
				task.cancel(taskData);
			elseif taskData.Destroy then
				taskData:Destroy()
			end
			index, taskData = next(tasks)
		end
	end
	
	Maid.Destroy = Maid.DoCleaning
	
	return Maid;
end)();

--/#

local Maid = sharedRequires['4d7f148d62e823289507e5c67c750b9ae0f8b93e49fbe590feb421847617de2f'];
local maid = Maid.new();
local Started = tick()
local is_synapse_function = isexecutorclosure

local gameId = game.GameId;
local jobId, placeId = game.JobId, game.PlaceId;
local userId = game.Players.LocalPlayer.UserId;

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

Options.AutoLootFilter:OnChanged(function()
--[[
	for index, value in next, Options.AutoLootFilter.Value do
        print(index, value)
    end
--]]
end)

Toggles.FlyToggle:OnChanged(function()
	
	if (not Toggles.FlyToggle.Value) then
		maid.speedHack = nil
		maid.speedHackBv = nil
		return
	end

	maid.speedHack = RunService.Heartbeat:Connect(function()
		local humanoid, rootPart = Character.Humanoid, Character.PrimaryPart;

		if (not humanoid or not rootPart) then return end;

		if (library.flags.fly) then
			maid.speedHackBv = nil;
			return;
		end;

		maid.speedHackBv = maid.speedHackBv or Instance.new('BodyVelocity');
		maid.speedHackBv.MaxForce = Vector3.new(100000, 0, 100000);

		if (not CollectionService:HasTag(maid.speedHackBv, 'AllowedBM')) then
			CollectionService:AddTag(maid.speedHackBv, 'AllowedBM');
		end;

		maid.speedHackBv.Parent = not library.flags.fly and rootPart or nil;
		maid.speedHackBv.Velocity = (humanoid.MoveDirection.Magnitude ~= 0 and humanoid.MoveDirection or gethiddenproperty(humanoid, 'WalkDirection')) * Options.FlySpeed.Value;
	end);
	
end)

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

local GuiLoaded
local LocalPlayer = game.Players.LocalPlayer
local PlayerGui = game.Players.LocalPlayer.PlayerGui
local Character = LocalPlayer.Character
local CharacterRoot = Character:WaitForChild("HumanoidRootPart")
local LootTables = {}
local PlayerDeathBagsLootTable = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = Instance.new("VirtualInputManager")
local Events = ReplicatedStorage:WaitForChild("Events")
local Map = workspace:WaitForChild("Map")
local Bunker_LootAutoFarmPath = Map.Special.Bunker.Streaming
local BunkerLoot = {}
local NPCs = workspace:WaitForChild("NPCs")
local Other_NPCs = NPCs:WaitForChild("Other")
local AutoLootLOLOLL = false
local AutoLockPikcLOLO = false
local NotifItems = false
local ProxPrompts = {}
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

function II_C()

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

				if Toggles.AutoLootToggle.Value == true then
					task.wait(.6)
					PickUpItem(ProxPrompt.Parent:FindFirstChild("LootTable"),"Cash",nil)
					task.wait(.6)
					PickUpItem(ProxPrompt.Parent:FindFirstChild("LootTable"),"Valuables",nil)
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

--/#


Library:Notify("Loaded UI", 5)
Library:Notify("Script loaded in ".. (tick() - Started), 5)
local BunkerAutoFarmAt = 1
local autoFarmWaitTick = tick()

RunService.Heartbeat:Connect(function()
	task.wait()

	if Toggles.BreakAI.Value == true then
		CharacterRoot.Velocity = (CharacterRoot.CFrame.LookVector.Unit * 20) + Vector3.new(0,-1000,0);
	end

    if Toggles.Bunker_AutoFarm.Value == true and (tick() - autoFarmWaitTick) > 3 then
		CharacterRoot.Anchored = true
		local LootModel = BunkerLoot[BunkerAutoFarmAt]
		TPtoLootAndPickUp(LootModel.LootBase,false)
		BunkerAutoFarmAt += 1
		autoFarmWaitTick = tick()

		if BunkerAutoFarmAt >= #BunkerLoot then
			BunkerAutoFarmAt = 1
		end
	elseif Toggles.Bunker_AutoFarm.Value == true then
		CharacterRoot.Anchored = true
	else
		CharacterRoot.Anchored = false
	end

end)
