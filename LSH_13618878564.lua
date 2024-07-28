
if _G.LACKSKILL_LOADED == true then
	game.Players.LocalPlayer:Kick("LACKSKILL HUB: plz dont execute teh script more than one time.")
end

_G.LACKSKILL_LOADED = true
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = PlayerService.LocalPlayer
local Character = LocalPlayer.Character
local Cam = workspace.CurrentCamera
local GetMouseLocation = UserInputService.GetMouseLocation
local GetPartsObscuringTarget = Cam.GetPartsObscuringTarget
local FindFirstChild = game.FindFirstChild
local mouse = LocalPlayer:GetMouse()

local ESPFramework = loadstring(game:HttpGet("https://raw.githubusercontent.com/LARTAJE/LSH_Main/main/EF.lua", true))()
local ValidTargetParts = {"Head", "Torso"};
local BulletTracerColor = Color3.new(1,1,1)

local WorldToScreen = Cam.WorldToScreenPoint
local WorldToViewportPoint = Cam.WorldToViewportPoint
local GetPartsObscuringTarget = Cam.GetPartsObscuringTarget

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

local SilentAIMFov = Drawing.new("Circle")
SilentAIMFov.Thickness = 1
SilentAIMFov.NumSides = 100
SilentAIMFov.Radius = 360
SilentAIMFov.Filled = false
SilentAIMFov.Visible = false
SilentAIMFov.ZIndex = 999
SilentAIMFov.Transparency = 1
SilentAIMFov.Color = Color3.fromRGB(255,255,255)

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
task.wait(math.random(1,4)) --Fake loading lol (kinda since it can crashes if it loads to fast)

--// Tabs

local Tabs = {
	Main = Window:AddTab('Main'), 
	ESP = Window:AddTab('ESP'),
	Customization = Window:AddTab('Customization'),
	['UI Settings'] = Window:AddTab('Settings'),
}
--/#

--// UI Stuff

local CustomizationTab0 = Tabs.Customization:AddLeftTabbox()
local CustomizationTab1 = Tabs.Customization:AddRightTabbox()

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
local QualityOfLive = LeftSideTab3:AddTab('Quality Of Live')
local SilentAim = RightSideTab1:AddTab('Silent Aim')
local GunStuff = RightSideTab1:AddTab('Gun Stuff')
--//Custom
local ColorsTab = CustomizationTab0:AddTab('colors')
local VisualsTab = CustomizationTab1:AddTab('VisualsTab')

--//ESPs
local ESP_MAIN = ESP_LeftSideTab1:AddTab('ESP')

ESP_MAIN:AddToggle('Esp', {
	Text = 'Enabled',
	Default = false,
	Tooltip = 'ESP toggle.',
	
	Callback = function(state)
		ESPFramework.Color = Color3.fromRGB(255,255,255)
		ESPFramework.FaceCamera = true
		ESPFramework:Toggle(state)
	end,
})

ESP_MAIN:AddToggle('BoxEsp', {
	Text = 'Box ESP',
	Default = false,
	Tooltip = 'Show box esp toggle.',
	
	Callback = function(state)
		ESPFramework.Boxes = state
	end,
})
ESP_MAIN:AddToggle('NameEsp', {
	Text = 'Show names',
	Default = false,
	Tooltip = 'Shows players names.',
	
	Callback = function(state)
		ESPFramework.Names = state
	end,
})

ESP_MAIN:AddToggle('HealthBarESP', {
	Text = 'Show health bars',
	Default = false,
	Tooltip = 'Enables health bars.',
	
	Callback = function(state)
		ESPFramework.Health = state
	end,
})

ESP_MAIN:AddToggle('ShowDistanceESP', {
	Text = 'Show distance',
	Default = false,
	Tooltip = 'Enables tracers.',
	
	Callback = function(state)
		ESPFramework.Distance = state
	end,
})

ESP_MAIN:AddToggle('TracerEsp', {
	Text = 'Show tracers',
	Default = false,
	Tooltip = 'Enables tracers.',
	
	Callback = function(state)
		ESPFramework.Tracers = state
	end,
})

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
	Tooltip = 'Checks if target player is in vision. WARNING THIS INCLUDES DEBRIS)',
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

VisualsTab:AddToggle('ShowBulletTracers', {
	Text = 'Bullet tracers',
	Default = false, --false
	Tooltip = 'Show your bullet tracers.',
})

GunStuff:AddToggle('CrazyFirerate', {
	Text = 'Rapid fire',
	Default = false, --false
	Tooltip = 'Shoot... really fast.',

	Callback = function(Value)
		if Value == true then
			for _, GunProperties in ReplicatedStorage.GunProperties:GetChildren() do
				local Gun = require(GunProperties)
				if not GunProperties:GetAttribute("OriginalFirerate") then
					GunProperties:SetAttribute("OriginalFirerate", Gun.FireRate)
				end
				Gun.FireRate = 0
			end
		else
			for _, GunProperties in ReplicatedStorage.GunProperties:GetChildren() do
				local Gun = require(GunProperties)
				Gun.FireRate = GunProperties:GetAttribute("OriginalFirerate")
			end
		end
	end
})

