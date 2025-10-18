-- ! Main
getgenv().Toggles = {}
getgenv().Sliders = {}
getgenv().Dropdowns = {}
getgenv().TextBoxes = {}
getgenv().Keypickers = {}
getgenv().Colorpickers = {}
getgenv().Relations = {}

local Library = {
	Connections = {},
	Notifications = {},

	Objects = {},
	Registery = {},
	Stats = {},

	Theme = {
		["Accent"] = Color3.fromRGB(43, 89, 255),

		["Background 1"] = Color3.fromRGB(18, 22, 32),
		["Background 2"] = Color3.fromRGB(24, 30, 42),
		["Background 3"] = Color3.fromRGB(15, 18, 28),

		["Border 1"] = Color3.fromRGB(0, 0, 0),
		["Border 2"] = Color3.fromRGB(28, 35, 50),
		["Border 3"] = Color3.fromRGB(35, 45, 65),

		["Selected Tab"] = Color3.fromRGB(20, 26, 38),
		["Unselected Tab"] = Color3.fromRGB(18, 22, 32),

		["Selected Section"] = Color3.fromRGB(26, 32, 45),
		["Unselected Section"] = Color3.fromRGB(30, 38, 52),

		["Section Background"] = Color3.fromRGB(22, 28, 40),
		["Option Background"] = Color3.fromRGB(32, 40, 55),

		["Active Text"] = Color3.fromRGB(255, 255, 255),
		["Inactive Text"] = Color3.fromRGB(185, 195, 210),
		["Warning Text"] = Color3.fromRGB(255, 110, 110),
	},

	Debug = false,
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")

local Client = Players.LocalPlayer
local Mouse = Client:GetMouse()
local Camera = Workspace.CurrentCamera

local MainGUI = Instance.new("ScreenGui")
MainGUI.Name = "FONDRA"
MainGUI.ResetOnSpawn = false
MainGUI.IgnoreGuiInset = true
MainGUI.Parent = CoreGui
MainGUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
MainGUI.DisplayOrder = 1000000000

local MenuGUI = Instance.new("ScreenGui")
MenuGUI.Name = "MENUS"
MenuGUI.ResetOnSpawn = false
MenuGUI.IgnoreGuiInset = true
MenuGUI.Parent = MainGUI
MenuGUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
MenuGUI.DisplayOrder = 1000000 + 1

local ComponentsGUI = Instance.new("ScreenGui")
ComponentsGUI.Name = "COMPONENTS"
ComponentsGUI.ResetOnSpawn = false
ComponentsGUI.IgnoreGuiInset = true
ComponentsGUI.Parent = MainGUI
ComponentsGUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
ComponentsGUI.DisplayOrder = 1000000 + 2

local NotificationsGUI = Instance.new("ScreenGui")
NotificationsGUI.Name = "Notifications"
NotificationsGUI.ResetOnSpawn = false
NotificationsGUI.IgnoreGuiInset = true
NotificationsGUI.Parent = MainGUI
NotificationsGUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
NotificationsGUI.DisplayOrder = 1000000 + 3

local Cache = {}
local Functions = {}
Library.Functions = Functions
do
	-- ! Necessary
	Functions["AddConnection"] = function(Name, Type, Callback)
		local Connection = Type:Connect(Callback)
		local Index = #Library.Connections + 1

		Library.Connections[Name == nil and Index or Name] = Connection

		return Index
	end

	Functions["RemoveConnection"] = function(Identifier)
		if Library.Connections[Identifier] then
			Library.Connections[Identifier]:Disconnect()
			Library.Connections[Identifier] = nil

			return true
		end

		return false
	end

	Functions["AddThemeRegistery"] = function(Object, Data)
		for Property, ThemeKey in next, Data do
			if typeof(ThemeKey) == "Color3" then
				Object[Property] = ThemeKey
			else
				Object[Property] = Library.Theme[ThemeKey]
			end
		end

		Library.Registery[Object] = Data
	end

	Functions["UpdateThemeRegistery"] = function(Object, Data)
		Library.Registery[Object] = Data

		for Property, ThemeKey in next, Data do
			if typeof(ThemeKey) == "Color3" then
				Object[Property] = ThemeKey
			else
				Object[Property] = Library.Theme[ThemeKey]
			end
		end
	end

	Functions["RefreshThemeRegistery"] = function()
		for Object, Data in next, Library.Registery do
			for Property, ThemeKey in next, Data do
				if typeof(ThemeKey) == "Color3" then
					Object[Property] = ThemeKey
				else
					Object[Property] = Library.Theme[ThemeKey]
				end
			end
		end
	end

	Functions["EnsurePath"] = function(Path)
		local Build = ""
		for Folder in string.gmatch(Path, "([^/]+)/") do
			Build ..= Folder .. "/"
			if not isfolder(Build) then
				makefolder(Build)
			end
		end
	end

	Functions["CustomAsset"] = function(Path, Link)
		if Cache[Path] then
			return Cache[Path]
		end
		
		Functions["EnsurePath"](Path)

		if not isfile(Path) then
			if not Link then
				return Client:Kick("WTF??")
			end

			local Success, Result = pcall(function()
				return game:HttpGet(Link)
			end)

			if not Success then
				return nil
			end

			if not Result or Result == "" then
				return nil
			end

			writefile(Path, Result)
		end

		Cache[Path] = getcustomasset(Path)

		return Cache[Path]
	end

	Functions["Create"] = function(Class, Properties)
		local Object = Instance.new(Class)

		pcall(function()
			Object.BorderSizePixel = 0
		end)
		pcall(function()
			Object.AutoButtonColor = false
		end)
		pcall(function()
			Object.Text = ""
		end)

		for Property, Value in next, Properties do
			pcall(function()
				Object[Property] = Value
			end)
		end

		Library.Objects[#Library.Objects + 1] = Object

		return Object
	end

	Functions["GetTextBounds"] = function(Text, Size, Font)
		local Bounds = Vector2.new(0, 0)
		local Label = Functions["Create"]("TextLabel", {
			Text = Text,
			TextSize = Size,
			FontFace = Font,
			Visible = false,
			Parent = MainGUI,
		})

		repeat
			task.wait()
		until Label.TextBounds ~= Vector2.new(0, 0)

		Bounds = Label.TextBounds

		Label:Destroy()

		return Bounds
	end

	-- Functions["CheckIfInsideFrame"] = function(TargetFrame)
	-- 	if not TargetFrame or not TargetFrame:IsA("GuiObject") then
	-- 		return false
	-- 	end

	-- 	local Location = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
	-- 	local AbsolutePosition = TargetFrame.AbsolutePosition
	-- 	local AbsoluteSize = TargetFrame.AbsoluteSize

	-- 	local Inside = Location.X >= AbsolutePosition.X
	-- 		and Location.X <= AbsolutePosition.X + AbsoluteSize.X
	-- 		and Location.Y >= AbsolutePosition.Y
	-- 		and Location.Y <= AbsolutePosition.Y + AbsoluteSize.Y

	-- 	if not Inside then
	-- 		return false
	-- 	end

	-- 	local Parent = TargetFrame.Parent
	-- 	while Parent and not Parent:IsA("ScreenGui") do
	-- 		if not Parent.Visible then
	-- 			return false
	-- 		end
	-- 		Parent = Parent.Parent
	-- 	end

	-- 	local GuiObjects = PlayerGui:GetGuiObjectsAtPosition(Location.X, Location.Y)

	-- 	for _, GuiObject in next, GuiObjects do
	-- 		if GuiObject.Visible and not GuiObject:IsA("ScreenGui") then
	-- 			if GuiObject.BackgroundTransparency and GuiObject.BackgroundTransparency >= 1 then
	-- 				if GuiObject:IsA("ImageLabel") or GuiObject:IsA("ImageButton") then
	-- 					if GuiObject.ImageTransparency and GuiObject.ImageTransparency >= 1 then
	-- 						continue
	-- 					end
	-- 				elseif GuiObject:IsA("TextButton") and GuiObject.Text == "" then
	-- 					continue
	-- 				else
	-- 					continue
	-- 				end
	-- 			end

	-- 			if GuiObject.Interactable ~= nil and not GuiObject.Interactable then
	-- 				continue
	-- 			end

	-- 			if GuiObject ~= TargetFrame and not GuiObject:IsDescendantOf(TargetFrame) then
	-- 				return false
	-- 			end
	-- 		end
	-- 	end

	-- 	return true
	-- end
end

local Fonts = {
	["Smallest Pixel 7"] = "https://github.com/Fondra-Hub/Assets/raw/refs/heads/main/Fonts/Smallest%20Pixel%207.ttf",
	["04B_03"] = "https://github.com/Fondra-Hub/Assets/raw/refs/heads/main/Fonts/04B_03__.ttf",
	["04B_08"] = "https://github.com/Fondra-Hub/Assets/raw/refs/heads/main/Fonts/04B_08.ttf",
	["Perfect DOS VGA 437"] = "https://github.com/Fondra-Hub/Assets/raw/refs/heads/main/Fonts/Perfect%20DOS%20VGA%20437.ttf",
	["Pixeboy"] = "https://github.com/Fondra-Hub/Assets/raw/refs/heads/main/Fonts/Pixeboy.ttf",
	["Press Start 2P"] = "https://github.com/Fondra-Hub/Assets/raw/refs/heads/main/Fonts/Press%20Start%202P.ttf",
	["VCR OSD Mono"] = "https://github.com/Fondra-Hub/Assets/raw/refs/heads/main/Fonts/VCR%20OSD%20Mono.ttf",
	["Monocraft"] = "https://github.com/Fondra-Hub/Assets/raw/refs/heads/main/Fonts/Monocraft.ttf",
	["Proggy"] = "https://github.com/Fondra-Hub/Assets/raw/refs/heads/main/Fonts/Proggy.ttf",
}

Functions["EnsurePath"]("Fondra/Assets/Fonts/TTF/")
Functions["EnsurePath"]("Fondra/Assets/Fonts/JSON/")

for Name, Link in next, Fonts do
	local Path = "Fondra/Assets/Fonts/TTF/" .. Name .. ".ttf"
	local AssetId = Functions["CustomAsset"](Path, Link)

	writefile(
		"Fondra/Assets/Fonts/JSON/" .. Name .. ".json",
		game:GetService("HttpService"):JSONEncode({
			name = Name,
			faces = {
				{
					name = "Regular",
					weight = 400,
					style = "normal",
					assetId = AssetId,
				},
			},
		})
	)
end

local CustomFont = Font.new(
	Functions["CustomAsset"]("Fondra/Assets/Fonts/JSON/Proggy.json"),
	Enum.FontWeight.Regular,
	Enum.FontStyle.Normal
)

local Components = {}
do
	Components["Toggle"] = function(Holder, Options)
		local Options = {
			Text = Options.Text or "TOGGLE",
			Flag = Options.Flag,
			Callback = Options.Callback,
			Dangerous = Options.Dangerous == true and true or false,
			Value = Options.Value == true and true or false,
		}

		local Toggle = {
			Value = not Options.Value,
		}

		local ToggleOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(0, 2, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Parent = Holder,
			Interactable = false,
		})

		local ToggleMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = ToggleOutline,
		})

		local ToggleInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = ToggleMiddle,
		})

		local ToggleFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = ToggleInline,
		})

		local ToggleLabel = Functions["Create"]("TextLabel", {
			Parent = ToggleOutline,
			Text = Options.Text,
			Position = UDim2.new(1, 2, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})

		Functions["Create"]("UIStroke", {
			Parent = ToggleLabel,
		})

		Functions["AddThemeRegistery"](ToggleOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](ToggleMiddle, { BackgroundColor3 = "Option Background" })
		Functions["AddThemeRegistery"](ToggleInline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](ToggleFill, { BackgroundColor3 = "Option Background" })
		Functions["AddThemeRegistery"](
			ToggleLabel,
			{ TextColor3 = Options.Dangerous and "Warning Text" or "Active Text" }
		)

		local Addons = {}
		function RefreshAddons()
			local Offset = 0
			for Index, Addon in next, Addons do
				Offset = Offset - 2 - (Index == 1 and 0 or Addon.Objects.Main.Size.X.Offset + 2)
				Addon.Objects.Main.Position = UDim2.new(1, Offset, 0.5, 0)
			end
		end

		function Toggle:Set(Bool)
			if Toggle.Value == Bool then
				return
			end

			Toggle.Value = Bool

			Functions["UpdateThemeRegistery"](ToggleMiddle, {
				BackgroundColor3 = Bool and "Accent" or "Option Background",
			})

			Functions["UpdateThemeRegistery"](ToggleFill, {
				BackgroundColor3 = Bool and "Accent" or "Option Background",
			})

			for _, Addon in next, Addons do
				if Addon.Objects and Addon.Objects.Display then
					if Addon.Objects.Sync == true then
						Addon.Objects.Display:SetTheme({
							TextColor3 = Bool and "Accent" or "Inactive Text",
						})
					end
				end
			end

			if Options.Callback then
				task.spawn(Options.Callback, Bool)
			end
		end

		function Toggle:Get()
			return { Value = Toggle.Value }
		end

		function Toggle:Callback(Function)
			Options.Callback = Function
		end

		function Toggle:Keypicker(Options)
			local Keypicker = Components["Keypicker"](Holder, Options, Toggle)
			table.insert(Addons, Keypicker)
			RefreshAddons()
			return Toggle
		end

		function Toggle:Colorpicker(Options)
			local Colorpicker = Components["Colorpicker"](Holder, Options, Toggle)
			table.insert(Addons, Colorpicker)
			RefreshAddons()
			return Toggle
		end

		Functions["AddConnection"](nil, Holder.MouseButton1Down, function()
			Toggle:Set(not Toggle.Value)
		end)

		Toggle:Set(Options.Value)

		if Options.Flag then
			Toggles[Options.Flag] = Toggle
		end

		return Toggle
	end

	Components["Slider"] = function(Holder, Options)
		local Options = {
			Text = Options.Text or "SLIDER",
			Flag = Options.Flag,
			Callback = Options.Callback,
			Minimum = Options.Minimum or 0,
			Current = Options.Current or 50,
			Maximum = Options.Maximum or 100,
			Decimals = Options.Decimals or 1,
			Format = Options.Format or "${CURRENT}/${MAXIMUM}",
		}

		local Slider = {
			Current = Options.Current,
		}

		local SliderOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			Parent = Holder,
			Interactable = false,
		})

		local SliderMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = SliderOutline,
		})

		local SliderInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = SliderMiddle,
		})

		local SliderFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = SliderInline,
		})

		local SliderAccent = Functions["Create"]("Frame", {
			Size = UDim2.new(0.5, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Parent = SliderFill,
		})

		local SliderTextLabel = Functions["Create"]("TextLabel", {
			Parent = SliderFill,
			Text = Options.Text,
			Position = UDim2.new(0, 2, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})

		local SliderAmountLabel = Functions["Create"]("TextLabel", {
			Parent = SliderFill,
			Text = Options.Text,
			Position = UDim2.new(1, -2, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})

		Functions["Create"]("UIStroke", { Parent = SliderTextLabel })
		Functions["Create"]("UIStroke", { Parent = SliderAmountLabel })

		Functions["AddThemeRegistery"](SliderOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](SliderMiddle, { BackgroundColor3 = "Option Background" })
		Functions["AddThemeRegistery"](SliderInline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](SliderFill, { BackgroundColor3 = "Option Background" })
		Functions["AddThemeRegistery"](SliderAccent, { BackgroundColor3 = "Accent" })
		Functions["AddThemeRegistery"](SliderTextLabel, { TextColor3 = "Active Text" })
		Functions["AddThemeRegistery"](SliderAmountLabel, { TextColor3 = "Active Text" })

		function Slider:Set(Number)
			if Options.Decimals > 0 then
				Number = math.floor(Number * (10 ^ Options.Decimals) + 0.5) / (10 ^ Options.Decimals)
			else
				Number = math.floor(Number + 0.5)
			end

			Slider.Current = math.clamp(Number, Options.Minimum, Options.Maximum)

			local Percentage = (Slider.Current - Options.Minimum) / (Options.Maximum - Options.Minimum)
			SliderAccent.Size = UDim2.new(Percentage, 0, 1, 0)
			SliderAmountLabel.Text = Options.Format
				:gsub("${MINIMUM}", tostring(Options.Minimum))
				:gsub("${CURRENT}", tostring(Slider.Current))
				:gsub("${MAXIMUM}", tostring(Options.Maximum))

			if Options.Callback then
				task.spawn(Options.Callback, Slider.Current)
			end
		end

		function Slider:Get()
			return { Current = Slider.Current }
		end

		function Slider:Callback(Function)
			Options.Callback = Function
		end

		Functions["AddConnection"](nil, Holder.MouseButton1Down, function()
			Functions["AddConnection"]("SliderMove", UserInputService.InputChanged, function(Input, Processed)
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					Slider:Set(
						Options.Minimum
							+ (
								math.clamp(
									(Input.Position.X - SliderFill.AbsolutePosition.X) / SliderFill.AbsoluteSize.X,
									0,
									1
								) * (Options.Maximum - Options.Minimum)
							)
					)
				end
			end)

			Functions["AddConnection"]("SliderEnd", UserInputService.InputEnded, function(Input, Processed)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Functions["RemoveConnection"]("SliderMove")
					Functions["RemoveConnection"]("SliderEnd")
				end
			end)
		end)

		Slider:Set(Slider.Current)

		if Options.Flag then
			Sliders[Options.Flag] = Slider
		end

		return Slider
	end

	Components["Dropdown"] = function(Holder, Options)
		local Options = {
			Text = Options.Text or "DROPDOWN",
			Flag = Options.Flag,
			Callback = Options.Callback,
			Options = Options.Options or { "1", "2", "3" },
			Current = Options.Current or {},
			Minimum = Options.Minimum or 0,
			Maximum = Options.Maximum or math.huge,
		}

		local Dropdown = {
			Current = Options.Current,
		}

		local DropdownOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			Parent = Holder,
			Interactable = false,
		})

		local DropdownMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = DropdownOutline,
		})

		local DropdownInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = DropdownMiddle,
		})

		local DropdownFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = DropdownInline,
		})

		local DropdownSelectedLabel = Functions["Create"]("TextLabel", {
			Parent = DropdownFill,
			Position = UDim2.new(1, -2, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})

		local DropdownTextLabel = Functions["Create"]("TextLabel", {
			Parent = DropdownFill,
			Position = UDim2.new(0, 2, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			Text = Options.Text,
			FontFace = CustomFont,
		})

		local DropdownListOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(0, DropdownOutline.AbsoluteSize.X, 0, (#Options.Options * 19) + 5),
			Position = UDim2.new(0, 0, 0, 19),
			Parent = ComponentsGUI,
			Visible = false,
			Name = "DROPDOWN",
		})

		local DropdownListMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = DropdownListOutline,
		})

		local DropdownListInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = DropdownListMiddle,
		})

		local DropdownListFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			Parent = DropdownListInline,
			BackgroundTransparency = 1,
		})

		Functions["Create"]("UIStroke", { Parent = DropdownSelectedLabel })
		Functions["Create"]("UIStroke", { Parent = DropdownTextLabel })

		Functions["AddThemeRegistery"](DropdownOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](DropdownMiddle, { BackgroundColor3 = "Option Background" })
		Functions["AddThemeRegistery"](DropdownInline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](DropdownFill, { BackgroundColor3 = "Option Background" })
		Functions["AddThemeRegistery"](DropdownSelectedLabel, { TextColor3 = "Active Text" })
		Functions["AddThemeRegistery"](DropdownTextLabel, { TextColor3 = "Active Text" })
		Functions["AddThemeRegistery"](DropdownListOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](DropdownListMiddle, { BackgroundColor3 = "Border 2" })
		Functions["AddThemeRegistery"](DropdownListInline, { BackgroundColor3 = "Border 1" })

		local Objects = {}
		function Dropdown:Values(List)
			Options.Options = List

			for _, Data in next, Objects do
				Data.Frame:Destroy()
				Functions["RemoveConnection"](Data.Connection)
			end

			table.clear(Objects)

			for Index, Value in next, Options.Options do
				local Frame = Functions["Create"]("TextButton", {
					Size = UDim2.new(1, -2, 0, (Index == #Options.Options and 17 or 16)),
					Position = UDim2.new(0, 1, 0, 1 + ((Index - 1) * 17)),
					Parent = DropdownListFill,
				})

				local Label = Functions["Create"]("TextLabel", {
					Parent = Frame,
					Text = " " .. Value,
					Position = UDim2.new(0, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextSize = 12,
					Size = UDim2.new(1, 0, 0, 0),
					FontFace = CustomFont,
				})

				Functions["Create"]("UIStroke", { Parent = Label })
				Functions["AddThemeRegistery"](Frame, { BackgroundColor3 = "Option Background" })
				Functions["AddThemeRegistery"](
					Label,
					{ TextColor3 = "Inactive Text", BackgroundColor3 = "Option Background" }
				)

				local Connection = Functions["AddConnection"](nil, Frame.MouseButton1Down, function()
					local Table = table.clone(Dropdown.Current)

					if table.find(Table, Value) then
						if #Table > Options.Minimum then
							table.remove(Table, table.find(Table, Value))
							self:Set(Table)
						end
					else
						if Options.Maximum == 1 then
							self:Set({ Value })
						elseif #Table < Options.Maximum then
							table.insert(Table, Value)
							self:Set(Table)
						end
					end
				end)

				Objects[Value] = { Frame = Frame, Label = Label, Connection = Connection }
			end

			DropdownListOutline.Size = UDim2.new(0, DropdownOutline.AbsoluteSize.X, 0, (#Options.Options * 17) + 6)
		end

		function Dropdown:Set(List)
			Dropdown.Current = List

			local FullText = table.concat(List, ", ")

			if #FullText > 14 then
				FullText = string.sub(FullText, 1, 14) .. "..."
			end

			DropdownSelectedLabel.Text = FullText

			for Value, Data in next, Objects do
				local Selected = table.find(List, Value) ~= nil

				Functions["UpdateThemeRegistery"](Data.Label, {
					TextColor3 = Selected and "Accent" or "Inactive Text",
				})
			end

			if Options.Callback then
				task.spawn(Options.Callback, List)
			end
		end

		function Dropdown:Get()
			return { Current = Dropdown.Current }
		end

		function Dropdown:Callback(Function)
			Options.Callback = Function
		end

		local Try = 0
		Functions["AddConnection"](nil, UserInputService.InputBegan, function(Input)
			if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end
			if not DropdownListOutline.Visible then
				return
			end

			if Try == 0 then
				Try = 1
				return
			end

			local MousePosition = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
			local AbsolutePosition = DropdownListOutline.AbsolutePosition
			local AbsoluteSize = DropdownListOutline.AbsoluteSize

			local Inside = MousePosition.X >= AbsolutePosition.X
				and MousePosition.X <= AbsolutePosition.X + AbsoluteSize.X
				and MousePosition.Y >= AbsolutePosition.Y
				and MousePosition.Y <= AbsolutePosition.Y + AbsoluteSize.Y

			if not Inside then
				DropdownListOutline.Visible = false
			end
		end)

		Functions["AddConnection"](nil, UserInputService.InputChanged, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseWheel then
				DropdownListOutline.Visible = false
			end
		end)

		Functions["AddConnection"](nil, Holder.MouseButton1Down, function()
			if #Options.Options <= 0 then
				return
			end

			DropdownListOutline.Visible = not DropdownListOutline.Visible
			local AbsolutePosition = Holder.AbsolutePosition + GuiService:GetGuiInset()
			DropdownListOutline.Position = UDim2.new(0, AbsolutePosition.X, 0, AbsolutePosition.Y + 23)
			Try = 0
		end)

		Dropdown:Values(Options.Options)
		Dropdown:Set(Options.Current)

		if Options.Flag then
			Dropdowns[Options.Flag] = Dropdown
		end

		return Dropdown
	end

	Components["Button"] = function(Holder, Options)
		local Options = {
			Text = Options.Text or "BUTTON",
			Result = Options.Result or "PRESSED",
			Callback = Options.Callback,
			Confirm = Options.Confirm and Options.Confirm or false,
		}

		local Button = {}

		local Buttons = #Holder:GetChildren() + 1
		local ButtonOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 0),
			Parent = Holder,
		})

		if Buttons > 0 then
			local Padding = 2
			local TotalPadding = Padding * (Buttons - 1)
			local BaseWidth = math.floor((Holder.AbsoluteSize.X - TotalPadding) / Buttons)
			local Remainder = (Holder.AbsoluteSize.X - TotalPadding) % Buttons
			local X = 0
			for Index, Child in next, Holder:GetChildren() do
				local Extra = (Index <= Remainder) and 1 or 0
				local Width = BaseWidth + Extra
				Child.Size = UDim2.new(0, Width, 1, 0)
				Child.Position = UDim2.new(0, X, 0, 0)
				X = X + Width + Padding
			end
		end

		local ButtonMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = ButtonOutline,
		})

		local ButtonInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = ButtonMiddle,
		})

		local ButtonFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = ButtonInline,
		})

		local ButtonTextLabel = Functions["Create"]("TextLabel", {
			Parent = ButtonFill,
			Text = Options.Text,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})

		Functions["Create"]("UIStroke", { Parent = ButtonTextLabel })

		Functions["AddThemeRegistery"](ButtonOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](ButtonMiddle, { BackgroundColor3 = "Option Background" })
		Functions["AddThemeRegistery"](ButtonInline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](ButtonFill, { BackgroundColor3 = "Option Background" })
		Functions["AddThemeRegistery"](
			ButtonTextLabel,
			{ TextColor3 = "Active Text", BackgroundColor3 = "Option Background" }
		)

		local State = nil

		Functions["AddConnection"](nil, ButtonOutline.MouseButton1Down, function()
			if Options.Confirm then
				if State == "PRESSED" then
					return
				end
				if State ~= nil then
					if Options.Callback then
						task.spawn(Options.Callback)
					end
					State = "PRESSED"
					ButtonTextLabel.Text = Options.Result
					Functions["UpdateThemeRegistery"](ButtonTextLabel, { TextColor3 = "Accent" })
					task.spawn(function()
						task.wait(1)
						ButtonTextLabel.Text = Options.Text
						Functions["UpdateThemeRegistery"](ButtonTextLabel, { TextColor3 = "Active Text" })
						State = nil
					end)
				else
					State = tick()
					Functions["UpdateThemeRegistery"](ButtonTextLabel, { TextColor3 = "Accent" })
					task.spawn(function()
						for i = 1, 200 do
							if not State or State == "PRESSED" then
								break
							end
							if #Holder:GetChildren() > 1 then
								ButtonTextLabel.Text = "PROCEED?"
							else
								ButtonTextLabel.Text = "PROCEED? [" .. string.format("%.2f", 2 - (i * 0.01)) .. "s]"
							end
							task.wait(0.01)
						end
						if State and State ~= "PRESSED" then
							ButtonTextLabel.Text = Options.Text
							Functions["UpdateThemeRegistery"](ButtonTextLabel, { TextColor3 = "Active Text" })
							State = nil
						end
					end)
				end
			else
				if Options.Callback then
					task.spawn(Options.Callback)
				end
				ButtonTextLabel.Text = Options.Result
				Functions["UpdateThemeRegistery"](ButtonTextLabel, { TextColor3 = "Accent" })
				task.spawn(function()
					task.wait(1)
					ButtonTextLabel.Text = Options.Text
					Functions["UpdateThemeRegistery"](ButtonTextLabel, { TextColor3 = "Active Text" })
				end)
			end
		end)

		function Button:Button(Data)
			return Components["Button"](Holder, Data)
		end

		return Button
	end

	Components["TextBox"] = function(Holder, Options)
		local Options = {
			Text = Options.Text or "TEXTBOX",
			Placeholder = Options.Placeholder or "PLACEHOLDER",
			Flag = Options.Flag,
			Callback = Options.Callback,
		}

		local TextBox = {
			Text = Options.Text,
		}

		local TextBoxOutline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			Parent = Holder,
		})

		local TextBoxMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = TextBoxOutline,
		})

		local TextBoxInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = TextBoxMiddle,
		})

		local TextBoxFill = Functions["Create"]("TextBox", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			TextScaled = true,
			PlaceholderText = Options.Placeholder,
			Text = Options.Text,
			Parent = TextBoxInline,
			FontFace = CustomFont,
		})

		Functions["AddThemeRegistery"](TextBoxOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](TextBoxMiddle, { BackgroundColor3 = "Option Background" })
		Functions["AddThemeRegistery"](TextBoxInline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](
			TextBoxFill,
			{ BackgroundColor3 = "Option Background", TextColor3 = "Active Text" }
		)

		function TextBox:Set(Text)
			TextBox.Text = Text
			TextBoxFill.Text = Text
			if Options.Callback then
				task.spawn(Options.Callback, Text)
			end
		end

		function TextBox:Get()
			return { Text = TextBox.Text }
		end

		function TextBox:Callback(Function)
			Options.Callback = Function
		end

		Functions["AddConnection"](nil, TextBoxFill.FocusLost, function(Pressed)
			if not Pressed then
				return TextBox:Set("")
			end

			TextBox:Set(TextBoxFill.Text)
		end)

		if Options.Flag then
			TextBoxes[Options.Flag] = TextBox
		end

		TextBox:Set(TextBox.Text)

		return TextBox
	end

	Components["Label"] = function(Holder, Options)
		local Options = {
			Text = Options.Text or "LABEL",
			Side = Options.Side or "LEFT",
		}

		local Label = {}
		local LabelTextLabel = Functions["Create"]("TextLabel", {
			Parent = Holder,
			Text = Options.Text,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			TextXAlignment = Options.Side == "LEFT" and Enum.TextXAlignment.Left
				or Options.Side == "RIGHT" and Enum.TextXAlignment.Right
				or Options.Side == "CENTER" and Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})

		Functions["Create"]("UIStroke", { Parent = LabelTextLabel })
		Functions["AddThemeRegistery"](LabelTextLabel, { TextColor3 = "Active Text" })

		local Addons = {}
		function RefreshAddons()
			local Offset = 0
			for Index, Addon in next, Addons do
				Offset = Offset - 2 - (Index == 1 and 0 or Addon.Objects.Main.Size.X.Offset + 2)
				Addon.Objects.Main.Position = UDim2.new(1, Offset, 0.5, 0)
			end
		end

		function Label:Colorpicker(Options)
			local Colorpicker = Components["Colorpicker"](Holder, Options, Label)
			table.insert(Addons, Colorpicker)
			RefreshAddons()
			return Label
		end

		return Label
	end

	local Keys = {
		[Enum.KeyCode.LeftShift] = "LS",
		[Enum.KeyCode.RightShift] = "RS",
		[Enum.KeyCode.LeftControl] = "LC",
		[Enum.KeyCode.RightControl] = "RC",
		[Enum.KeyCode.Insert] = "INS",
		[Enum.KeyCode.Backspace] = "BS",
		[Enum.KeyCode.Return] = "ENT",
		[Enum.KeyCode.LeftAlt] = "LA",
		[Enum.KeyCode.RightAlt] = "RA",
		[Enum.KeyCode.CapsLock] = "CAPS",
		[Enum.KeyCode.One] = "1",
		[Enum.KeyCode.Two] = "2",
		[Enum.KeyCode.Three] = "3",
		[Enum.KeyCode.Four] = "4",
		[Enum.KeyCode.Five] = "5",
		[Enum.KeyCode.Six] = "6",
		[Enum.KeyCode.Seven] = "7",
		[Enum.KeyCode.Eight] = "8",
		[Enum.KeyCode.Nine] = "9",
		[Enum.KeyCode.Zero] = "0",
		[Enum.KeyCode.KeypadOne] = "Num1",
		[Enum.KeyCode.KeypadTwo] = "Num2",
		[Enum.KeyCode.KeypadThree] = "Num3",
		[Enum.KeyCode.KeypadFour] = "Num4",
		[Enum.KeyCode.KeypadFive] = "Num5",
		[Enum.KeyCode.KeypadSix] = "Num6",
		[Enum.KeyCode.KeypadSeven] = "Num7",
		[Enum.KeyCode.KeypadEight] = "Num8",
		[Enum.KeyCode.KeypadNine] = "Num9",
		[Enum.KeyCode.KeypadZero] = "Num0",
		[Enum.KeyCode.Minus] = "-",
		[Enum.KeyCode.Equals] = "=",
		[Enum.KeyCode.Tilde] = "~",
		[Enum.KeyCode.LeftBracket] = "[",
		[Enum.KeyCode.RightBracket] = "]",
		[Enum.KeyCode.RightParenthesis] = ")",
		[Enum.KeyCode.LeftParenthesis] = "(",
		[Enum.KeyCode.Semicolon] = ";",
		[Enum.KeyCode.Quote] = "'",
		[Enum.KeyCode.BackSlash] = "\\",
		[Enum.KeyCode.Comma] = ",",
		[Enum.KeyCode.Period] = ".",
		[Enum.KeyCode.Slash] = "/",
		[Enum.KeyCode.Asterisk] = "*",
		[Enum.KeyCode.Plus] = "+",
		[Enum.KeyCode.Backquote] = "`",
		[Enum.UserInputType.MouseButton1] = "MB1",
		[Enum.UserInputType.MouseButton2] = "MB2",
		[Enum.UserInputType.MouseButton3] = "MB3",
		[Enum.KeyCode.Escape] = "ESC",
		[Enum.KeyCode.Space] = "SPC",
	}

	Components["Keypicker"] = function(Holder, Options, Parent)
		local Options = {
			Text = Options.Text or "KEY",
			Side = Options.Side or "LEFT",
			Display = Options.Display ~= false,
			Flag = Options.Flag,
			Callback = Options.Callback,
			Input = Options.Input or Enum.KeyCode.E,
			Mode = Options.Mode or "TOGGLE",
			Menu = Options.Menu ~= false,
			Sync = Options.Sync ~= false,
		}

		local Keypicker = {
			Input = Options.Input,
			Mode = Options.Mode,
			Value = false,
			Objects = {},
		}

		if Options.Sync == true then
			Keypicker.Objects.Sync = true
		end

		local KeybindOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(0, 30, 0, 16),
			AnchorPoint = Vector2.new(1, 0.5),
			Parent = Holder,
		})
		local KeybindMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = KeybindOutline,
		})
		local KeybindInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = KeybindMiddle,
		})
		local KeybindFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = KeybindInline,
		})
		local KeybindLabel = Functions["Create"]("TextLabel", {
			Parent = KeybindFill,
			Text = Keys[Keypicker.Input]
				or (Keypicker.Input.EnumType == Enum.KeyCode and UserInputService:GetStringForKeyCode(Keypicker.Input))
				or "UNKNOWN",
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})
		Functions["Create"]("UIStroke", { Parent = KeybindLabel })

		local KeybindModeListOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(0, 100, 0, (2 * 19) + 5),
			Position = UDim2.new(1, 2, 0, 0),
			Parent = ComponentsGUI,
			Visible = false,
			Name = "KEYPICKER",
		})
		local KeybindModeListMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = KeybindModeListOutline,
		})
		local KeybindModeListInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = KeybindModeListMiddle,
		})
		local KeybindModeListFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			Parent = KeybindModeListInline,
			BackgroundTransparency = 1,
		})

		Functions["AddThemeRegistery"](KeybindOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](KeybindMiddle, { BackgroundColor3 = "Option Background" })
		Functions["AddThemeRegistery"](KeybindInline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](KeybindFill, { BackgroundColor3 = "Option Background" })
		Functions["AddThemeRegistery"](KeybindLabel, { TextColor3 = "Active Text" })
		Functions["AddThemeRegistery"](KeybindModeListOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](KeybindModeListMiddle, { BackgroundColor3 = "Border 2" })
		Functions["AddThemeRegistery"](KeybindModeListInline, { BackgroundColor3 = "Border 1" })

		local DisplayKeybind = Library.Keybinds:Add({ Index = "EMPTY", Key = "EMPTY" })
		Keypicker.Objects.Display = DisplayKeybind
		Keypicker.Objects.Main = KeybindOutline

		local Labels = {}
		for Index, Value in next, { "HOLD", "TOGGLE" } do
			local ModeFrame = Functions["Create"]("TextButton", {
				Size = UDim2.new(1, -2, 0, 18),
				Position = UDim2.new(0, 1, 0, 1 + ((Index - 1) * 19)),
				Parent = KeybindModeListFill,
			})
			local ModeLabel = Functions["Create"]("TextLabel", {
				Parent = ModeFrame,
				Text = " " .. Value,
				Position = UDim2.new(0, 0, 0, 0),
				AnchorPoint = Vector2.new(0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextSize = 12,
				Size = UDim2.new(1, 0, 1, 0),
				FontFace = CustomFont,
				BackgroundTransparency = 1,
			})
			Functions["Create"]("UIStroke", { Parent = ModeLabel })
			Functions["AddThemeRegistery"](ModeFrame, { BackgroundColor3 = "Option Background" })
			Functions["AddThemeRegistery"](
				ModeLabel,
				{ TextColor3 = Keypicker.Mode == Value and "Accent" or "Inactive Text" }
			)
			Labels[Value] = ModeLabel
			Functions["AddConnection"](nil, ModeFrame.MouseButton1Down, function()
				if not Options.Menu then
					return
				end
				Keypicker:Set(Keypicker.Input, Value)
			end)
		end

		function Keypicker:Set(Input, Mode)
			local Display = Keys[Input]
				or (Input and Input.EnumType == Enum.KeyCode and UserInputService:GetStringForKeyCode(Input))
				or "UNKNOWN"

			if Display == "UNKNOWN" or Display == "" or Display == "-" then
				Display = "-"
				Keypicker.Input = nil
			else
				Keypicker.Input = Input
			end

			KeybindLabel.Text = Display
			Keypicker.Mode = Mode

			if Display == "-" then
				DisplayKeybind:SetVisible(false)
			else
				DisplayKeybind:SetVisible(Options.Display)
			end

			DisplayKeybind:SetIndex(Options.Text)
			DisplayKeybind:SetValue(Display)

			for Id, Object in next, Labels do
				Functions["UpdateThemeRegistery"](
					Object,
					{ TextColor3 = Keypicker.Mode == Id and "Accent" or "Inactive Text" }
				)
			end

			if Options.Callback then
				task.spawn(
					Options.Callback,
					{ Input = Keypicker.Input, Mode = Keypicker.Mode, Value = Keypicker.Value }
				)
			end
		end

		function Keypicker:Get()
			return { Input = Keypicker.Input, Mode = Keypicker.Mode, Value = Keypicker.Value }
		end

		function Keypicker:Callback(Function)
			Options.Callback = Function
		end

		local SettingKeybind = false
		Functions["AddConnection"](nil, KeybindOutline.MouseButton1Down, function()
			if SettingKeybind then
				return
			end
			SettingKeybind = true
			KeybindLabel.Text = "..."

			Functions["AddConnection"]("KeypickerSetting", UserInputService.InputBegan, function(Input, Processed)
				if Processed then
					return
				end
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.MouseButton2
					or Input.UserInputType == Enum.UserInputType.Keyboard
				then
					local ChosenInput
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						ChosenInput = Enum.UserInputType.MouseButton1
					elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
						ChosenInput = Enum.UserInputType.MouseButton2
					else
						ChosenInput = Input.KeyCode
					end
					Keypicker:Set(ChosenInput, Keypicker.Mode)
					Functions["RemoveConnection"]("KeypickerSetting")
					task.wait()
					SettingKeybind = false
				end
			end)
		end)

		if Options.Menu then
			local Try = 0
			Functions["AddConnection"](nil, KeybindOutline.MouseButton2Down, function()
				KeybindModeListOutline.Visible = not KeybindModeListOutline.Visible
				local AbsolutePosition = KeybindOutline.AbsolutePosition + GuiService:GetGuiInset()
				KeybindModeListOutline.Position = UDim2.new(0, AbsolutePosition.X + 32, 0, AbsolutePosition.Y)
				Try = 0
			end)

			Functions["AddConnection"](nil, UserInputService.InputBegan, function(Input)
				if
					Input.UserInputType ~= Enum.UserInputType.MouseButton1
					and Input.UserInputType ~= Enum.UserInputType.MouseButton2
				then
					return
				end
				if not KeybindModeListOutline.Visible then
					return
				end
				if Try == 0 then
					Try = 1
					return
				end
				local MousePosition = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
				local AbsolutePosition = KeybindModeListOutline.AbsolutePosition
				local AbsoluteSize = KeybindModeListOutline.AbsoluteSize
				local Inside = MousePosition.X >= AbsolutePosition.X
					and MousePosition.X <= AbsolutePosition.X + AbsoluteSize.X
					and MousePosition.Y >= AbsolutePosition.Y
					and MousePosition.Y <= AbsolutePosition.Y + AbsoluteSize.Y
				if not Inside then
					for _, Component in next, ComponentsGUI:GetChildren() do
						if Component == KeybindModeListOutline then
							continue
						end
						if
							Component.Name == "DROPDOWN"
							or Component.Name == "COLORPICKER"
							or Component.Name == "KEYPICKER"
						then
							Component.Visible = false
						end
					end
					KeybindModeListOutline.Visible = false
				end
			end)

			Functions["AddConnection"](nil, UserInputService.InputChanged, function(Input)
				if Input.UserInputType ~= Enum.UserInputType.MouseWheel then
					return
				end
				KeybindModeListOutline.Visible = false
			end)
		end

		Functions["AddConnection"](nil, UserInputService.InputBegan, function(Input, Processed)
			if Processed or SettingKeybind then
				return
			end
			if not Keypicker.Input then
				return
			end

			local InputMatch = false
			if Keypicker.Input.EnumType == Enum.KeyCode then
				InputMatch = Input.KeyCode == Keypicker.Input
			elseif Keypicker.Input.EnumType == Enum.UserInputType then
				InputMatch = Input.UserInputType == Keypicker.Input
			end
			if not InputMatch then
				return
			end

			if Keypicker.Mode == "TOGGLE" then
				if Options.Sync then
					local NewState = not Parent.Value
					Parent:Set(NewState)
					DisplayKeybind:SetTheme({ TextColor3 = NewState and "Accent" or "Inactive Text" })
				else
					Keypicker.Value = not Keypicker.Value
					DisplayKeybind:SetTheme({ TextColor3 = Keypicker.Value and "Accent" or "Inactive Text" })
				end
			elseif Keypicker.Mode == "HOLD" then
				if Options.Sync then
					Parent:Set(true)
				else
					Keypicker.Value = true
				end
				DisplayKeybind:SetTheme({ TextColor3 = "Accent" })
			elseif Keypicker.Mode == "ALWAYS" then
				if Options.Sync then
					Parent:Set(true)
				else
					Keypicker.Value = true
				end
				DisplayKeybind:SetTheme({ TextColor3 = "Accent" })
			end

			if Options.Callback then
				task.spawn(Options.Callback, {
					Input = Keypicker.Input,
					Mode = Keypicker.Mode,
					Value = Options.Sync and Parent.Value or Keypicker.Value,
				})
			end
		end)

		Functions["AddConnection"](nil, UserInputService.InputEnded, function(Input)
			if SettingKeybind then
				return
			end
			if not Keypicker.Input then
				return
			end

			local InputMatch = false
			if Keypicker.Input.EnumType == Enum.KeyCode then
				InputMatch = Input.KeyCode == Keypicker.Input
			elseif Keypicker.Input.EnumType == Enum.UserInputType then
				InputMatch = Input.UserInputType == Keypicker.Input
			end

			if InputMatch and Keypicker.Mode == "HOLD" then
				if Options.Sync then
					Parent:Set(false)
				else
					Keypicker.Value = false
				end
				DisplayKeybind:SetTheme({ TextColor3 = "Inactive Text" })
				if Options.Callback then
					task.spawn(Options.Callback, {
						Input = Keypicker.Input,
						Mode = Keypicker.Mode,
						Value = Options.Sync and Parent.Value or Keypicker.Value,
					})
				end
			end
		end)

		Keypicker:Set(Keypicker.Input, Keypicker.Mode)

		if Options.Flag then
			Keypickers[Options.Flag] = Keypicker
		end

		return Keypicker
	end

	local Pickers = {}
	local Copied = Color3.new()

	Functions["AddConnection"](nil, RunService.Heartbeat, function()
		for Colorpicker, Mode in next, Pickers do
			if Mode == "RAINBOW" then
				Colorpicker:Set(Color3.fromHSV((tick() % 5) / 5, 1, 1), Colorpicker.Alpha)
			end
		end
	end)

	Components["Colorpicker"] = function(Holder, Options, Parent)
		local Options = {
			Color = Options.Color or Color3.new(0, 1, 1),
			Alpha = Options.Alpha,
			Flag = Options.Flag,
			Callback = Options.Callback,
		}

		local HH, SS, VV = Options.Color:ToHSV()
		local Colorpicker = {
			Color = Color3.fromHSV(HH, SS, VV),
			Alpha = Options.Alpha,
			Mode = "NONE",
			Objects = {},
		}

		local ColorpickerOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(0, 30, 0, 16),
			AnchorPoint = Vector2.new(1, 0.5),
			Parent = Holder,
		})
		local ColorpickerMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = ColorpickerOutline,
		})
		local ColorpickerInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = ColorpickerMiddle,
		})
		local ColorpickerFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromHSV(HH, SS, VV),
			Parent = ColorpickerInline,
		})
		local ColorpickerDropdownOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(0, Colorpicker.Alpha and 150 or 131, 0, 170),
			Position = UDim2.new(0, 0, 0, 0),
			Parent = ComponentsGUI,
			Visible = false,
			Name = "COLORPICKER",
		})
		local ColorpickerDropdownFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = ColorpickerDropdownOutline,
		})
		local ColorpickerDropdownHolder = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = ColorpickerDropdownFill,
			BackgroundTransparency = 1,
		})
		local ColorpickerDropdownLayout = Functions["Create"]("UIListLayout", {
			Parent = ColorpickerDropdownHolder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 1),
		})

		Colorpicker.Objects.Main = ColorpickerOutline

		local ColorpickerMainHolder = Functions["Create"]("Frame", {
			Size = UDim2.new(1, 0, 0.76, 0),
			Parent = ColorpickerDropdownHolder,
			BackgroundTransparency = 1,
		})
		local ColorpickerActionsHolder = Functions["Create"]("Frame", {
			Size = UDim2.new(1, 0, 0.24, -1),
			Position = UDim2.new(0, 0, 1, 0),
			Parent = ColorpickerDropdownHolder,
			BackgroundTransparency = 1,
		})
		local ColorpickerMainLayout = Functions["Create"]("UIListLayout", {
			Parent = ColorpickerMainHolder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 1),
		})
		local ColorpickerColorBoxOutline = Functions["Create"]("Frame", {
			Size = UDim2.new(0, Colorpicker.Alpha and 116 or 112, 1, 0),
			Parent = ColorpickerMainHolder,
		})
		local ColorpickerColorBoxFill = Functions["Create"]("TextButton", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = ColorpickerColorBoxOutline,
		})
		local ColorpickerColorBoxSaturationOne = Functions["Create"]("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			Parent = ColorpickerColorBoxFill,
			BackgroundTransparency = 1,
			Rotation = -180,
			Image = Functions["CustomAsset"](
				"Fondra/Assets/Library/Images/Saturation One.png",
				"https://raw.githubusercontent.com/Fondra-WTF/Assets/refs/heads/main/Library/Images/Saturation%20One.png"
			),
		})
		local ColorpickerColorBoxSaturationTwo = Functions["Create"]("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			Parent = ColorpickerColorBoxFill,
			BackgroundTransparency = 1,
			Image = Functions["CustomAsset"](
				"Fondra/Assets/Library/Images/Saturation Two.png",
				"https://raw.githubusercontent.com/Fondra-WTF/Assets/refs/heads/main/Library/Images/Saturation%20Two.png"
			),
			Rotation = 0,
		})
		local ColorpickerColorBoxCursorOutline = Functions["Create"]("Frame", {
			Size = UDim2.new(0, 5, 0, 5),
			Parent = ColorpickerColorBoxFill,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Interactable = false,
			Active = false,
		})
		local ColorpickerColorBoxCursorFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = ColorpickerColorBoxCursorOutline,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Interactable = false,
			Active = false,
		})
		local ColorpickerButtonsHolder = Functions["Create"]("TextButton", {
			Parent = ColorpickerActionsHolder,
			Size = UDim2.new(1, 0, 0.5, 0),
			BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
			Transparency = Library.Debug and 0 or 1,
		})

		Components["Button"](ColorpickerButtonsHolder, {
			Text = "COPY",
			Result = "COPIED",
			Callback = function()
				Copied = { Color = Colorpicker.Color, Alpha = Colorpicker.Alpha }
			end,
		}):Button({
			Text = "PASTE",
			Result = "PASTED",
			Callback = function()
				if Copied and Copied.Color then
					Colorpicker:Set(Copied.Color, Copied.Alpha or Colorpicker.Alpha)
				end
			end,
		})

		local ColorpickerDropdownHolder = Functions["Create"]("TextButton", {
			Parent = ColorpickerActionsHolder,
			Size = UDim2.new(1, 0, 0.5, -1),
			BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
			Transparency = Library.Debug and 0 or 1,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
		})

		Components["Dropdown"](ColorpickerDropdownHolder, {
			Text = "MODE",
			Options = { "NONE", "RAINBOW" },
			Current = { "NONE" },
			Minimum = 1,
			Maximum = 1,
			Callback = function(Result)
				Colorpicker.Mode = Result[1]
				Pickers[Colorpicker] = Result[1]
			end,
		})

		Functions["AddConnection"](nil, ColorpickerColorBoxFill.MouseButton1Down, function()
			Functions["AddConnection"]("ColorpickerMove", UserInputService.InputChanged, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					local MousePos = (UserInputService:GetMouseLocation() - GuiService:GetGuiInset())
						- ColorpickerColorBoxFill.AbsolutePosition
					local S = math.clamp(MousePos.X / ColorpickerColorBoxFill.AbsoluteSize.X, 0, 1)
					local V = 1 - math.clamp(MousePos.Y / ColorpickerColorBoxFill.AbsoluteSize.Y, 0, 1)
					local H = Color3.toHSV(Colorpicker.Color)
					Colorpicker:Set(Color3.fromHSV(H, S, V))
				end
			end)

			Functions["AddConnection"]("ColorpickerEnd", UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Functions["RemoveConnection"]("ColorpickerMove")
					Functions["RemoveConnection"]("ColorpickerEnd")
				end
			end)
		end)

		local ColorpickerHueOutline = Functions["Create"]("Frame", {
			Size = UDim2.new(0, 14, 1, 0),
			Parent = ColorpickerMainHolder,
		})
		local ColorpickerHueMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = ColorpickerHueOutline,
		})
		local ColorpickerHueInline = Functions["Create"]("ImageButton", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = Functions["CustomAsset"](
				"Fondra/Assets/Library/Images/Hue.png",
				"https://raw.githubusercontent.com/Fondra-WTF/Assets/refs/heads/main/Library/Images/Hue.png"
			),
			Parent = ColorpickerHueMiddle,
		})
		local ColorpickerHueCursorOutline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -4, 0, 3),
			Position = UDim2.new(0, 2, 0, 0),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Parent = ColorpickerHueInline,
		})
		local ColorpickerHueCursorFill = Functions["Create"]("ImageButton", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Parent = ColorpickerHueCursorOutline,
		})

		Functions["AddThemeRegistery"](ColorpickerOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](ColorpickerMiddle, { BackgroundColor3 = "Option Background" })
		Functions["AddThemeRegistery"](ColorpickerInline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](ColorpickerDropdownOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](ColorpickerDropdownFill, { BackgroundColor3 = "Option Background" })
		Functions["AddThemeRegistery"](ColorpickerColorBoxOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](ColorpickerHueOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](ColorpickerHueMiddle, { BackgroundColor3 = "Option Background" })
		Functions["AddThemeRegistery"](ColorpickerHueInline, { BackgroundColor3 = "Border 1" })

		Functions["AddConnection"](nil, ColorpickerHueInline.MouseButton1Down, function()
			Functions["AddConnection"]("HueMove", UserInputService.InputChanged, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					local MouseY = UserInputService:GetMouseLocation().Y - GuiService:GetGuiInset().Y
					local Y = math.clamp(
						MouseY - ColorpickerHueInline.AbsolutePosition.Y,
						0,
						ColorpickerHueInline.AbsoluteSize.Y
					)
					local H = Y / ColorpickerHueInline.AbsoluteSize.Y
					local _, S, V = Color3.toHSV(Colorpicker.Color)
					Colorpicker:Set(Color3.fromHSV(H, S, V))
				end
			end)
			Functions["AddConnection"]("HueEnd", UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Functions["RemoveConnection"]("HueMove")
					Functions["RemoveConnection"]("HueEnd")
				end
			end)
		end)

		if Colorpicker.Alpha then
			local ColorpickerAlphaOutline = Functions["Create"]("Frame", {
				Size = UDim2.new(0, 14, 1, 0),
				Parent = ColorpickerMainHolder,
			})
			local ColorpickerAlphaMiddle = Functions["Create"]("Frame", {
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Parent = ColorpickerAlphaOutline,
			})
			local ColorpickerAlphaInline = Functions["Create"]("ImageButton", {
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Parent = ColorpickerAlphaMiddle,
				Image = Functions["CustomAsset"](
					"Fondra/Assets/Library/Images/Alpha.png",
					"https://raw.githubusercontent.com/Fondra-WTF/Assets/refs/heads/main/Library/Images/Alpha.png"
				),
			})
			local ColorpickerAlphaCursorOutline = Functions["Create"]("Frame", {
				Size = UDim2.new(1, -4, 0, 3),
				Position = UDim2.new(0, 2, 0, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				Parent = ColorpickerAlphaInline,
			})
			local ColorpickerAlphaCursorFill = Functions["Create"]("ImageButton", {
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Parent = ColorpickerAlphaCursorOutline,
			})

			Functions["AddConnection"](nil, ColorpickerAlphaInline.MouseButton1Down, function()
				Functions["AddConnection"]("AlphaMove", UserInputService.InputChanged, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseMovement then
						local MouseY = UserInputService:GetMouseLocation().Y - GuiService:GetGuiInset().Y
						local Y = math.clamp(
							MouseY - ColorpickerAlphaInline.AbsolutePosition.Y,
							0,
							ColorpickerAlphaInline.AbsoluteSize.Y
						)
						local AlphaValue = 1 - (Y / ColorpickerAlphaInline.AbsoluteSize.Y)
						Colorpicker:Set(Colorpicker.Color, AlphaValue)
					end
				end)
				Functions["AddConnection"]("AlphaEnd", UserInputService.InputEnded, function(Input)
					if Input.UserInputType == Enum.UserInputType.MouseButton1 then
						Functions["RemoveConnection"]("AlphaMove")
						Functions["RemoveConnection"]("AlphaEnd")
					end
				end)
			end)

			Colorpicker.Objects.AlphaCursor = ColorpickerAlphaCursorOutline
			Colorpicker.Objects.AlphaInline = ColorpickerAlphaInline

			Functions["AddThemeRegistery"](ColorpickerAlphaOutline, { BackgroundColor3 = "Border 1" })
			Functions["AddThemeRegistery"](ColorpickerAlphaMiddle, { BackgroundColor3 = "Option Background" })
			Functions["AddThemeRegistery"](ColorpickerAlphaInline, { BackgroundColor3 = "Border 1" })
		end

		function Colorpicker:Set(NewColor, Alpha, Mode)
			local H, S, V = Color3.toHSV(NewColor)
			Colorpicker.Color = Color3.fromHSV(H, S, V)

			if Colorpicker.Alpha ~= nil then
				Colorpicker.Alpha = Alpha or Colorpicker.Alpha
			end

			ColorpickerFill.BackgroundColor3 = Colorpicker.Color

			if Colorpicker.Alpha ~= nil then
				ColorpickerFill.BackgroundTransparency = Colorpicker.Alpha
				if Colorpicker.Objects.AlphaCursor and Colorpicker.Objects.AlphaInline then
					Colorpicker.Objects.AlphaCursor.Position =
						UDim2.new(0, 2, 0, (1 - Colorpicker.Alpha) * Colorpicker.Objects.AlphaInline.AbsoluteSize.Y)
					Colorpicker.Objects.AlphaInline.BackgroundColor3 = Colorpicker.Color
				end
			else
				ColorpickerFill.BackgroundTransparency = 0
			end

			ColorpickerColorBoxFill.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
			ColorpickerHueCursorOutline.Position = UDim2.new(0, 2, 0, H * ColorpickerHueInline.AbsoluteSize.Y)
			ColorpickerColorBoxCursorOutline.Position = UDim2.new(
				0,
				S * ColorpickerColorBoxFill.AbsoluteSize.X,
				0,
				(1 - V) * ColorpickerColorBoxFill.AbsoluteSize.Y
			)

			if Mode then
				Pickers[Colorpicker] = Mode
			end

			if Options.Callback then
				task.spawn(Options.Callback, Colorpicker.Color, Colorpicker.Alpha)
			end
		end

		function Colorpicker:Get()
			return { Color = Colorpicker.Color, Alpha = Colorpicker.Alpha, Mode = Colorpicker.Mode }
		end

		function Colorpicker:Callback(Function)
			Options.Callback = Function
		end

		local Try = 0
		Functions["AddConnection"](nil, UserInputService.InputBegan, function(Input)
			if
				Input.UserInputType ~= Enum.UserInputType.MouseButton1
				and Input.UserInputType ~= Enum.UserInputType.MouseButton2
			then
				return
			end
			if not ColorpickerDropdownOutline.Visible then
				return
			end
			if Try == 0 then
				Try = 1
				return
			end

			local MousePosition = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
			local AbsolutePosition = ColorpickerDropdownOutline.AbsolutePosition
			local AbsoluteSize = ColorpickerDropdownOutline.AbsoluteSize
			local Inside = MousePosition.X >= AbsolutePosition.X
				and MousePosition.X <= AbsolutePosition.X + AbsoluteSize.X
				and MousePosition.Y >= AbsolutePosition.Y
				and MousePosition.Y <= AbsolutePosition.Y + AbsoluteSize.Y

			if not Inside then
				for _, Component in next, ComponentsGUI:GetChildren() do
					if Component == ColorpickerDropdownOutline then
						continue
					end
					if Component.Name == "DROPDOWN" or Component.Name == "COLORPICKER" then
						Component.Visible = false
					end
				end
				ColorpickerDropdownOutline.Visible = false
			end
		end)

		Functions["AddConnection"](nil, UserInputService.InputChanged, function(Input)
			if Input.UserInputType ~= Enum.UserInputType.MouseWheel then
				return
			end
			ColorpickerDropdownOutline.Visible = false
		end)

		Functions["AddConnection"](nil, ColorpickerOutline.MouseButton1Down, function()
			for _, Component in next, ComponentsGUI:GetChildren() do
				if Component == ColorpickerDropdownOutline then
					continue
				end
				if Component.Name == "DROPDOWN" or Component.Name == "COLORPICKER" then
					Component.Visible = false
				end
			end

			ColorpickerDropdownOutline.Visible = not ColorpickerDropdownOutline.Visible
			local AbsolutePosition = ColorpickerOutline.AbsolutePosition + GuiService:GetGuiInset()
			ColorpickerDropdownOutline.Position = UDim2.new(0, AbsolutePosition.X + 25, 0, AbsolutePosition.Y + 1)
			Try = 0
		end)

		Colorpicker:Set(Color3.fromHSV(HH, SS, VV), Colorpicker.Alpha, Colorpicker.Mode)

		if Options.Flag then
			Colorpickers[Options.Flag] = Colorpicker
		end

		return Colorpicker
	end
end

do
	Functions["AddConnection"]("Statistics", RunService.RenderStepped, function(Delta)
		Library.Stats.FPS = math.round(1 / Stats.FrameTime)
		Library.Stats.Ping = Stats.Network:FindFirstChild("ServerStatsItem")
				and tostring(math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()))
			or "???"
	end)