GunStuff:AddToggle('InfiniteAmmo_M', {
	Text = 'Infinite mag',
	Default = false, --false
	Tooltip = 'Makes your mag ammunition infinite lol.',

	Callback = function(Value)
		if Value == true then
			for _, GunProperties in ReplicatedStorage.GunProperties:GetChildren() do
				local Gun = require(GunProperties)
				if not GunProperties:GetAttribute("OriginalMag") then
					GunProperties:SetAttribute("OriginalMag", Gun.ClipAmmo)
				end
				Gun.ClipAmmo = math.huge
			end
		else
			for _, GunProperties in ReplicatedStorage.GunProperties:GetChildren() do
				local Gun = require(GunProperties)
				Gun.ClipAmmo = GunProperties:GetAttribute("OriginalMag")
			end
		end
	end
})

GunStuff:AddToggle('InfiniteAmmo_M', {
	Text = 'Infinite reserve ammo',
	Default = false, --false
	Tooltip = 'Makes your reserve ammunition infinite lol.',

	Callback = function(Value)
		if Value == true then
			for _, GunProperties in ReplicatedStorage.GunProperties:GetChildren() do
				local Gun = require(GunProperties)
				if not GunProperties:GetAttribute("OriginalReserve") then
					GunProperties:SetAttribute("OriginalReserve", Gun.MaxAmmo)
				end
				Gun.MaxAmmo = math.huge
			end
		else
			for _, GunProperties in ReplicatedStorage.GunProperties:GetChildren() do
				local Gun = require(GunProperties)
				Gun.MaxAmmo = GunProperties:GetAttribute("OriginalReserve")
			end
		end
	end
})

GunStuff:AddToggle('NoSpread', {
	Text = 'No spread',
	Default = false, --false
	Tooltip = 'Removes your spread.',
	
	Callback = function(Value)
		if Value == true then
			for _, GunProperties in ReplicatedStorage.GunProperties:GetChildren() do
				local Gun = require(GunProperties)
				if not GunProperties:GetAttribute("OriginalSpread") then
					GunProperties:SetAttribute("OriginalSpread", Gun.Spread)
				end
				Gun.Spread = 0
			end
		else
			for _, GunProperties in ReplicatedStorage.GunProperties:GetChildren() do
				local Gun = require(GunProperties)
				Gun.Spread = GunProperties:GetAttribute("OriginalSpread")
			end
		end
	end
})

Library:SetWatermarkVisibility(true)
Library:SetWatermark('LackSkill Hub')

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
SaveManager:LoadAutoloadConfig()


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

local function CalculateChance(Percentage)
	Percentage = math.floor(Percentage)
	local chance = math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100) / 100
	return chance <= Percentage / 100
end

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
	local ToCheck = {}

	for _, Player in next, GetPlayers(Players) do
		if Player == LocalPlayer then continue end
		local _Character = Player.Character
		if not _Character then continue end
		table.insert(ToCheck, _Character)

		if Toggles.VisibleCheck.Value and not IsPlayerVisible(Player) then continue end
		if Toggles.IgnoreFriends.Value and Player:IsFriendsWith(LocalPlayer.UserId) then continue end

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

local function CreateTracer(Origin: Vector3, Goto: Vector3)
	local Tracer = Instance.new("Part")
	Tracer.Material = Enum.Material.ForceField
	Tracer.Transparency = 0.5
	Tracer.Color = BulletTracerColor
	Tracer.Parent = workspace.Debris
	Tracer.Anchored = true
	Tracer.CanCollide = false
	Tracer.Size = Vector3.new(0.1, 0.1, (Goto - Origin).Magnitude + 1)
	Tracer.CFrame = CFrame.lookAt((Origin + Goto) / 2, Goto)
	task.delay(5, function()
		Tracer:Destroy()
	end)
end

local oldNamecall

oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
	local Method = getnamecallmethod()

	local Arguments = {...}
	local self = Arguments[1]

	local chance = CalculateChance(Options.SilentAimHitChanceSlider.Value)

	if self == workspace and not checkcaller() and Method == "Raycast" then
		if ValidateArguments(Arguments, ExpectedArguments.Raycast) and Arguments[4]["FilterDescendantsInstances"][1] == LocalPlayer.Character and Arguments[4]["FilterDescendantsInstances"][2] == workspace.Debris then
			local A_Origin = Arguments[2]
			local HitPart = getClosestPlayer()

			local function F_CastRay(origin: Vector3, direction: Vector3)
				local raycastParams = RaycastParams.new()
				raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
				raycastParams.FilterDescendantsInstances = {workspace.CurrentCamera, Character} -- Ignore the camera

				local raycastResult = workspace:Raycast(origin, direction, raycastParams)

				return raycastResult.Position
			end

			if chance == true and Toggles.SilentAimToggle.Value == true then
				if HitPart then
					Arguments[3] = getDirection(A_Origin, HitPart.Position)
					CreateTracer(A_Origin, HitPart.Position)
					return oldNamecall(unpack(Arguments))
				else
					return oldNamecall(...)
				end
			end

			if Toggles.ShowBulletTracers.Value == true then
				local pos = F_CastRay(A_Origin, Arguments[3])
				CreateTracer(A_Origin, pos)
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

LocalPlayer.CharacterAdded:Connect(function(_Character)
	Character = _Character
end)