end

do
	function Library:Notification(String, Duration, Color)
		local Notification = {}

		table.insert(Library.Notifications, Notification)

		local Bounds = Functions["GetTextBounds"](String, 12, CustomFont)

		local Container = Functions["Create"]("Frame", {
			Parent = NotificationsGUI,
			Size = UDim2.new(0, Bounds.X + 15, 0, 24),
			ClipsDescendants = true,
			Position = UDim2.new(0, 10, 0, 100 + (table.find(Library.Notifications, Notification) * 26)),
			BackgroundTransparency = 1,
		})

		local Outline = Functions["Create"]("Frame", {
			Parent = Container,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(-1, 0, 0, 0),
		})

		local Middle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = Outline,
		})

		local Inline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = Middle,
		})

		local Fill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = Inline,
		})

		local Accent = Functions["Create"]("Frame", {
			Size = UDim2.new(0, 1, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Parent = Fill,
		})

		local Time = Functions["Create"]("Frame", {
			Size = UDim2.new(0, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, -1),
			Parent = Fill,
		})

		local Title = Functions["Create"]("TextLabel", {
			Parent = Fill,
			Text = String,
			Position = UDim2.new(0, 5, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})

		local Stroke = Functions["Create"]("UIStroke", {
			Parent = Title,
		})

		Functions["AddThemeRegistery"](Outline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](Middle, { BackgroundColor3 = "Border 2" })
		Functions["AddThemeRegistery"](Inline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](Fill, { BackgroundColor3 = "Background 1" })
		Functions["AddThemeRegistery"](Accent, { BackgroundColor3 = Color })
		Functions["AddThemeRegistery"](Time, { BackgroundColor3 = Color })
		Functions["AddThemeRegistery"](Title, { TextColor3 = "Active Text" })

		Notification["Container"] = Container
		Notification["Outline"] = Outline
		Notification["Middle"] = Middle
		Notification["Inline"] = Inline
		Notification["Fill"] = Fill
		Notification["Accent"] = Accent
		Notification["Time"] = Time
		Notification["Title"] = Title

		TweenService:Create(Outline, TweenInfo.new(0.25), { Position = UDim2.new(0, 0, 0, 0) }):Play()
		TweenService:Create(Time, TweenInfo.new(Duration), { Size = UDim2.new(1, 0, 0, 1) }):Play()

		task.delay(Duration + 0.15, function()
			table.remove(Library.Notifications, table.find(Library.Notifications, Notification))

			TweenService:Create(Outline, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(Middle, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(Inline, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(Fill, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(Accent, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(Time, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(Title, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
			TweenService:Create(Stroke, TweenInfo.new(0.25), { Transparency = 1 }):Play()

			task.wait(0.25)

			for Index, Object in next, Library.Notifications do
				Object.Container.Position = UDim2.new(0, 10, 0, 100 + (Index * 26))
			end

			Container:Destroy()
			Outline:Destroy()
			Middle:Destroy()
			Inline:Destroy()
			Fill:Destroy()
			Accent:Destroy()
			Time:Destroy()
			Title:Destroy()
			Stroke:Destroy()
		end)

		return Notification
	end

	function Library:Indicator(Properties)
		local Indicator = {
			Title = Properties.Title or "INDICATOR",
			Position = Properties.Position or UDim2.new(0, 15, 0, 300),
			Visible = Properties.Visible or true,
			Values = {},
		}

		local Outline = Functions["Create"]("TextButton", {
			Size = UDim2.new(0, 206, 0, 300),
			Position = Indicator.Position,
			AnchorPoint = Vector2.new(0, 0),
			Visible = true,
			Parent = MainGUI,
		})

		local Middle = Functions["Create"]("Frame", {
			Parent = Outline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
		})

		local Inline = Functions["Create"]("Frame", {
			Parent = Middle,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
		})

		local Main = Functions["Create"]("Frame", {
			Parent = Inline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
		})

		local Label = Functions["Create"]("TextLabel", {
			Parent = Main,
			Text = Indicator.Title,
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, 20),
			AnchorPoint = Vector2.new(0.5, 0),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 14,
			FontFace = CustomFont,
			BackgroundTransparency = 1,
		})

		local Line = Functions["Create"]("Frame", {
			Parent = Main,
			Size = UDim2.new(1, 0, 0, 3),
			Position = UDim2.new(0, 0, 0, 20),
			AnchorPoint = Vector2.new(0, 0),
		})

		local Accent = Functions["Create"]("Frame", {
			Parent = Line,
			Size = UDim2.new(1, 2, 0, 1),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
		})

		Functions["Create"]("UIStroke", { Parent = Label })

		local Content = Functions["Create"]("Frame", {
			Parent = Main,
			Position = UDim2.new(0, 0, 0, 23),
			Size = UDim2.new(1, 0, 1, -23),
			BackgroundTransparency = 1,
		})

		local Layout = Functions["Create"]("UIListLayout", {
			Parent = Content,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 0),
		})

		local DragFrame = Functions["Create"]("Frame", {
			Parent = MainGUI,
			Size = Outline.Size,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Transparency = 1,
		})

		local DragStroke = Functions["Create"]("UIStroke", {
			Parent = DragFrame,
			Color = Color3.fromRGB(255, 255, 255),
			Transparency = 1,
		})

		Functions["AddConnection"]("IndicatorDragStart", Outline.MouseButton1Down, function()
			for _, v in next, ComponentsGUI:GetChildren() do
				if v.Visible then
					return
				end
			end
			if not Indicator.Visible then
				return
			end
			local Offset = Vector2.new(Mouse.X - Outline.AbsolutePosition.X, Mouse.Y - Outline.AbsolutePosition.Y)
			DragFrame.Position, DragFrame.AnchorPoint, DragFrame.Size =
				Outline.Position, Outline.AnchorPoint, Outline.Size
			TweenService:Create(DragFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { BackgroundTransparency = 0.7 })
				:Play()
			TweenService:Create(DragStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Transparency = 0 }):Play()
			Functions["AddConnection"]("IndicatorDragMove", UserInputService.InputChanged, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					local MousePosition = UserInputService:GetMouseLocation()
					local TargetX, TargetY = MousePosition.X - Offset.X, MousePosition.Y - Offset.Y
					local ViewportSize, FrameSize, AnchorPoint =
						Camera.ViewportSize, DragFrame.AbsoluteSize, DragFrame.AnchorPoint
					local MinX, MinY = FrameSize.X * AnchorPoint.X, FrameSize.Y * AnchorPoint.Y
					local MaxX, MaxY =
						ViewportSize.X - FrameSize.X * (1 - AnchorPoint.X),
						ViewportSize.Y - FrameSize.Y * (1 - AnchorPoint.Y)
					DragFrame.Position =
						UDim2.new(0, math.clamp(TargetX, MinX, MaxX), 0, math.clamp(TargetY, MinY, MaxY))
				end
			end)
			Functions["AddConnection"]("IndicatorDragEnded", UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Functions["RemoveConnection"]("IndicatorDragEnded")
					Functions["RemoveConnection"]("IndicatorDragMove")
					TweenService
						:Create(DragFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { BackgroundTransparency = 1 })
						:Play()
					TweenService:Create(DragStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Transparency = 1 })
						:Play()
					Outline.Position = DragFrame.Position
				end
			end)
		end)

		local Transparencys = {}
		function Indicator:Fade(Bool, Duration)
			if Bool == Indicator.Visible then
				return
			end

			local Objects = Outline:GetDescendants()
			table.insert(Objects, Outline)

			for _, Object in next, Objects do
				local Data = nil
				if not Transparencys[Object] then
					local HasTransparency = pcall(function()
						return Object.Transparency
					end)
					local HasTextTransparency = pcall(function()
						return Object.TextTransparency
					end)
					local HasBackgroundTransparency = pcall(function()
						return Object.BackgroundTransparency
					end)
					local HasImageTransparency = pcall(function()
						return Object.ImageTransparency
					end)

					Transparencys[Object] = {
						Transparency = HasTransparency and Object.Transparency or nil,
						TextTransparency = HasTextTransparency and Object.TextTransparency or nil,
						BackgroundTransparency = HasBackgroundTransparency and Object.BackgroundTransparency or nil,
						ImageTransparency = HasImageTransparency and Object.ImageTransparency or nil,
					}

					Data = Transparencys[Object]
				else
					Data = Transparencys[Object]
				end

				local Goals = {}
				if Data.Transparency and not Data.BackgroundTransparency and not Data.ImageTransparency then
					Goals.Transparency = Bool and Data.Transparency or 1
				end
				if Data.TextTransparency then
					Goals.TextTransparency = Bool and Data.TextTransparency or 1
				end
				if Data.BackgroundTransparency then
					Goals.BackgroundTransparency = Bool and Data.BackgroundTransparency or 1
				end
				if Data.ImageTransparency then
					Goals.ImageTransparency = Bool and Data.ImageTransparency or 1
				end

				if next(Goals) then
					local Tween = TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						Goals
					)
					if not Bool then
						Tween.Completed:Connect(function()
							if not Indicator.Visible then
								Outline.Visible = false
							end
						end)
					else
						Outline.Visible = true
					end
					Tween:Play()
				end
			end

			Indicator.Visible = Bool
		end

		function Indicator:Resize()
			if #Content:GetChildren() <= 1 then
				Outline.Size = UDim2.new(0, 206, 0, 60)
			else
				Outline.Size = UDim2.new(0, 206, 0, 29 + Layout.AbsoluteContentSize.Y)
			end
		end

		function Indicator:Add(Data)
			local Object = {
				Index = Data.Index or "INDEX",
				Value = Data.Key or "VALUE",
				Objects = {},
			}

			local Row = Functions["Create"]("Frame", {
				Parent = Content,
				Size = UDim2.new(1, 0, 0, 18),
				BackgroundTransparency = 1,
			})

			local IndexLabel = Functions["Create"]("TextLabel", {
				Parent = Row,
				Text = Object.Index,
				Position = UDim2.new(0, 2, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextSize = 12,
				FontFace = CustomFont,
			})

			Functions["Create"]("UIStroke", { Parent = IndexLabel })

			local ValueLabel = Functions["Create"]("TextLabel", {
				Parent = Row,
				Text = Object.Value,
				Position = UDim2.new(1, -2, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextSize = 12,
				FontFace = CustomFont,
			})

			Functions["Create"]("UIStroke", { Parent = ValueLabel })

			Object.Objects.Main = Row
			Object.Objects.Index = IndexLabel
			Object.Objects.Value = ValueLabel

			local Index = #Indicator.Values + 1
			Indicator.Values[Index] = Object
			Indicator:Resize()

			function Object:SetVisible(Bool)
				Row.Visible = Bool
				Indicator:Resize()
			end

			function Object:SetIndex(String)
				Object.Index = String
				IndexLabel.Text = String
			end

			function Object:SetValue(String)
				Object.Value = String
				ValueLabel.Text = String
			end

			function Object:SetTheme(Data)
				Functions["UpdateThemeRegistery"](IndexLabel, Data)
				Functions["UpdateThemeRegistery"](ValueLabel, Data)
			end

			function Object:Remove()
				Indicator:Remove(Index)
			end

			Functions["AddThemeRegistery"](IndexLabel, { TextColor3 = "Inactive Text" })
			Functions["AddThemeRegistery"](ValueLabel, { TextColor3 = "Inactive Text" })

			return Object
		end

		function Indicator:Remove(Index)
			local Found = Indicator.Values[Index]

			for _, Object in next, Found.Objects do
				Object:Destroy()
			end

			Indicator:Resize()
		end

		Indicator:Resize()

		Functions["AddThemeRegistery"](Outline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](Middle, { BackgroundColor3 = "Accent" })
		Functions["AddThemeRegistery"](Inline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](Main, { BackgroundColor3 = "Background 1" })
		Functions["AddThemeRegistery"](Line, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](Accent, { BackgroundColor3 = "Accent" })
		Functions["AddThemeRegistery"](Label, { TextColor3 = "Active Text" })

		return Indicator
	end

	Library.Keybinds = Library:Indicator({ Title = "KEYBINDS" })
	Library.Keybinds:Fade(false, 0)

	function Library:Watermark(Properties)
		local Properties = {
			Rate = Properties.Rate or 60,
			Format = Properties.Format or "${FPS}",
		}

		local Watermark = {
			Visible = true,
		}

		local Inset = GuiService:GetGuiInset()
		local Outline = Functions["Create"]("TextButton", {
			Size = UDim2.new(0, 206, 0, 23),
			Position = UDim2.new(0, 10, 0, Inset.Y + 10),
			AnchorPoint = Vector2.new(0, 0),
			Visible = true,
			Parent = MainGUI,
		})

		local Middle = Functions["Create"]("Frame", {
			Parent = Outline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			AnchorPoint = Vector2.new(0, 0),
		})

		local Inline = Functions["Create"]("Frame", {
			Parent = Middle,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			AnchorPoint = Vector2.new(0, 0),
		})

		local Main = Functions["Create"]("Frame", {
			Parent = Inline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			AnchorPoint = Vector2.new(0, 0),
		})

		local Label = Functions["Create"]("TextLabel", {
			Parent = Main,
			Text = "??? | ??? | ??? | ???",
			Position = UDim2.new(0, 5, 0, 2),
			AnchorPoint = Vector2.new(0, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextSize = 12,
			FontFace = CustomFont,
		})

		Functions["Create"]("UIStroke", { Parent = Label })

		local DragFrame = Functions["Create"]("Frame", {
			Parent = MainGUI,
			Size = Outline.Size,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Transparency = 1,
		})

		local DragStroke = Functions["Create"]("UIStroke", {
			Parent = DragFrame,
			Color = Color3.fromRGB(255, 255, 255),
			Transparency = 1,
		})

		Functions["AddThemeRegistery"](Outline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](Middle, { BackgroundColor3 = "Accent" })
		Functions["AddThemeRegistery"](Inline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](Main, { BackgroundColor3 = "Background 1" })
		Functions["AddThemeRegistery"](Label, { TextColor3 = "Active Text" })

		Functions["AddConnection"]("WatermarkFade", UserInputService.InputBegan, function(Input, Processed)
			if Processed then
				return
			end
		end)

		Functions["AddConnection"]("WatermarkDragStart", Outline.MouseButton1Down, function()
			if not Watermark.Visible then
				return
			end
			local Offset = Vector2.new(Mouse.X - Outline.AbsolutePosition.X, Mouse.Y - Outline.AbsolutePosition.Y)
			DragFrame.Position, DragFrame.AnchorPoint, DragFrame.Size =
				Outline.Position, Outline.AnchorPoint, Outline.Size

			TweenService:Create(DragFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { BackgroundTransparency = 0.7 })
				:Play()
			TweenService:Create(DragStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Transparency = 0 }):Play()

			Functions["AddConnection"]("WatermarkDragMove", UserInputService.InputChanged, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					local MousePosition = UserInputService:GetMouseLocation()
					local TargetX, TargetY = MousePosition.X - Offset.X, MousePosition.Y - Offset.Y
					local ViewportSize, FrameSize, AnchorPoint =
						Camera.ViewportSize, DragFrame.AbsoluteSize, DragFrame.AnchorPoint
					local MinX, MinY = FrameSize.X * AnchorPoint.X, FrameSize.Y * AnchorPoint.Y
					local MaxX, MaxY =
						ViewportSize.X - FrameSize.X * (1 - AnchorPoint.X),
						ViewportSize.Y - FrameSize.Y * (1 - AnchorPoint.Y)
					DragFrame.Position =
						UDim2.new(0, math.clamp(TargetX, MinX, MaxX), 0, math.clamp(TargetY, MinY, MaxY))
				end
			end)

			Functions["AddConnection"]("WatermarkDragEnded", UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Functions["RemoveConnection"]("WatermarkDragEnded")
					Functions["RemoveConnection"]("WatermarkDragMove")
					TweenService
						:Create(DragFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { BackgroundTransparency = 1 })
						:Play()
					TweenService:Create(DragStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Transparency = 1 })
						:Play()
					Outline.Position = DragFrame.Position
				end
			end)
		end)

		local Rate = 0
		Functions["AddConnection"]("Watermark", RunService.Heartbeat, function()
			if (tick() - Rate) < (60 / Properties.Rate) then
				return
			end
			Rate = tick()

			Label.Text = Properties.Format
				:gsub("${FPS}", Library.Stats.FPS or 0)
				:gsub("${PING}", Library.Stats.Ping or 0)
				:gsub("${TIME}", os.date("%X", os.time()))
				:gsub("${DATE}", os.date("%Y/%m/%d", os.time()))

			local Bounds = Functions["GetTextBounds"](Label.Text, 12, CustomFont)
			Outline.Size = UDim2.new(0, Bounds.X + 15, 0, 22)
		end)

		local Transparencys = {}
		function Watermark:Fade(Bool, Duration)
			if Bool == Watermark.Visible then
				return
			end

			local Objects = Outline:GetDescendants()
			table.insert(Objects, Outline)

			for _, Object in next, Objects do
				local Data = nil
				if not Transparencys[Object] then
					local HasTransparency = pcall(function()
						return Object.Transparency
					end)
					local HasTextTransparency = pcall(function()
						return Object.TextTransparency
					end)
					local HasBackgroundTransparency = pcall(function()
						return Object.BackgroundTransparency
					end)
					local HasImageTransparency = pcall(function()
						return Object.ImageTransparency
					end)

					Transparencys[Object] = {
						Transparency = HasTransparency and Object.Transparency or nil,
						TextTransparency = HasTextTransparency and Object.TextTransparency or nil,
						BackgroundTransparency = HasBackgroundTransparency and Object.BackgroundTransparency or nil,
						ImageTransparency = HasImageTransparency and Object.ImageTransparency or nil,
					}

					Data = Transparencys[Object]
				else
					Data = Transparencys[Object]
				end

				local Goals = {}
				if Data.Transparency and not Data.BackgroundTransparency and not Data.ImageTransparency then
					Goals.Transparency = Bool and Data.Transparency or 1
				end
				if Data.TextTransparency then
					Goals.TextTransparency = Bool and Data.TextTransparency or 1
				end
				if Data.BackgroundTransparency then
					Goals.BackgroundTransparency = Bool and Data.BackgroundTransparency or 1
				end
				if Data.ImageTransparency then
					Goals.ImageTransparency = Bool and Data.ImageTransparency or 1
				end

				if next(Goals) then
					local Tween = TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						Goals
					)
					if not Bool then
						Tween.Completed:Connect(function()
							if not Watermark.Visible then
								Outline.Visible = false
							end
						end)
					else
						Outline.Visible = true
					end
					Tween:Play()
				end
			end

			Watermark.Visible = Bool
		end

		return Watermark
	end

	function Library:Menu(Properties)
		local Properties = {
			Size = Properties.Size or UDim2.new(0, 500, 0, 400),
			Name = Properties.Name or "MENU",
		}

		local Menu = {
			Visible = true,
		}

		local Tabs = {}
		local CurrentTab = nil

		local MainFrameOutline = Functions["Create"]("TextButton", {
			Size = Properties.Size,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),

			Parent = MenuGUI,
		})

		local MainFrameMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = MainFrameOutline,
		})

		local MainFrameInner = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = MainFrameMiddle,
		})

		local MainFrameHolder = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Parent = MainFrameInner,
		})

		local Title = Functions["Create"]("TextLabel", {
			Parent = MainFrameHolder,
			Text = string.upper(Properties.Name),
			Position = UDim2.new(0.5, 0, 0.015, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			TextSize = 12,
			FontFace = CustomFont,
		})

		Functions["Create"]("UIStroke", {
			Parent = Title,
		})

		local InnerFrameOutline = Functions["Create"]("Frame", {
			Parent = MainFrameHolder,
			Size = UDim2.new(1, -12, 1, -26),
			Position = UDim2.new(0, 6, 0, 20),
		})

		local InnerFrameMiddle = Functions["Create"]("Frame", {
			Parent = InnerFrameOutline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
		})

		local InnerFrameInline = Functions["Create"]("Frame", {
			Parent = InnerFrameMiddle,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
		})

		local ListFrame = Functions["Create"]("Frame", {
			Parent = InnerFrameInline,
			Size = UDim2.new(1, -10, 1, -10),
			Position = UDim2.new(0, 5, 0, 5),
			Transparency = 1,
		})

		local TabFrameOutline = Functions["Create"]("Frame", {
			Parent = ListFrame,
			Size = UDim2.new(1, 0, 0.05, 1),
			Position = UDim2.new(0, 0, 0, 0),
		})

		local TabFrameInline = Functions["Create"]("Frame", {
			Parent = TabFrameOutline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
		})

		local TabFrameHolder = Functions["Create"]("Frame", {
			Parent = TabFrameInline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
		})

		local DataFrameOutline = Functions["Create"]("Frame", {
			Parent = ListFrame,
			Size = UDim2.new(1, 0, 0.94, 0),
			Position = UDim2.new(0, 0, 0.06, 0),
		})

		local DataFrameInline = Functions["Create"]("Frame", {
			Parent = DataFrameOutline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
		})

		local DataFrameFill = Functions["Create"]("Frame", {
			Parent = DataFrameInline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
		})

		local DragFrame = Functions["Create"]("Frame", {
			Parent = MenuGUI,
			Size = MainFrameOutline.Size,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Transparency = 1,
		})

		local DragStroke = Functions["Create"]("UIStroke", {
			Parent = DragFrame,
			Color = Color3.fromRGB(255, 255, 255),
			Transparency = 1,
		})

		local CursorOutline = Functions["Create"]("ImageLabel", {
			Parent = MainGUI,
			Size = UDim2.new(0, 20, 0, 28),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 1,
			Image = Functions["CustomAsset"](
				"Fondra/Assets/Library/Images/Cursor.png",
				"https://raw.githubusercontent.com/Fondra-WTF/Assets/refs/heads/main/Library/Images/Cursor.png"
			),
		})

		local CursorFill = Functions["Create"]("ImageLabel", {
			Parent = CursorOutline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1,
			Image = Functions["CustomAsset"](
				"Fondra/Assets/Library/Images/Cursor.png",
				"https://raw.githubusercontent.com/Fondra-WTF/Assets/refs/heads/main/Library/Images/Cursor.png"
			),
		})

		Functions["AddThemeRegistery"](MainFrameOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](MainFrameMiddle, { BackgroundColor3 = "Accent" })
		Functions["AddThemeRegistery"](MainFrameInner, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](MainFrameHolder, { BackgroundColor3 = "Border 2" })
		Functions["AddThemeRegistery"](Title, { TextColor3 = "Accent" })
		Functions["AddThemeRegistery"](InnerFrameOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](InnerFrameMiddle, { BackgroundColor3 = "Border 3" })
		Functions["AddThemeRegistery"](InnerFrameInline, { BackgroundColor3 = "Background 1" })
		Functions["AddThemeRegistery"](ListFrame, { BackgroundColor3 = "Border 2" })
		Functions["AddThemeRegistery"](TabFrameOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](TabFrameInline, { BackgroundColor3 = "Border 2" })
		Functions["AddThemeRegistery"](TabFrameHolder, { BackgroundColor3 = "Background 1" })
		Functions["AddThemeRegistery"](DataFrameOutline, { BackgroundColor3 = "Border 1" })
		Functions["AddThemeRegistery"](DataFrameInline, { BackgroundColor3 = "Border 2" })
		Functions["AddThemeRegistery"](DataFrameFill, { BackgroundColor3 = "Background 1" })
		Functions["AddThemeRegistery"](CursorOutline, { ImageColor3 = "Border 1" })
		Functions["AddThemeRegistery"](CursorFill, { ImageColor3 = "Accent" })

		Functions["AddConnection"]("MouseMove", UserInputService.InputChanged, function(Input, Processed)
			if Input.UserInputType == Enum.UserInputType.MouseMovement then
				local MousePosition = UserInputService:GetMouseLocation()
				CursorOutline.Position = UDim2.new(0, MousePosition.X, 0, MousePosition.Y)
			end
		end)

		Functions["AddConnection"]("MenuDragStart", MainFrameOutline.MouseButton1Down, function()
			if not Menu.Visible then
				return
			end
			local Offset = Vector2.new(
				Mouse.X - MainFrameOutline.AbsolutePosition.X + (-MainFrameOutline.AbsoluteSize.X / 2),
				Mouse.Y - MainFrameOutline.AbsolutePosition.Y + (-MainFrameOutline.AbsoluteSize.Y / 2)
			)
			DragFrame.Position, DragFrame.AnchorPoint, DragFrame.Size =
				MainFrameOutline.Position, MainFrameOutline.AnchorPoint, MainFrameOutline.Size

			TweenService:Create(DragFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { BackgroundTransparency = 0.7 })
				:Play()
			TweenService:Create(DragStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Transparency = 0 }):Play()

			Functions["AddConnection"]("MenuDragMove", UserInputService.InputChanged, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					local MousePosition = UserInputService:GetMouseLocation()
					local TargetX, TargetY = MousePosition.X - Offset.X, MousePosition.Y - Offset.Y
					local ViewportSize, FrameSize, AnchorPoint =
						Camera.ViewportSize, DragFrame.AbsoluteSize, DragFrame.AnchorPoint
					local MinX, MinY = FrameSize.X * AnchorPoint.X, FrameSize.Y * AnchorPoint.Y
					local MaxX, MaxY =
						ViewportSize.X - FrameSize.X * (1 - AnchorPoint.X),
						ViewportSize.Y - FrameSize.Y * (1 - AnchorPoint.Y)
					DragFrame.Position =
						UDim2.new(0, math.clamp(TargetX, MinX, MaxX), 0, math.clamp(TargetY, MinY, MaxY))
				end
			end)

			Functions["AddConnection"]("MenuDragEnded", UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Functions["RemoveConnection"]("MenuDragEnded")
					Functions["RemoveConnection"]("MenuDragMove")
					TweenService
						:Create(DragFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { BackgroundTransparency = 1 })
						:Play()
					TweenService:Create(DragStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Transparency = 1 })
						:Play()
					MainFrameOutline.Position = DragFrame.Position
				end
			end)
		end)

		function SetTab(Current)
			for Index, Tab in next, Tabs do
				local Selected = Tab == Current

				if Tab.Objects.List then
					Tab.Objects.List.Visible = false
				end

				Tab.Objects.Background.Size = UDim2.new(1 / #Tabs, Index == #Tabs and -2 or -1, 1, -2)
				Tab.Objects.Background.Position = UDim2.new((Index - 1) * (1 / #Tabs), 1, 0, 1)
				Tab.Objects.Gradient.Rotation = Selected and 0 or 180

				Functions["UpdateThemeRegistery"](
					Tab.Objects.Background,
					{ BackgroundColor3 = Selected and "Selected Tab" or "Unselected Tab" }
				)
				Functions["UpdateThemeRegistery"](
					Tab.Objects.Label,
					{ TextColor3 = Selected and "Accent" or "Inactive Text" }
				)

				Tab.Objects.Holder.Visible = false
			end

			CurrentTab = Current
			CurrentTab.Objects.Holder.Visible = true
		end

		local Transparencys = {}
		function Menu:Fade(Bool, Duration)
			if Bool == Menu.Visible then
				return
			end

			local Objects = MainFrameOutline:GetDescendants()
			table.insert(Objects, MainFrameOutline)

			UserInputService.MouseIconEnabled = not Bool
			CursorOutline.Visible = Bool

			for _, Object in next, Objects do
				local Data = nil
				if not Transparencys[Object] then
					local HasTransparency = pcall(function()
						return Object.Transparency
					end)
					local HasTextTransparency = pcall(function()
						return Object.TextTransparency
					end)
					local HasBackgroundTransparency = pcall(function()
						return Object.BackgroundTransparency
					end)
					local HasImageTransparency = pcall(function()
						return Object.ImageTransparency
					end)

					Transparencys[Object] = {
						Transparency = HasTransparency and Object.Transparency or nil,
						TextTransparency = HasTextTransparency and Object.TextTransparency or nil,
						BackgroundTransparency = HasBackgroundTransparency and Object.BackgroundTransparency or nil,
						ImageTransparency = HasImageTransparency and Object.ImageTransparency or nil,
					}

					Data = Transparencys[Object]
				else
					Data = Transparencys[Object]
				end

				local Goals = {}
				if Data.Transparency and not Data.BackgroundTransparency and not Data.ImageTransparency then
					Goals.Transparency = Bool and Data.Transparency or 1
				end
				if Data.TextTransparency then
					Goals.TextTransparency = Bool and Data.TextTransparency or 1
				end
				if Data.BackgroundTransparency then
					Goals.BackgroundTransparency = Bool and Data.BackgroundTransparency or 1
				end
				if Data.ImageTransparency then
					Goals.ImageTransparency = Bool and Data.ImageTransparency or 1
				end

				if next(Goals) then
					local Tween = TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						Goals
					)
					if not Bool then
						Tween.Completed:Connect(function()
							if not Menu.Visible then
								MainFrameOutline.Visible = false
							end
						end)
					else
						MainFrameOutline.Visible = true
					end
					Tween:Play()
				end
			end

			Menu.Visible = Bool
		end

		function Menu:Players(Properties)
			local Tab = { Objects = {} }
			local Cache = {}

			local Main = Functions["Create"]("TextButton", {
				Parent = TabFrameHolder,
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 0),
				Text = "",
			})

			local Gradient = Functions["Create"]("ImageLabel", {
				Parent = Main,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ImageTransparency = 0.6,
				Image = Functions["CustomAsset"](
					"Fondra/Assets/Library/Images/Gradient 90.png",
					"https://raw.githubusercontent.com/Fondra-WTF/Assets/refs/heads/main/Library/Images/Gradient%2090.png"
				),
			})

			local Label = Functions["Create"]("TextLabel", {
				Parent = Main,
				Text = Properties.Name,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				FontFace = CustomFont,
				TextSize = 12,
			})

			local PlayerListOutline = Functions["Create"]("TextButton", {
				Parent = DataFrameFill,
				Size = UDim2.new(1, -16, 1, -16),
				Position = UDim2.new(0, 8, 0, 8),
				Text = "",
			})

			local PlayerListAccent = Functions["Create"]("TextButton", {
				Parent = PlayerListOutline,
				Size = UDim2.new(1, -2, 0, 1),
				Position = UDim2.new(0, 1, 0, 0),
				AnchorPoint = Vector2.new(0, 0),
				Text = "",
			})

			local PlayerListMiddle = Functions["Create"]("TextButton", {
				Parent = PlayerListOutline,
				Size = UDim2.new(1, -2, 1, -3),
				Position = UDim2.new(0.5, 0, 0, 2),
				AnchorPoint = Vector2.new(0.5, 0),
				Text = "",
			})

			local PlayerListInline = Functions["Create"]("TextButton", {
				Parent = PlayerListMiddle,
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Text = "",
			})

			local PlayerListFill = Functions["Create"]("TextButton", {
				Parent = PlayerListInline,
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Text = "",
			})

			local PlayerListScrollFrameOutline = Functions["Create"]("TextButton", {
				Parent = PlayerListFill,
				Size = UDim2.new(1, -16, 0.8, -16),
				Position = UDim2.new(0, 8, 0, 8),
				Text = "",
			})

			local PlayerListScrollFrameInline = Functions["Create"]("ScrollingFrame", {
				Parent = PlayerListScrollFrameOutline,
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ClipsDescendants = true,
				ScrollBarThickness = 0,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
			})

			Functions["Create"]("UIListLayout", {
				Parent = PlayerListScrollFrameInline,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			})

			local PlayerListDataFrameOutline = Functions["Create"]("TextButton", {
				Parent = PlayerListFill,
				Size = UDim2.new(1, -16, 0.2, -8),
				Position = UDim2.new(0, 8, 1, -8),
				AnchorPoint = Vector2.new(0, 1),
				Text = "",
			})

			local PlayerListDataFrameInline = Functions["Create"]("TextButton", {
				Parent = PlayerListDataFrameOutline,
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Text = "",
			})

			local PreviewIconOutline = Functions["Create"]("Frame", {
				Parent = PlayerListDataFrameInline,
				Size = UDim2.new(1, -16, 1, -16),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Position = UDim2.new(0, 8, 0, 8),
			})

			local PreviewIconInline = Functions["Create"]("Frame", {
				Parent = PreviewIconOutline,
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0, 1, 0, 1),
			})

			local PreviewIconFill = Functions["Create"]("Frame", {
				Parent = PreviewIconInline,
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0, 1, 0, 1),
			})

			local PreviewIconImage = Functions["Create"]("ImageLabel", {
				Parent = PreviewIconFill,
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0, 1, 0, 1),
				BackgroundTransparency = 1,
			})

			local PreviewNameText = Functions["Create"]("TextLabel", {
				Parent = PreviewIconOutline,
				Text = "???",
				Position = UDim2.new(1, 4, 0, 2),
				AnchorPoint = Vector2.new(1, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 18,
				FontFace = CustomFont,
			})

			local PreviewStatusDropdown = Functions["Create"]("TextButton", {
				Parent = PreviewIconOutline,
				Position = UDim2.new(1, 2, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				Size = UDim2.new(1.5, 0, 0, 22),
				Text = "",
				Transparency = Library.Debug and 0 or 1,
			})

			Functions["Create"]("UIStroke", { Parent = Label })
			Functions["AddThemeRegistery"](Main, { BackgroundColor3 = "Unselected Tab" })
			Functions["AddThemeRegistery"](PlayerListOutline, { BackgroundColor3 = "Border 2" })
			Functions["AddThemeRegistery"](PlayerListAccent, { BackgroundColor3 = "Accent" })
			Functions["AddThemeRegistery"](PlayerListMiddle, { BackgroundColor3 = "Border 1" })
			Functions["AddThemeRegistery"](PlayerListInline, { BackgroundColor3 = "Border 2" })
			Functions["AddThemeRegistery"](PlayerListFill, { BackgroundColor3 = "Section Background" })
			Functions["AddThemeRegistery"](PlayerListScrollFrameOutline, { BackgroundColor3 = "Border 1" })
			Functions["AddThemeRegistery"](PlayerListScrollFrameInline, { BackgroundColor3 = "Border 2" })
			Functions["AddThemeRegistery"](PlayerListDataFrameOutline, { BackgroundColor3 = "Border 1" })
			Functions["AddThemeRegistery"](PlayerListDataFrameInline, { BackgroundColor3 = "Border 2" })
			Functions["AddThemeRegistery"](PreviewIconOutline, { BackgroundColor3 = "Border 1" })
			Functions["AddThemeRegistery"](PreviewIconInline, { BackgroundColor3 = "Border 2" })
			Functions["AddThemeRegistery"](PreviewIconFill, { BackgroundColor3 = "Option Background" })
			Functions["AddThemeRegistery"](PreviewNameText, { TextColor3 = "Active Text" })

			local Objects = {}
			local Selected = nil

			local PreviewStatusDropdownComponent = Components["Dropdown"](PreviewStatusDropdown, {
				Text = "STATUS",
				Options = { "NONE", "FRIENDLY", "PRIORITY" },
				Current = { "NONE" },
				Minimum = 1,
				Maximum = 1,
				Callback = function(Result)
					if not Selected then
						return
					end
					local Status = Result[1]
					Objects[Selected].Status.Text = Status
					Relations[Selected] = Status
					if Status == "FRIENDLY" then
						Functions["UpdateThemeRegistery"](Objects[Selected].Status, { TextColor3 = "Accent" })
					elseif Status == "PRIORITY" then
						Functions["UpdateThemeRegistery"](Objects[Selected].Status, { TextColor3 = "Warning Text" })
					else
						Functions["UpdateThemeRegistery"](Objects[Selected].Status, { TextColor3 = "Active Text" })
					end
				end,
			})

			local function LoadThumbnail(Player)
				if Cache[Player.UserId] then
					return
				end

				task.spawn(function()
					local ok, content = pcall(function()
						return Players:GetUserThumbnailAsync(
							Player.UserId,
							Enum.ThumbnailType.HeadShot,
							Enum.ThumbnailSize.Size150x150
						)
					end)

					if ok then
						Cache[Player.UserId] = content
					else
						Cache[Player.UserId] = "rbxasset://textures/ui/GuiImagePlaceholder.png"
					end

					if Selected == Player then
						PreviewIconImage.Image = Cache[Player.UserId]
					end
				end)
			end

			local function GetThumbnail(Player)
				return Cache[Player.UserId] or "rbxasset://textures/ui/GuiImagePlaceholder.png"
			end

			local function CreatePlayerEntry(Player)
				if Player == Client then
					return
				end

				LoadThumbnail(Player)
				Relations[Player] = Relations[Player] or "NONE"

				local PlayerButton = Functions["Create"]("TextButton", {
					Parent = PlayerListScrollFrameInline,
					Size = UDim2.new(1, 0, 1 / 10, 0),
					BackgroundTransparency = 1,
					Text = "",
				})

				local PlayerName = Functions["Create"]("TextLabel", {
					Parent = PlayerButton,
					Text = Player.Name,
					Position = UDim2.new(0, 8, 0.5, 0),
					Size = UDim2.new(0.7, -8, 0, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					FontFace = CustomFont,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
				})

				local PlayerStatus = Functions["Create"]("TextLabel", {
					Parent = PlayerButton,
					Text = Relations[Player],
					Position = UDim2.new(1, -8, 0.5, 0),
					Size = UDim2.new(0.3, -8, 0, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					FontFace = CustomFont,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Right,
				})

				Functions["UpdateThemeRegistery"](PlayerName, { TextColor3 = "Active Text" })
				Functions["UpdateThemeRegistery"](PlayerStatus, { TextColor3 = "Active Text" })

				Objects[Player] = { Button = PlayerButton, Name = PlayerName, Status = PlayerStatus }

				Functions["AddConnection"](Tab, PlayerButton.MouseButton1Down, function()
					if Selected and Objects[Selected] then
						Functions["UpdateThemeRegistery"](Objects[Selected].Name, { TextColor3 = "Active Text" })
					end
					Selected = Player
					Functions["UpdateThemeRegistery"](PlayerName, { TextColor3 = "Accent" })
					PreviewNameText.Text = Player.Name
					PreviewStatusDropdownComponent:Set({ PlayerStatus.Text })
					PreviewIconImage.Image = GetThumbnail(Player)
				end)
			end

			local function RemovePlayerEntry(Player)
				local Object = Objects[Player]

				if not Object then
					return
				end

				if Selected == Player then
					Selected = nil
					PreviewNameText.Text = "Select Player"
					PreviewIconImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
				end

				Object.Button:Destroy()

				Objects[Player] = nil
				Relations[Player] = nil
				Cache[Player.UserId] = nil
			end

			for _, Player in next, Players:GetPlayers() do
				CreatePlayerEntry(Player)
			end

			Functions["AddConnection"](Tab, Players.PlayerAdded, CreatePlayerEntry)
			Functions["AddConnection"](Tab, Players.PlayerRemoving, RemovePlayerEntry)

			Tab.Objects.Background = Main
			Tab.Objects.Gradient = Gradient
			Tab.Objects.Label = Label
			Tab.Objects.Holder = PlayerListOutline

			Functions["AddConnection"](nil, Main.MouseButton1Down, function()
				if CurrentTab ~= Tab then
					SetTab(Tab)
				end
			end)

			table.insert(Tabs, Tab)
			SetTab(Tabs[1])

			return Tab
		end

		function Menu:Tab(Properties)
			local Tab = {
				Functions = {},
				Objects = {},
			}

			local DataFrameHolder = Functions["Create"]("Frame", {
				Parent = DataFrameFill,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
			})

			local ContainerLeft = Functions["Create"]("ScrollingFrame", {
				Size = UDim2.new(0.493, -8, 1, -16),
				Position = UDim2.new(0, 8, 0, 8),
				Parent = DataFrameHolder,
				ScrollBarThickness = 0,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				ClipsDescendants = true,
			})

			local ContainerLeftLayout = Functions["Create"]("UIListLayout", {
				Parent = ContainerLeft,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 8),
			})

			local ContainerRight = Functions["Create"]("ScrollingFrame", {
				Size = UDim2.new(0.493, -8, 1, -16),
				Position = UDim2.new(1, -8, 0, 8),
				AnchorPoint = Vector2.new(1, 0, 0, 0),
				Parent = DataFrameHolder,
				ScrollBarThickness = 0,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				ClipsDescendants = true,
			})

			local ContainerRightLayout = Functions["Create"]("UIListLayout", {
				Parent = ContainerRight,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 8),
			})

			local Main = Functions["Create"]("TextButton", {
				Parent = TabFrameHolder,
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 0),
				Theme = { BackgroundColor3 = "Unselected Tab" },
			})

			local Gradient = Functions["Create"]("ImageLabel", {
				Parent = Main,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				ImageTransparency = 0.6,
				Image = Functions["CustomAsset"](
					"Fondra/Assets/Library/Images/Gradient 90.png",
					"https://raw.githubusercontent.com/Fondra-WTF/Assets/refs/heads/main/Library/Images/Gradient%2090.png"
				),
			})

			local Label = Functions["Create"]("TextLabel", {
				Parent = Main,
				Text = Properties.Name,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				FontFace = CustomFont,
				TextSize = 12,
			})

			Functions["Create"]("UIStroke", {
				Parent = Label,
			})

			Tab.Objects.Background = Main
			Tab.Objects.Gradient = Gradient
			Tab.Objects.Label = Label
			Tab.Objects.Holder = DataFrameHolder

			Functions["AddConnection"](nil, Main.MouseButton1Down, function()
				if CurrentTab == Tab then
					return
				end

				SetTab(Tab)
			end)

			function Tab:Section(Properties)
				local Properties = {
					Side = Properties.Side or "LEFT",
					Title = Properties.Title or "SECTION",
				}

				local Section = {}

				local Column = Properties.Side == "RIGHT" and ContainerRight
					or Properties.Side == "LEFT" and ContainerLeft

				local Main = Functions["Create"]("TextButton", {
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 0, 40),
					Parent = Column,
				})
				local ButtonsOutline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 2),
					Size = UDim2.new(1, -2, 0, 18),
					Parent = Main,
				})
				local ButtonsInline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					Parent = ButtonsOutline,
				})
				local ButtonsHolder = Functions["Create"]("Frame", {
					Parent = ButtonsInline,
					Size = UDim2.new(1, -2, 1, -2),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
				})
				local SectionLabel = Functions["Create"]("TextLabel", {
					Parent = ButtonsHolder,
					Text = Properties.Title,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextSize = 12,
					Size = UDim2.new(1, 0, 1, 0),
					FontFace = CustomFont,
				})
				local Accent = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 0, 1),
					Parent = Main,
				})
				local HolderOutline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 19),
					Size = UDim2.new(1, -2, 1, -20),
					Parent = Main,
				})
				local HolderInline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					Parent = HolderOutline,
				})
				local HolderMain = Functions["Create"]("Frame", {
					Parent = HolderInline,
					Size = UDim2.new(1, -2, 1, -2),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
				})
				local HolderLayout = Functions["Create"]("UIListLayout", {
					Parent = HolderMain,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				})

				Functions["AddThemeRegistery"](Main, { BackgroundColor3 = "Border 2" })
				Functions["AddThemeRegistery"](ButtonsOutline, { BackgroundColor3 = "Border 1" })
				Functions["AddThemeRegistery"](ButtonsInline, { BackgroundColor3 = "Border 2" })
				Functions["AddThemeRegistery"](ButtonsHolder, { BackgroundColor3 = "Section Background" })
				Functions["AddThemeRegistery"](
					SectionLabel,
					{ TextColor3 = "Active Text", BackgroundColor3 = "Section Background" }
				)
				Functions["AddThemeRegistery"](Accent, { BackgroundColor3 = "Accent" })
				Functions["AddThemeRegistery"](HolderOutline, { BackgroundColor3 = "Border 1" })
				Functions["AddThemeRegistery"](HolderInline, { BackgroundColor3 = "Border 2" })
				Functions["AddThemeRegistery"](HolderMain, { BackgroundColor3 = "Section Background" })

				function ResizeSection()
					if #HolderMain:GetChildren() < 2 then
						Main.Size = UDim2.new(1, 0, 0, 40)
					else
						Main.Size = UDim2.new(1, 0, 0, 24 + HolderLayout.AbsoluteContentSize.Y)
					end
				end

				function Section:Toggle(Options)
					local Holder = Functions["Create"]("Frame", {
						Parent = HolderMain,
						Size = UDim2.new(1, 0, 0, 20),
						BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
						Transparency = Library.Debug and 0 or 1,
					})

					local Main = Functions["Create"]("TextButton", {
						Parent = Holder,
						Size = UDim2.new(1, 0, 1, -4),
						BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
						Transparency = Library.Debug and 0 or 1,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, 0),
					})

					local Toggle = Components["Toggle"](Main, Options)
					ResizeSection()

					return Toggle
				end

				function Section:Slider(Options)
					local Holder = Functions["Create"]("Frame", {
						Parent = HolderMain,
						Size = UDim2.new(1, 0, 0, 22),
						BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
						Transparency = Library.Debug and 0 or 1,
					})

					local Main = Functions["Create"]("TextButton", {
						Parent = Holder,
						Size = UDim2.new(1, -4, 1, -4),
						Transparency = Library.Debug and 0 or 1,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
					})

					local Slider = Components["Slider"](Main, Options)
					ResizeSection()

					return Slider
				end

				function Section:Dropdown(Options)
					local Holder = Functions["Create"]("Frame", {
						Parent = HolderMain,
						Size = UDim2.new(1, 0, 0, 22),
						BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
						Transparency = Library.Debug and 0 or 1,
					})

					local Main = Functions["Create"]("TextButton", {
						Parent = Holder,
						Size = UDim2.new(1, -4, 1, -4),
						Transparency = Library.Debug and 0 or 1,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
					})

					local Dropdown = Components["Dropdown"](Main, Options)
					ResizeSection()

					return Dropdown
				end

				function Section:TextBox(Options)
					local Holder = Functions["Create"]("Frame", {
						Parent = HolderMain,
						Size = UDim2.new(1, 0, 0, 22),
						BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
						Transparency = Library.Debug and 0 or 1,
					})

					local Main = Functions["Create"]("TextButton", {
						Parent = Holder,
						Size = UDim2.new(1, -4, 1, -4),
						Transparency = Library.Debug and 0 or 1,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
					})

					local TextBox = Components["TextBox"](Main, Options)
					ResizeSection()

					return TextBox
				end

				function Section:Button(Options)
					local Holder = Functions["Create"]("Frame", {
						Parent = HolderMain,
						Size = UDim2.new(1, 0, 0, 22),
						BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
						Transparency = Library.Debug and 0 or 1,
					})

					local Main = Functions["Create"]("TextButton", {
						Parent = Holder,
						Size = UDim2.new(1, -4, 1, -4),
						Transparency = Library.Debug and 0 or 1,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
					})

					local Button = Components["Button"](Main, Options)
					ResizeSection()

					return Button
				end

				function Section:Label(Options)
					local Holder = Functions["Create"]("Frame", {
						Parent = HolderMain,
						Size = UDim2.new(1, 0, 0, 22),
						BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
						Transparency = Library.Debug and 0 or 1,
					})

					local Main = Functions["Create"]("TextButton", {
						Parent = Holder,
						Size = UDim2.new(1, -4, 1, -4),
						Transparency = Library.Debug and 0 or 1,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
					})

					local Label = Components["Label"](Main, Options)
					ResizeSection()

					return Label
				end

				function Section:Divider(Options)
					local Holder = Functions["Create"]("Frame", {
						Parent = HolderMain,
						Size = UDim2.new(1, 0, 0, Options.Gap or 10),
						BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
						Transparency = Library.Debug and 0 or 1,
					})

					local Main = Functions["Create"]("TextButton", {
						Parent = Holder,
						Size = UDim2.new(1, -4, 1, -4),
						Transparency = Library.Debug and 0 or 1,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
					})

					ResizeSection()

					return
				end

				ResizeSection()

				return Section
			end

			function Tab:MultiSection(Properties)
				local Properties = {
					Side = Properties.Side or "LEFT",
					Sections = {},
				}

				local Column = Properties.Side == "RIGHT" and ContainerRight
					or Properties.Side == "LEFT" and ContainerLeft

				local Main = Functions["Create"]("TextButton", {
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 0, 40),
					Parent = Column,
				})

				local ButtonsOutline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 2),
					Size = UDim2.new(1, -2, 0, 18),
					Parent = Main,
				})

				local ButtonsInline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					Parent = ButtonsOutline,
				})

				local ButtonsHolder = Functions["Create"]("Frame", {
					Parent = ButtonsInline,
					Size = UDim2.new(1, -2, 1, -2),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
				})

				local Accent = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 0, 1),
					Parent = Main,
				})

				local HolderOutline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 19),
					Size = UDim2.new(1, -2, 1, -20),
					Parent = Main,
				})

				local HolderInline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					Parent = HolderOutline,
				})

				local HolderMain = Functions["Create"]("Frame", {
					Parent = HolderInline,
					Size = UDim2.new(1, -2, 1, -2),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
				})

				Functions["Create"]("UIListLayout", {
					Parent = HolderMain,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				})

				Functions["AddThemeRegistery"](Main, { BackgroundColor3 = "Border 2" })
				Functions["AddThemeRegistery"](ButtonsOutline, { BackgroundColor3 = "Border 1" })
				Functions["AddThemeRegistery"](ButtonsInline, { BackgroundColor3 = "Border 2" })
				Functions["AddThemeRegistery"](ButtonsHolder, { BackgroundColor3 = "Section Background" })
				Functions["AddThemeRegistery"](Accent, { BackgroundColor3 = "Accent" })
				Functions["AddThemeRegistery"](HolderOutline, { BackgroundColor3 = "Border 1" })
				Functions["AddThemeRegistery"](HolderInline, { BackgroundColor3 = "Border 2" })
				Functions["AddThemeRegistery"](HolderMain, { BackgroundColor3 = "Section Background" })

				local MultiSectionTabs, MultiSectionCurrentTab = {}, nil
				local MultiSection = {}

				local function SetMultiSectionTab(Current)
					for Index, Tab in next, MultiSectionTabs do
						local Selected = Tab == Current

						Tab.Objects.Background.Size =
							UDim2.new(1 / #MultiSectionTabs, Index == #MultiSectionTabs and -2 or -1, 1, -2)
						Tab.Objects.Background.Position = UDim2.new((Index - 1) * (1 / #MultiSectionTabs), 1, 0, 1)
						Tab.Objects.Gradient.Rotation = Selected and 0 or 180

						Functions["UpdateThemeRegistery"](
							Tab.Objects.Label,
							{ TextColor3 = Selected and "Active Text" or "Inactive Text" }
						)

						Tab.Objects.Main.Visible = false
					end

					MultiSectionCurrentTab = Current
					Current.Objects.Main.Visible = true
				end

				function MultiSection:Section(Properties)
					local Properties = {
						Title = Properties.Title or "SECTION",
					}

					local Section = {
						Objects = {},
					}

					local HolderMain = Functions["Create"]("Frame", {
						Parent = HolderInline,
						Size = UDim2.new(1, -2, 1, -2),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
					})

					local HolderLayout = Functions["Create"]("UIListLayout", {
						Parent = HolderMain,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					})

					local Button = Functions["Create"]("TextButton", {
						Parent = ButtonsHolder,
						Size = UDim2.new(0, 0, 0, 0),
						Position = UDim2.new(0, 0, 0, 0),
					})

					local Gradient = Functions["Create"]("ImageLabel", {
						Parent = Button,
						Size = UDim2.new(1, 0, 1, 0),
						Position = UDim2.new(0, 0, 0, 0),
						BackgroundTransparency = 1,
						ImageTransparency = 0.6,
						Image = Functions["CustomAsset"](
							"Fondra/Assets/Library/Images/Gradient 90.png",
							"https://raw.githubusercontent.com/Fondra-WTF/Assets/refs/heads/main/Library/Images/Gradient%2090.png"
						),
					})

					local Label = Functions["Create"]("TextLabel", {
						Parent = Button,
						Text = Properties.Title,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						FontFace = CustomFont,
						TextSize = 12,
					})

					Functions["Create"]("UIStroke", {
						Parent = Label,
					})

					Functions["AddThemeRegistery"](HolderMain, { BackgroundColor3 = "Section Background" })
					Functions["AddThemeRegistery"](Button, { BackgroundColor3 = "Section Background" })

					Section.Objects.Background = Button
					Section.Objects.Gradient = Gradient
					Section.Objects.Label = Label
					Section.Objects.Main = HolderMain

					local function ResizeMultiSection()
						if MultiSectionCurrentTab ~= Section then
							return
						end

						if #HolderMain:GetChildren() < 2 then
							Main.Size = UDim2.new(1, 0, 0, 40)
						else
							Main.Size = UDim2.new(1, 0, 0, 24 + HolderLayout.AbsoluteContentSize.Y)
						end
					end

					Functions["AddConnection"](nil, Button.MouseButton1Down, function()
						if MultiSectionCurrentTab == Section then
							return
						end

						SetMultiSectionTab(Section)
						ResizeMultiSection()
					end)

					function Section:Toggle(Options)
						local Holder = Functions["Create"]("Frame", {
							Parent = HolderMain,
							Size = UDim2.new(1, 0, 0, 20),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
						})

						local Main = Functions["Create"]("TextButton", {
							Parent = Holder,
							Size = UDim2.new(1, 0, 1, -4),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0),
						})

						local Toggle = Components["Toggle"](Main, Options)
						ResizeMultiSection()

						return Toggle
					end

					function Section:Slider(Options)
						local Holder = Functions["Create"]("Frame", {
							Parent = HolderMain,
							Size = UDim2.new(1, 0, 0, 22),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
						})

						local Main = Functions["Create"]("TextButton", {
							Parent = Holder,
							Size = UDim2.new(1, -4, 1, -4),
							Transparency = Library.Debug and 0 or 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
						})

						local Slider = Components["Slider"](Main, Options)
						ResizeMultiSection()

						return Slider
					end

					function Section:Dropdown(Options)
						local Holder = Functions["Create"]("Frame", {
							Parent = HolderMain,
							Size = UDim2.new(1, 0, 0, 22),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
						})

						local Main = Functions["Create"]("TextButton", {
							Parent = Holder,
							Size = UDim2.new(1, -4, 1, -4),
							Transparency = Library.Debug and 0 or 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
						})

						local Dropdown = Components["Dropdown"](Main, Options)
						ResizeMultiSection()

						return Dropdown
					end

					function Section:TextBox(Options)
						local Holder = Functions["Create"]("Frame", {
							Parent = HolderMain,
							Size = UDim2.new(1, 0, 0, 22),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
						})

						local Main = Functions["Create"]("TextButton", {
							Parent = Holder,
							Size = UDim2.new(1, -4, 1, -4),
							Transparency = Library.Debug and 0 or 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
						})

						local TextBox = Components["TextBox"](Main, Options)
						ResizeMultiSection()

						return TextBox
					end

					function Section:Button(Options)
						local Holder = Functions["Create"]("Frame", {
							Parent = HolderMain,
							Size = UDim2.new(1, 0, 0, 22),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
						})

						local Main = Functions["Create"]("TextButton", {
							Parent = Holder,
							Size = UDim2.new(1, -4, 1, -4),
							Transparency = Library.Debug and 0 or 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
						})

						local Button = Components["Button"](Main, Options)
						ResizeMultiSection()

						return Button
					end

					function Section:Label(Options)
						local Holder = Functions["Create"]("Frame", {
							Parent = HolderMain,
							Size = UDim2.new(1, 0, 0, 22),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
						})

						local Main = Functions["Create"]("TextButton", {
							Parent = Holder,
							Size = UDim2.new(1, -4, 1, -4),
							Transparency = Library.Debug and 0 or 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
						})

						local Label = Components["Label"](Main, Options)
						ResizeMultiSection()

						return Label
					end

					function Section:Divider(Options)
						local Holder = Functions["Create"]("Frame", {
							Parent = HolderMain,
							Size = UDim2.new(1, 0, 0, Options.Gap or 10),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
						})

						local Main = Functions["Create"]("TextButton", {
							Parent = Holder,
							Size = UDim2.new(1, -4, 1, -4),
							Transparency = Library.Debug and 0 or 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
						})

						ResizeMultiSection()

						return
					end

					table.insert(MultiSectionTabs, Section)
					SetMultiSectionTab(MultiSectionTabs[1])
					ResizeMultiSection()

					return Section
				end

				return MultiSection
			end

			table.insert(Tabs, Tab)
			SetTab(Tabs[1])

			return Tab
		end

		Menu:Fade(false, 0)
		Menu:Fade(true, 0)

		return Menu
	end
end

getgenv().Library = Library

return Library
