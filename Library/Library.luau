-- ! Powered by ChatGPT, Made by QwenAI, Double Checked by DeepseekAI and quadruple checked by GeminiAI
-- ? Only the best, Made by AI😱

makefolder("Fondra")
makefolder("Fondra/Assets")
makefolder("Fondra/Assets/Fonts")
makefolder("Fondra/Assets/Fonts/TTF")
makefolder("Fondra/Assets/Fonts/JSON")

makefolder("Fondra/Assets/Images")
makefolder("Fondra/Assets/Videos")
makefolder("Fondra/Assets/Sounds")

local Library = {
	Connections = {},
	Notifications = {},
	Objects = {},

	Stats = {},
	Flags = {
		Toggle = {},
		Slider = {},
		Dropdown = {},
		TextBox = {},
		Keybind = {},
		Colorpicker = {},
	},
	Relations = {},

	Functions = {},
	Components = {},

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

local Images = {
	["Gradient 90"] = "https://raw.githubusercontent.com/portallol/luna/main/Gradient.png",
	["Dropdown Down"] = "https://i.imgur.com/uHliPN2.png",
	["Dropdown Up"] = "https://i.imgur.com/7H3o3h2.png",
	["Saturation One"] = "https://i.imgur.com/08Iv5Jk.png",
	["Saturation Two"] = "https://i.imgur.com/38BPVmI.png",
	["Alpha"] = "https://i.imgur.com/gqN9Dzg.png",
	["Hue"] = "https://i.imgur.com/wNQNq7p.png",
}

for Index, Object in next, Images do
	if not isfile("Fondra/Assets/Images/" .. Index .. ".png") then
		writefile("Fondra/Assets/Images/" .. Index .. ".png", game:HttpGet(Object))
	end
end

for Index, Object in next, Fonts do
	if not isfile("Fondra/Assets/Fonts/TTF/" .. Index .. ".ttf") then
		writefile("Fondra/Assets/Fonts/TTF/" .. Index .. ".ttf", game:HttpGet(Object))
	end

	writefile(
		"Fondra/Assets/Fonts/JSON/" .. Index .. ".json",
		game:GetService("HttpService"):JSONEncode({
			name = Index,
			faces = {
				{
					name = "Regular",
					weight = 400,
					style = "normal",
					assetId = getcustomasset("Fondra/Assets/Fonts/TTF/" .. Index .. ".ttf"),
				},
			},
		})
	)
end

local CustomFont =
	Font.new(getcustomasset("Fondra/Assets/Fonts/JSON/Proggy.json"), Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")

local Client = Players.LocalPlayer
local Mouse = Client:GetMouse()
local Camera = Workspace.CurrentCamera
local PlayerGui = Client:WaitForChild("PlayerGui")

local MainGUI = Instance.new("ScreenGui")
MainGUI.Name = "FONDRA"
MainGUI.ResetOnSpawn = false
MainGUI.IgnoreGuiInset = true
MainGUI.Parent = PlayerGui
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
ComponentsGUI.Parent = PlayerGui
ComponentsGUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
ComponentsGUI.DisplayOrder = 1000000 + 2

local NotificationsGUI = Instance.new("ScreenGui")
NotificationsGUI.Name = "Notifications"
NotificationsGUI.ResetOnSpawn = false
NotificationsGUI.IgnoreGuiInset = true
NotificationsGUI.Parent = PlayerGui
NotificationsGUI.ZIndexBehavior = Enum.ZIndexBehavior.Global
NotificationsGUI.DisplayOrder = 1000000 + 3

local Functions = {}
do
	-- ! Necessary
	Functions["Message"] = function(Message, Type)
		if not Library.Debug then
			return
		end

		return Message
	end

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

		Library.Objects[Object] = Data
	end

	Functions["UpdateThemeRegistery"] = function(Object, Data)
		Library.Objects[Object] = Data

		for Property, ThemeKey in next, Data do
			if typeof(ThemeKey) == "Color3" then
				Object[Property] = ThemeKey
			else
				Object[Property] = Library.Theme[ThemeKey]
			end
		end
	end

	Functions["RefreshThemeRegistery"] = function()
		for Object, Data in next, Library.Objects do
			for Property, ThemeKey in next, Data do
				if typeof(ThemeKey) == "Color3" then
					Object[Property] = ThemeKey
				else
					Object[Property] = Library.Theme[ThemeKey]
				end
			end
		end
	end

	local Cache = {}
	Functions["CustomAsset"] = function(Path)
		if Cache[Path] then
			return Cache[Path]
		else
			Cache[Path] = getcustomasset(Path)
		end

		return Cache[Path]
	end

	Functions["Create"] = function(Class, Properties)
		if not Class then
			return Functions["Message"]("Class Argument left blank.", "Error")
		end
		if not Properties then
			return Functions["Message"]("Properties Argument left blank.", "Error")
		end
		if typeof(Class) ~= "string" then
			return Functions["Message"]("Class is not a string.", "Error")
		end
		if typeof(Properties) ~= "table" then
			return Functions["Message"]("Properties is not a table.", "Error")
		end

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

		local ThemeData = Properties.Theme
		Properties.Theme = nil

		for Property, Value in pairs(Properties) do
			Object[Property] = Value
		end

		if ThemeData then
			Functions["AddThemeRegistery"](Object, ThemeData)
		end

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
end
Library.Functions = Functions

local Components = {}
do
	Components["Toggle"] = function(Holder, Options)
		local Options = {
			Text = Options.Text or "TOGGLE",
			Flag = Options.Flag,
			Callback = Options.Callback,
			Dangerous = Options.Dangerous or false,
			Value = Options.Value or false,
		}

		local Toggle = {
			Value = Options.Value,
			Functions = {},
		}

		local ToggleOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(0, 2, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Theme = { BackgroundColor3 = "Border 1" },
			Parent = Holder,
		})
		local ToggleMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Option Background" },
			Parent = ToggleOutline,
		})
		local ToggleInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Border 1" },
			Parent = ToggleMiddle,
		})
		local ToggleFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Option Background" },
			Parent = ToggleInline,
		})
		local ToggleLabel = Functions["Create"]("TextLabel", {
			Parent = ToggleOutline,
			Text = Options.Text,
			Theme = { TextColor3 = Options.Dangerous and "Warning Text" or "Active Text" },
			Position = UDim2.new(1, 2, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})
		local ToggleLabelStroke = Functions["Create"]("UIStroke", {
			Parent = ToggleLabel,
		})

		local Addons = {}

		function Toggle.Functions:Refresh()
			local Offset = 0
			for Index, Addon in next, Addons do
				Offset = Offset - 2 - (Index == 1 and 0 or Addon.Objects.Main.Size.X.Offset + 2)
				Addon.Objects.Main.Position = UDim2.new(1, Offset, 0.5, 0)
			end
		end

		function Toggle.Functions:Set(Bool)
			Toggle.Value = Bool
			Functions["UpdateThemeRegistery"](
				ToggleMiddle,
				{ BackgroundColor3 = Bool and "Accent" or "Option Background" }
			)
			Functions["UpdateThemeRegistery"](
				ToggleFill,
				{ BackgroundColor3 = Bool and "Accent" or "Option Background" }
			)
			if Options.Callback then
				task.spawn(Options.Callback, Bool)
			end
		end

		function Toggle.Functions:Get()
			return { Value = Toggle.Value }
		end

		function Toggle.Functions:Callback(Function)
			Options.Callback = Function
		end

		function Toggle.Functions:Keybind(KeybindOptions)
			local Keybind = Components["Keybind"](Holder, Toggle, KeybindOptions)
			table.insert(Addons, Keybind)
			self:Refresh()
			return Toggle
		end

		function Toggle.Functions:Colorpicker(ColorpickerOptions)
			local Colorpicker = Components["Colorpicker"](Holder, Toggle, ColorpickerOptions)
			table.insert(Addons, Colorpicker)
			self:Refresh()
			return Toggle
		end

		Functions["AddConnection"](nil, ToggleOutline.MouseButton1Down, function()
			Toggle.Functions:Set(not Toggle.Value)
		end)

		Toggle.Functions:Set(Toggle.Value)

		if Options.Flag then
			Library.Flags["Toggle"][Options.Flag] = Toggle
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
			Format = "${CURRENT}/${MAXIMUM}",
		}

		local Slider = {
			Current = Options.Current,
			Functions = {},
		}

		local SliderOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			Theme = { BackgroundColor3 = "Border 1" },
			Parent = Holder,
		})

		local SliderMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Option Background" },
			Parent = SliderOutline,
		})

		local SliderInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Border 1" },
			Parent = SliderMiddle,
		})

		local SliderFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Option Background" },
			Parent = SliderInline,
		})

		local SliderAccent = Functions["Create"]("Frame", {
			Size = UDim2.new(0.5, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Theme = { BackgroundColor3 = "Accent" },
			Parent = SliderFill,
		})

		local SliderTextLabel = Functions["Create"]("TextLabel", {
			Parent = SliderFill,
			Text = Options.Text,
			Theme = { TextColor3 = "Active Text" },
			Position = UDim2.new(0, 2, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})

		local SliderTextLabelStroke = Functions["Create"]("UIStroke", {
			Parent = SliderTextLabel,
		})

		local SliderAmountLabel = Functions["Create"]("TextLabel", {
			Parent = SliderFill,
			Text = Options.Text,
			Theme = { TextColor3 = "Active Text" },
			Position = UDim2.new(1, -2, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})

		local SliderAmountLabelStroke = Functions["Create"]("UIStroke", {
			Parent = SliderAmountLabel,
		})

		function Slider.Functions:Set(Number)
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

		function Slider.Functions:Get()
			return { Current = Slider.Current }
		end

		function Slider.Functions:Callback(Function)
			Options.Callback = Function
		end

		Functions["AddConnection"](nil, SliderOutline.MouseButton1Down, function()
			Functions["AddConnection"]("SliderMove", UserInputService.InputChanged, function(Input, Processed)
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					Slider.Functions:Set(
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

		Slider.Functions:Set(Slider.Current)
		if Options.Flag then
			Library.Flags["Slider"][Options.Flag] = Slider
		end

		return Slider
	end

	Components["Dropdown"] = function(Holder, Options)
		local Options = {
			Text = Options.Text or "DROPDOWN",
			Flag = Options.Flag,
			Callback = Options.Callback,
			Options = Options.Options or { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12" },
			Current = Options.Current or { "1", "2" },
			Minimum = Options.Minimum or 0,
			Maximum = Options.Maximum or math.huge,
		}

		local Dropdown = {
			Current = Options.Current,
			Functions = {},
		}

		local DropdownOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			Theme = { BackgroundColor3 = "Border 1" },
			Parent = Holder,
		})

		local DropdownMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Option Background" },
			Parent = DropdownOutline,
		})

		local DropdownInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Border 1" },
			Parent = DropdownMiddle,
		})

		local DropdownFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Option Background" },
			Parent = DropdownInline,
		})

		local DropdownSelectedLabel = Functions["Create"]("TextLabel", {
			Parent = DropdownFill,
			Theme = { TextColor3 = "Active Text" },
			Position = UDim2.new(1, -2, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})

		local DropdownSelectedLabelStroke = Functions["Create"]("UIStroke", {
			Parent = DropdownSelectedLabel,
		})

		local DropdownTextLabel = Functions["Create"]("TextLabel", {
			Parent = DropdownFill,
			Theme = { TextColor3 = "Active Text" },
			Position = UDim2.new(0, 2, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			Text = Options.Text,
			FontFace = CustomFont,
		})

		local DropdownTextLabelStroke = Functions["Create"]("UIStroke", {
			Parent = DropdownTextLabel,
		})

		local DropdownListOutline = Functions["Create"]("TextButton", {
			Theme = { BackgroundColor3 = "Border 1" },
			Size = UDim2.new(0, DropdownOutline.AbsoluteSize.X, 0, (#Options.Options * 19) + 5),
			Position = UDim2.new(0, 0, 0, 19),
			Parent = ComponentsGUI,
			Name = "DROPDOWN",
			Visible = false,
		})

		local DropdownListMiddle = Functions["Create"]("Frame", {
			Theme = { BackgroundColor3 = "Border 2" },
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = DropdownListOutline,
		})

		local DropdownListInline = Functions["Create"]("Frame", {
			Theme = { BackgroundColor3 = "Border 1" },
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = DropdownListMiddle,
		})

		local DropdownListFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Parent = DropdownListInline,
			BackgroundTransparency = 1,
		})

		local Objects = {}

		function Dropdown.Functions:Values(List)
			Options.Options = List

			for Index, Data in next, Objects do
				Data["Label"]:Destroy()
				Data["Frame"]:Destroy()
				Functions["RemoveConnection"](Data["Connection"])
			end

			for Index, Value in next, Options.Options do
				local DropdownFrame = Functions["Create"]("TextButton", {
					Size = UDim2.new(1, -2, 0, 18),
					Position = UDim2.new(0, 1, 0, 1 + ((Index - 1) * 19)),
					Theme = { BackgroundColor3 = "Option Background" },
					Parent = DropdownListFill,
				})

				local DropdownLabel = Functions["Create"]("TextLabel", {
					Parent = DropdownFrame,
					Text = "  " .. Value,
					Theme = { TextColor3 = "Active Text", BackgroundColor3 = "Option Background" },
					Position = UDim2.new(0, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextSize = 12,
					Size = UDim2.new(1, 0, 0, 0),
					FontFace = CustomFont,
				})

				local DropdownLabelStroke = Functions["Create"]("UIStroke", {
					Parent = DropdownLabel,
				})

				Objects[Value] = {}
				Objects[Value]["Frame"] = DropdownFrame
				Objects[Value]["Label"] = DropdownLabel
				Objects[Value]["Connection"] = Functions["AddConnection"](
					nil,
					DropdownFrame.MouseButton1Down,
					function()
						if table.find(Dropdown.Current, Value) then
							if #Dropdown.Current > Options.Minimum then
								local Table = Dropdown.Current
								table.remove(Table, table.find(Table, Value))
								self:Set(Table)
							end
						else
							if Options.Maximum == 1 then
								self:Set({ Value })
							elseif #Dropdown.Current < Options.Maximum then
								local Table = Dropdown.Current
								Table[#Table + 1] = Value
								self:Set(Table)
							end
						end
					end
				)
			end

			DropdownListOutline.Size = UDim2.new(0, DropdownOutline.AbsoluteSize.X, 0, (#Options.Options * 19) + 5)
		end

		function Dropdown.Functions:Set(List)
			Dropdown.Current = List

			local FullText = table.concat(Dropdown.Current, ", ")
			DropdownSelectedLabel.Text = (#FullText > 14)
					and (string.sub(
						FullText,
						1,
						string.find(string.reverse(string.sub(FullText, 1, 14)), ",")
								and (14 - string.find(string.reverse(string.sub(FullText, 1, 14)), ","))
							or 14
					) .. ", ...")
				or FullText

			for Index, Object in next, Objects do
				if table.find(Dropdown.Current, Index) then
					Functions["UpdateThemeRegistery"](Object["Label"], { TextColor3 = "Accent" })
				else
					Functions["UpdateThemeRegistery"](Object["Label"], { TextColor3 = "Inactive Text" })
				end
			end

			if Options.Callback then
				task.spawn(Options.Callback, List)
			end
		end

		function Dropdown.Functions:Get()
			return { Current = Dropdown.Current }
		end

		function Dropdown.Functions:Callback(Function)
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
			if not DropdownListOutline.Visible then
				return
			end
			if Try == 0 and Input.UserInputType == Enum.UserInputType.MouseButton1 then
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
			if Input.UserInputType ~= Enum.UserInputType.MouseWheel then
				return
			end

			DropdownListOutline.Visible = false
		end)

		Functions["AddConnection"](nil, DropdownOutline.MouseButton1Down, function()
			if #Options.Options <= 0 then
				return
			end

			DropdownListOutline.Visible = not DropdownListOutline.Visible
			local AbsolutePosition = DropdownOutline.AbsolutePosition + GuiService:GetGuiInset()
			DropdownListOutline.Position = UDim2.new(0, AbsolutePosition.X, 0, AbsolutePosition.Y + 22)
			Try = 0
		end)

		Dropdown.Functions:Values(Options.Options)
		Dropdown.Functions:Set(Dropdown.Current)
		if Options.Flag then
			Library.Flags["Dropdown"][Options.Flag] = Dropdown
		end

		return Dropdown
	end

	Components["Button"] = function(Holder, Options)
		local Options = {
			Text = Options.Text or "BUTTON",
			Result = Options.Result or "PRESSED",
			Callback = Options.Callback,
		}

		local Button = {
			Functions = {},
		}

		local Buttons = #Holder:GetChildren() + 1
		local ButtonOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 0),
			Theme = { BackgroundColor3 = "Border 1" },
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
			Theme = { BackgroundColor3 = "Option Background" },
			Parent = ButtonOutline,
		})

		local ButtonInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Border 1" },
			Parent = ButtonMiddle,
		})

		local ButtonFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Option Background" },
			Parent = ButtonInline,
		})

		local ButtonTextLabel = Functions["Create"]("TextLabel", {
			Parent = ButtonFill,
			Text = Options.Text,
			Theme = { TextColor3 = "Active Text", BackgroundColor3 = "Option Background" },
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})

		local ButtonTextLabelStroke = Functions["Create"]("UIStroke", {
			Parent = ButtonTextLabel,
		})

		local State = nil

		Functions["AddConnection"](nil, ButtonOutline.MouseButton1Down, function()
			if State == "PRESSED" then
				return
			end

			if State ~= nil then
				if Options.Callback then
					task.spawn(Options.Callback)
				end

				State = "PRESSED"
				ButtonTextLabel.Text = Options.Result
				Functions["UpdateThemeRegistery"](
					ButtonTextLabel,
					{ TextColor3 = "Accent", BackgroundColor3 = "Option Background" }
				)

				task.spawn(function()
					task.wait(1)
					ButtonTextLabel.Text = Options.Text
					Functions["UpdateThemeRegistery"](
						ButtonTextLabel,
						{ TextColor3 = "Active Text", BackgroundColor3 = "Option Background" }
					)
					State = nil
				end)
			else
				State = tick()
				Functions["UpdateThemeRegistery"](
					ButtonTextLabel,
					{ TextColor3 = "Accent", BackgroundColor3 = "Option Background" }
				)

				task.spawn(function()
					for i = 1, 200 do
						if not State or State == "PRESSED" then
							break
						end

						if #Holder:GetChildren() > 1 then
							ButtonTextLabel.Text = "PROCEED?"
						else
							ButtonTextLabel.Text = "PROCEED? " .. "[" .. string.format("%.2f", 2 - (i * 0.01)) .. "s]"
						end
						task.wait(0.01)
					end

					if State and State ~= "PRESSED" then
						ButtonTextLabel.Text = Options.Text
						Functions["UpdateThemeRegistery"](
							ButtonTextLabel,
							{ TextColor3 = "Active Text", BackgroundColor3 = "Option Background" }
						)
						State = nil
					end
				end)
			end
		end)

		function Button.Functions:Button(Data)
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
			Functions = {},
		}

		local TextBoxOutline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			Theme = { BackgroundColor3 = "Border 1" },
			Parent = Holder,
		})

		local TextBoxMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Option Background" },
			Parent = TextBoxOutline,
		})

		local TextBoxInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Border 1" },
			Parent = TextBoxMiddle,
		})

		local TextBoxFill = Functions["Create"]("TextBox", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Option Background", TextColor3 = "Active Text" },
			TextScaled = true,
			PlaceholderText = Options.Placeholder,
			Text = Options.Text,
			Parent = TextBoxInline,
			FontFace = CustomFont,
		})

		function TextBox.Functions:Set(Text)
			TextBox.Text = Text
			TextBoxFill.Text = Text

			if Options.Callback then
				task.spawn(Options.Callback, Text)
			end
		end

		function TextBox.Functions:Get()
			return { Text = TextBox.Text }
		end

		function TextBox.Functions:Callback(Function)
			Options.Callback = Function
		end

		Functions["AddConnection"](nil, TextBoxFill.FocusLost, function(Pressed)
			if not Pressed then
				return TextBox.Functions:Set("")
			end

			TextBox.Functions:Set(TextBoxFill.Text)
		end)

		if Options.Flag then
			Library.Flags["TextBox"][Options.Flag] = TextBox
		end

		TextBox.Functions:Set(TextBox.Text)

		return TextBox
	end

	Components["Label"] = function(Holder, Options)
		local Options = {
			Text = Options.Text or "LABEL",
			Side = Options.Side or "LEFT",
		}

		local Label = {
			Functions = {},
		}

		local LabelTextLabel = Functions["Create"]("TextLabel", {
			Parent = Holder,
			Text = Options.Text,
			Theme = { TextColor3 = "Active Text" },
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			TextXAlignment = Options.Side == "LEFT" and Enum.TextXAlignment.Left
				or Options.Side == "RIGHT" and Enum.TextXAlignment.Right
				or Options.Side == "CENTER" and Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})

		local LabelTextLabelStroke = Functions["Create"]("UIStroke", {
			Parent = LabelTextLabel,
		})

		local Addons = {}
		function Label.Functions:Refresh()
			local Offset = 0
			for Index, Addon in next, Addons do
				Offset = Offset - (Index == 1 and 0 or Addon.Objects.Main.Size.X.Offset + 2)
				Addon.Objects.Main.Position = UDim2.new(1, Offset, 0.5, 0)
			end
		end

		function Label.Functions:Colorpicker(ColorpickerOptions)
			local Colorpicker = Components["Colorpicker"](Holder, Label, ColorpickerOptions)
			table.insert(Addons, Colorpicker)

			self:Refresh()

			return Label
		end

		return Label
	end

	Components["Keybind"] = function(Holder, Parent, Options)
		local Options = {
			Text = Options.Text or "KEY",
			Side = Options.Side or "LEFT",
			Flag = Options.Flag,
			Callback = Options.Callback,
			Input = Options.Input or Enum.KeyCode.E,
			Mode = Options.Mode or "TOGGLE",
		}

		local Keybind = {
			Text = Options.Text,
			Input = Options.Input,
			Mode = Options.Mode,
			Objects = {},
			Functions = {},
		}

		local KeybindOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(0, 22, 0, 16),
			AnchorPoint = Vector2.new(1, 0.5),
			Theme = { BackgroundColor3 = "Border 1" },
			Parent = Holder,
		})
		local KeybindMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Option Background" },
			Parent = KeybindOutline,
		})
		local KeybindInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Border 1" },
			Parent = KeybindMiddle,
		})
		local KeybindFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Option Background" },
			Parent = KeybindInline,
		})
		local KeybindLabel = Functions["Create"]("TextLabel", {
			Parent = KeybindFill,
			Text = UserInputService:GetStringForKeyCode(Keybind.Input) or "UNKNOWN",
			Theme = { TextColor3 = "Active Text" },
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})
		local KeybindLabelStroke = Functions["Create"]("UIStroke", {
			Parent = KeybindLabel,
		})
		local KeybindModeListOutline = Functions["Create"]("TextButton", {
			Theme = { BackgroundColor3 = "Border 1" },
			Size = UDim2.new(0, 100, 0, (2 * 19) + 5),
			Position = UDim2.new(1, 2, 0, 0),
			Parent = ComponentsGUI,
			Visible = false,
		})
		local KeybindModeListMiddle = Functions["Create"]("Frame", {
			Theme = { BackgroundColor3 = "Border 2" },
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = KeybindModeListOutline,
		})
		local KeybindModeListInline = Functions["Create"]("Frame", {
			Theme = { BackgroundColor3 = "Border 1" },
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = KeybindModeListMiddle,
		})
		local KeybindModeListFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Parent = KeybindModeListInline,
			BackgroundTransparency = 1,
		})

		local DisplayKeybind = Library.Keybinds.Functions:Add({ Index = "EMPTY", Key = "EMPTY" })
		Keybind.Objects.Main = KeybindOutline

		local Labels = {}
		for Index, Value in next, { "HOLD", "TOGGLE" } do
			local ModeFrame = Functions["Create"]("TextButton", {
				Size = UDim2.new(1, -6, 0, 18),
				Position = UDim2.new(0, 1, 0, 1 + ((Index - 1) * 19)),
				Theme = { BackgroundColor3 = "Option Background" },
				Parent = KeybindModeListFill,
			})
			local ModeLabel = Functions["Create"]("TextLabel", {
				Parent = ModeFrame,
				Text = Value,
				Theme = {
					TextColor3 = Keybind.Mode == Value and "Accent" or "Inactive Text",
					BackgroundColor3 = "Option Background",
				},
				Position = UDim2.new(0, 4, 0, 0),
				AnchorPoint = Vector2.new(0, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextSize = 12,
				Size = UDim2.new(1, 0, 1, 0),
				FontFace = CustomFont,
			})
			local ModeLabelStroke = Functions["Create"]("UIStroke", {
				Parent = ModeLabel,
			})
			Labels[Value] = ModeLabel
			Functions["AddConnection"](nil, ModeFrame.MouseButton1Down, function()
				Keybind.Functions:Set(Keybind.Input, Value)
			end)
		end

		function Keybind.Functions:Set(Input, Mode)
			local Display = (Input.Name == "Unknown" or Input.Name == "Delete") and "-"
				or UserInputService:GetStringForKeyCode(Input)
			KeybindLabel.Text = Display
			Keybind.Input = Input
			Keybind.Mode = Mode
			if Display == "-" then
				DisplayKeybind.Functions:SetVisible(false)
			else
				DisplayKeybind.Functions:SetVisible(true)
			end
			DisplayKeybind.Functions:SetIndex(Keybind.Text)
			DisplayKeybind.Functions:SetValue(Display)
			for Index, Object in next, Labels do
				Functions["UpdateThemeRegistery"](
					Object,
					{ TextColor3 = Keybind.Mode == Index and "Accent" or "Inactive Text" }
				)
			end
		end

		function Keybind.Functions:Get()
			return { Input = Keybind.Input, Mode = Keybind.Mode }
		end

		function Keybind.Functions:Callback(Function)
			Options.Callback = Function
		end

		local Try = 0
		Functions["AddConnection"](nil, KeybindOutline.MouseButton2Down, function()
			KeybindModeListOutline.Visible = not KeybindModeListOutline.Visible
			local AbsolutePosition = KeybindOutline.AbsolutePosition + GuiService:GetGuiInset()
			KeybindModeListOutline.Position = UDim2.new(0, AbsolutePosition.X + 25, 0, AbsolutePosition.Y + 1)
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
			if Try == 0 and Input.UserInputType == Enum.UserInputType.MouseButton2 then
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
				KeybindModeListOutline.Visible = false
			end
		end)

		Functions["AddConnection"](nil, UserInputService.InputChanged, function(Input)
			if Input.UserInputType ~= Enum.UserInputType.MouseWheel then
				return
			end
			KeybindModeListOutline.Visible = false
		end)

		local Debounce = false
		Functions["AddConnection"](nil, KeybindOutline.MouseButton1Down, function()
			if Debounce then
				return
			end
			Debounce = true
			KeybindLabel.Text = "..."
			local Index
			Index = Functions["AddConnection"](nil, UserInputService.InputBegan, function(Input, Processed)
				Debounce = false
				if
					UserInputService:GetStringForKeyCode(Input.KeyCode) == ""
					and Input.KeyCode ~= Enum.KeyCode.Delete
				then
					return
				end
				if Input.KeyCode == Enum.KeyCode.Delete then
					Keybind.Functions:Set(Enum.KeyCode.Unknown, Keybind.Mode)
				elseif Input.KeyCode ~= Enum.KeyCode.Unknown then
					Keybind.Functions:Set(Input.KeyCode, Keybind.Mode)
				end
				Functions["RemoveConnection"](Index)
			end)
		end)

		Functions["AddConnection"](nil, UserInputService.InputBegan, function(Input, Processed)
			if Processed then
				return
			end
			if Input.KeyCode == Enum.KeyCode.Delete then
				return
			end
			if Input.KeyCode == Keybind.Input or Input.UserInputType == Keybind.Input then
				if Keybind.Mode == "TOGGLE" then
					local NEW = not Parent.Value
					Parent["Functions"]["Set"](NEW)
					DisplayKeybind.Functions:SetTheme({ TextColor3 = NEW and "Accent" or "Inactive Text" })
				elseif Keybind.Mode == "HOLD" then
					Parent["Functions"]["Set"](true)
					DisplayKeybind.Functions:SetTheme({ TextColor3 = "Accent" })
				end
			end
		end)

		Functions["AddConnection"](nil, UserInputService.InputEnded, function(Input, Processed)
			if Input.KeyCode == Enum.KeyCode.Delete then
				return
			end
			if Input.KeyCode == Keybind.Input or Input.UserInputType == Keybind.Input then
				if Keybind.Mode == "HOLD" then
					Parent["Functions"]["Set"](false)
					DisplayKeybind.Functions:SetTheme({ TextColor3 = "Inactive Text" })
				end
			end
		end)

		Keybind.Functions:Set(Keybind.Input, Keybind.Mode)

		if Options.Flag then
			Library.Flags["Keybind"][Options.Flag] = Keybind
		end

		return Keybind
	end

	local Pickers = {}
	local Copied = Color3.new()
	Functions["AddConnection"](nil, RunService.Heartbeat, function()
		for Colorpicker, Mode in next, Pickers do
			if Mode == "RAINBOW" then
				Colorpicker.Functions:Set(Color3.fromHSV((tick() % 5) / 5, 1, 1), Colorpicker.Current[4])
			end
		end
	end)

	Components["Colorpicker"] = function(Holder, Parent, Options)
		local Options = {
			Color = Options.Color or Color3.new(0, 1, 1),
			Alpha = Options.Alpha,
			Flag = Options.Flag,
			Callback = Options.Callback,
		}

		local HH, SS, VV = Options.Color:ToHSV()
		local Colorpicker = {
			Current = { HH, SS, VV, Options.Alpha },
			Mode = "NONE",
			Objects = {},
			Functions = {},
		}

		local ColorpickerOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(0, 22, 0, 16),
			AnchorPoint = Vector2.new(1, 0.5),
			Theme = { BackgroundColor3 = "Border 1" },
			Parent = Holder,
		})
		local ColorpickerMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Option Background" },
			Parent = ColorpickerOutline,
		})
		local ColorpickerInline = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Border 1" },
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
			Theme = { BackgroundColor3 = "Border 1" },
			Size = UDim2.new(0, Colorpicker.Current[4] and 150 or 131, 0, 170),
			Position = UDim2.new(0, 0, 0, 0),
			Parent = ComponentsGUI,
			Visible = false,
			Name = "COLORPICKER",
		})
		local ColorpickerDropdownFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Parent = ColorpickerDropdownOutline,
			Theme = { BackgroundColor3 = "Option Background" },
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
			Size = UDim2.new(0, Colorpicker.Current[4] and 116 or 112, 1, 0),
			Theme = { BackgroundColor3 = "Border 1" },
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
			Image = Functions["CustomAsset"]("Fondra/Assets/Images/Saturation One.png"),
		})
		local ColorpickerColorBoxSaturationTwo = Functions["Create"]("ImageLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			Parent = ColorpickerColorBoxFill,
			BackgroundTransparency = 1,
			Image = Functions["CustomAsset"]("Fondra/Assets/Images/Saturation Two.png"),
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
		local ColorpickerButtonsHolder = Functions["Create"]("Frame", {
			Parent = ColorpickerActionsHolder,
			Size = UDim2.new(1, 0, 0.5, 0),
			BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
			Transparency = Library.Debug and 0 or 1,
		})
		local Component = Components["Button"](ColorpickerButtonsHolder, {
			Text = "COPY",
			Result = "COPIED",
			Callback = function()
				local H, S, V, Alpha = unpack(Colorpicker.Current)
				Copied = { H, S, V, Alpha }
			end,
		}).Functions
			:Button({
				Text = "PASTE",
				Result = "PASTED",
				Callback = function()
					local H, S, V, Alpha = unpack(Copied)
					Colorpicker.Functions:Set(Color3.fromHSV(H, S, V), Alpha and Alpha or Colorpicker.Current[4])
				end,
			})
		local ColorpickerDropdownHolder = Functions["Create"]("Frame", {
			Parent = ColorpickerActionsHolder,
			Size = UDim2.new(1, 0, 0.5, -1),
			BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
			Transparency = Library.Debug and 0 or 1,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
		})
		local Component = Components["Dropdown"](ColorpickerDropdownHolder, {
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
					local H = Colorpicker.Current[1]
					Colorpicker.Functions:Set(Color3.fromHSV(H, S, V))
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
			Theme = { BackgroundColor3 = "Border 1" },
			Parent = ColorpickerMainHolder,
		})
		local ColorpickerHueMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Option Background" },
			Parent = ColorpickerHueOutline,
		})
		local ColorpickerHueInline = Functions["Create"]("ImageButton", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Border 1" },
			Image = Functions["CustomAsset"]("Fondra/Assets/Images/Hue.png"),
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
					local S, V = Colorpicker.Current[2], Colorpicker.Current[3]
					Colorpicker.Functions:Set(Color3.fromHSV(H, S, V))
				end
			end)
			Functions["AddConnection"]("HueEnd", UserInputService.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Functions["RemoveConnection"]("HueMove")
					Functions["RemoveConnection"]("HueEnd")
				end
			end)
		end)

		if Colorpicker.Current[4] then
			local ColorpickerAlphaOutline = Functions["Create"]("Frame", {
				Size = UDim2.new(0, 14, 1, 0),
				Theme = { BackgroundColor3 = "Border 1" },
				Parent = ColorpickerMainHolder,
			})
			local ColorpickerAlphaMiddle = Functions["Create"]("Frame", {
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Theme = { BackgroundColor3 = "Option Background" },
				Parent = ColorpickerAlphaOutline,
			})
			local ColorpickerAlphaInline = Functions["Create"]("ImageButton", {
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Theme = { BackgroundColor3 = "Border 1" },
				Parent = ColorpickerAlphaMiddle,
				Image = Functions["CustomAsset"]("Fondra/Assets/Images/Alpha.png"),
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
						local H, S, V = unpack(Colorpicker.Current)
						Colorpicker.Functions:Set(Color3.fromHSV(H, S, V), AlphaValue)
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
		end

		function Colorpicker.Functions:Set(NewColor, Alpha, Mode)
			local H, S, V = Color3.toHSV(NewColor)
			if Colorpicker.Current[4] ~= nil then
				Alpha = Alpha or Colorpicker.Current[4]
				Colorpicker.Current = { H, S, V, Alpha }
			else
				Colorpicker.Current = { H, S, V }
			end
			ColorpickerFill.BackgroundColor3 = Color3.fromHSV(H, S, V)
			if Colorpicker.Current[4] ~= nil then
				ColorpickerFill.BackgroundTransparency = 1 - Colorpicker.Current[4]
				if Colorpicker.Objects.AlphaCursor and Colorpicker.Objects.AlphaInline then
					Colorpicker.Objects.AlphaCursor.Position =
						UDim2.new(0, 2, 0, (1 - Colorpicker.Current[4]) * Colorpicker.Objects.AlphaInline.AbsoluteSize.Y)
					Colorpicker.Objects.AlphaInline.BackgroundColor3 = Color3.fromHSV(H, S, V)
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
				task.spawn(Options.Callback, Colorpicker.Current)
			end
		end

		function Colorpicker.Functions:Get()
			return { Current = Colorpicker.Current, Mode = Colorpicker.Mode }
		end

		function Colorpicker.Functions:Callback(Function)
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
				local A = 0
				-- Dumbest most garbage working fix.
				for i, v in next, ComponentsGUI:GetChildren() do
					if not v.Visible then
						continue
					end
					if v == ColorpickerDropdownOutline then
						continue
					end
					if v.Name ~= "DROPDOWN" and v.Name ~= "COLORPICKER" then
						continue
					end
					A += 1
				end
				if A >= 1 then
					return
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
			ColorpickerDropdownOutline.Visible = not ColorpickerDropdownOutline.Visible
			local AbsolutePosition = ColorpickerOutline.AbsolutePosition + GuiService:GetGuiInset()
			ColorpickerDropdownOutline.Position = UDim2.new(0, AbsolutePosition.X + 25, 0, AbsolutePosition.Y + 1)
			Try = 0
		end)

		Colorpicker.Functions:Set(Color3.fromHSV(HH, SS, VV), Colorpicker.Current[4], Colorpicker.Mode)

		if Options.Flag then
			Library.Flags["Colorpicker"][Options.Flag] = Colorpicker
		end

		return Colorpicker
	end
end
Library.Components = Components

do
	local Count = 0
	local Temp = 0
	Functions["AddConnection"]("Statistics", RunService.RenderStepped, function()
		Count += 1

		Library.Stats.FPS = (((tick() - Temp) > 1) and Count)
			or (Library.Stats.FPS and (Library.Stats.FPS > 0) and Library.Stats.FPS)
			or 0
		Library.Stats.Ping = Stats.Network:FindFirstChild("ServerStatsItem")
				and tostring(math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()))
			or "???"
		Library.Stats.Mode = "OFFLINE"

		if (tick() - Temp) > 1 then
			Count = 0
			Temp = tick()
		end
	end)
end

do
	Library["Notification"] = function(String, Duration, Color)
		local Notification = {}

		table.insert(Library.Notifications, Notification)

		local Bounds = Functions["GetTextBounds"](String, 12, CustomFont)
		local NotificationOutline = Functions["Create"]("Frame", {
			Parent = NotificationsGUI,
			Size = UDim2.new(0, Bounds.X + 14, 0, 24),
			Position = UDim2.new(0, 10, 0, 100 + (table.find(Library.Notifications, Notification) * 25)),
			Theme = { BackgroundColor3 = "Border 1" },
		})

		local NotificationInLine = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Theme = { BackgroundColor3 = "Border 3" },
			Parent = NotificationOutline,
		})

		local NotificationFill = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			Theme = { BackgroundColor3 = "Background 1" },
			Parent = NotificationInLine,
		})

		local NotificationAccent = Functions["Create"]("Frame", {
			Size = UDim2.new(0, 1, 1, -4),
			Position = UDim2.new(0, 2, 0, 2),
			Theme = { BackgroundColor3 = Color },
			Parent = NotificationOutline,
		})

		local NotificationTime = Functions["Create"]("Frame", {
			Size = UDim2.new(0, 0, 0, 1),
			Position = UDim2.new(0, 2, 1, -3),
			Theme = { BackgroundColor3 = Color },
			Parent = NotificationOutline,
		})

		local NotificationTitle = Functions["Create"]("TextLabel", {
			Parent = NotificationFill,
			Text = String,
			Theme = { TextColor3 = "Active Text" },
			Position = UDim2.new(0, 5, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 12,
			FontFace = CustomFont,
		})

		local NotificationTitleStroke = Functions["Create"]("UIStroke", {
			Parent = NotificationTitle,
		})

		Notification["NotificationOutline"] = NotificationOutline
		Notification["NotificationInLine"] = NotificationInLine
		Notification["NotificationFill"] = NotificationFill
		Notification["NotificationAccent"] = NotificationAccent
		Notification["NotificationTime"] = NotificationTime
		Notification["NotificationTitle"] = NotificationTitle

		TweenService:Create(NotificationTime, TweenInfo.new(Duration), { Size = UDim2.new(1, -4, 0, 1) }):Play()

		task.delay(Duration + 0.15, function()
			table.remove(Library.Notifications, table.find(Library.Notifications, Notification))

			TweenService:Create(NotificationOutline, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(NotificationInLine, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(NotificationFill, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(NotificationAccent, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(NotificationTime, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
			TweenService:Create(NotificationTitle, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
			TweenService:Create(NotificationTitleStroke, TweenInfo.new(0.25), { Transparency = 1 }):Play()

			task.wait(0.25)

			for Index, Object in next, Library.Notifications do
				Object["NotificationOutline"].Position = UDim2.new(0, 10, 0, 100 + (Index * 25))
			end

			NotificationOutline:Destroy()
			NotificationInLine:Destroy()
			NotificationFill:Destroy()
			NotificationAccent:Destroy()
			NotificationTime:Destroy()
			NotificationTitle:Destroy()
			NotificationTitleStroke:Destroy()
		end)

		return Notification
	end

	Library["Indicator"] = function(Properties)
		local Indicator = {
			Title = Properties.Title or "INDICATOR",
			Position = Properties.Position or UDim2.new(0, 15, 0, 300),
			Visible = Properties.Visible or true,

			Values = {},
			Functions = {},
		}

		local IndicatorOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(0, 206, 0, 300),
			Position = Indicator.Position,
			AnchorPoint = Vector2.new(0, 0),
			Theme = { BackgroundColor3 = "Border 1" },
			Visible = true,
			Parent = MainGUI,
		})

		local IndicatorTopOutline = Functions["Create"]("Frame", {
			Parent = IndicatorOutline,
			Size = UDim2.new(1, -2, 0, 21),
			Position = UDim2.new(0, 1, 0, 1),
			AnchorPoint = Vector2.new(0, 0),
			Theme = { BackgroundColor3 = "Border 2" },
		})

		local IndicatorTopFill = Functions["Create"]("Frame", {
			Parent = IndicatorTopOutline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			AnchorPoint = Vector2.new(0, 0),
			Theme = { BackgroundColor3 = "Background 1" },
		})

		local IndicatorTopAccent = Functions["Create"]("Frame", {
			Parent = IndicatorTopFill,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Theme = { BackgroundColor3 = "Accent" },
		})

		local IndicatorMainOutline = Functions["Create"]("Frame", {
			Parent = IndicatorOutline,
			Size = UDim2.new(1, -2, 1, -22),
			Position = UDim2.new(0, 1, 0, 21),
			AnchorPoint = Vector2.new(0, 0),
			Theme = { BackgroundColor3 = "Border 2" },
		})

		local IndicatorMainFill = Functions["Create"]("Frame", {
			Parent = IndicatorMainOutline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			AnchorPoint = Vector2.new(0, 0),
			Theme = { BackgroundColor3 = "Background 1" },
		})

		local IndicatorMainFillLayout = Functions["Create"]("UIListLayout", {
			Parent = IndicatorMainFill,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 0),
		})

		local IndicatorLabel = Functions["Create"]("TextLabel", {
			Parent = IndicatorTopFill,
			Text = Indicator.Title,
			Theme = { TextColor3 = "Active Text" },
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextSize = 14,
			FontFace = CustomFont,
		})

		local IndicatorLabelStroke = Functions["Create"]("UIStroke", {
			Parent = IndicatorLabel,
		})

		local DragFrame = Functions["Create"]("Frame", {
			Parent = MainGUI,
			Size = IndicatorOutline.Size,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Transparency = 1,
		})

		local DragStroke = Functions["Create"]("UIStroke", {
			Parent = DragFrame,
			Color = Color3.fromRGB(255, 255, 255),
			Transparency = 1,
		})

		Functions["AddConnection"]("IndicatorDragStart", IndicatorOutline.MouseButton1Down, function()
			for i, v in next, ComponentsGUI:GetChildren() do
				if v.Visible then
					return
				end
			end

			if not Indicator.Visible then
				return
			end

			local Offset = Vector2.new(
				Mouse.X - IndicatorOutline.AbsolutePosition.X,
				Mouse.Y - IndicatorOutline.AbsolutePosition.Y
			)

			DragFrame.Position = IndicatorOutline.Position
			DragFrame.AnchorPoint = IndicatorOutline.AnchorPoint
			DragFrame.Size = IndicatorOutline.Size

			local TweenFrame = TweenService:Create(
				DragFrame,
				TweenInfo.new(0.25, Enum.EasingStyle.Quad),
				{ BackgroundTransparency = 0.7 }
			)
			local TweenStroke =
				TweenService:Create(DragStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Transparency = 0 })
			TweenFrame:Play()
			TweenStroke:Play()

			Functions["AddConnection"]("IndicatorDragMove", UserInputService.InputChanged, function(Input, Processed)
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					local MousePosition = UserInputService:GetMouseLocation()
					local TargetX = MousePosition.X - Offset.X
					local TargetY = MousePosition.Y - Offset.Y

					local ViewportSize = Camera.ViewportSize
					local FrameSize = DragFrame.AbsoluteSize
					local AnchorPoint = DragFrame.AnchorPoint

					local MinX = FrameSize.X * AnchorPoint.X
					local MinY = FrameSize.Y * AnchorPoint.Y
					local MaxX = ViewportSize.X - FrameSize.X * (1 - AnchorPoint.X)
					local MaxY = ViewportSize.Y - FrameSize.Y * (1 - AnchorPoint.Y)

					TargetX = math.clamp(TargetX, MinX, MaxX)
					TargetY = math.clamp(TargetY, MinY, MaxY)

					DragFrame.Position = UDim2.new(0, TargetX, 0, TargetY)
				end
			end)

			Functions["AddConnection"]("IndicatorDragEnded", UserInputService.InputEnded, function(Input, Processed)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Functions["RemoveConnection"]("IndicatorDragEnded")
					Functions["RemoveConnection"]("IndicatorDragMove")

					local TweenFrame = TweenService:Create(
						DragFrame,
						TweenInfo.new(0.25, Enum.EasingStyle.Quad),
						{ BackgroundTransparency = 1 }
					)
					local TweenStroke = TweenService:Create(
						DragStroke,
						TweenInfo.new(0.25, Enum.EasingStyle.Quad),
						{ Transparency = 1 }
					)
					TweenFrame:Play()
					TweenStroke:Play()

					IndicatorOutline.Position = DragFrame.Position
				end
			end)
		end)

		local Transparencys = {}
		Indicator.Functions.Fade = function(Self, Bool, Duration)
			if not Duration then
				return Functions["Message"]("Duration Argument left blank.", "Error")
			end
			if Bool == nil then
				return Functions["Message"]("Bool Argument left blank.", "Error")
			end

			if typeof(Bool) ~= "boolean" then
				return Functions["Message"]("Bool Argument is not a boolean.", "Error")
			end
			if typeof(Duration) ~= "number" then
				return Functions["Message"]("Duration Argument is not a number.", "Error")
			end

			if Bool == Indicator.Visible then
				return
			end

			UserInputService.MouseIconEnabled = not Bool

			local Objects = IndicatorMainOutline:GetDescendants()
			table.insert(Objects, IndicatorMainOutline)

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

				if Data.Transparency and not Data.BackgroundTransparency and not Data.ImageTransparency then
					TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{ Transparency = Bool and Data.Transparency or 1 }
					):Play()
				end

				if Data.TextTransparency then
					TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{ TextTransparency = Bool and Data.TextTransparency or 1 }
					):Play()
				end

				if Data.BackgroundTransparency then
					TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{ BackgroundTransparency = Bool and Data.BackgroundTransparency or 1 }
					):Play()
				end

				if Data.ImageTransparency then
					TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{ ImageTransparency = Bool and Data.ImageTransparency or 1 }
					):Play()
				end
			end

			Indicator.Visible = Bool
		end

		Indicator.Functions.Resize = function(Self)
			local Visible = 0

			for Index, Object in next, IndicatorMainFill:GetChildren() do
				if not Object:IsA("Frame") then
					continue
				end
				if not Object.Visible then
					continue
				end

				Visible += 1
			end

			if Visible <= 0 then
				IndicatorOutline.Size = UDim2.new(0, 206, 0, 40)
			else
				IndicatorOutline.Size = UDim2.new(0, 206, 0, 24 + IndicatorMainFillLayout.AbsoluteContentSize.Y)
			end
		end

		Indicator.Functions.Add = function(Self, Data)
			local Object = {
				Index = Data.Index or "INDEX",
				Value = Data.Key or "VALUE",
				Theme = Data.Theme or { TextColor3 = "Inactive Text" },

				Objects = {},
				Functions = {},
			}

			local ObjectMain = Functions["Create"]("Frame", {
				Parent = IndicatorMainFill,
				Size = UDim2.new(1, 0, 0, 18),
				BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
				Transparency = Library.Debug and 0 or 1,
			})

			local ObjectIndexLabel = Functions["Create"]("TextLabel", {
				Parent = ObjectMain,
				Text = Object.Index,
				Theme = Object.Theme,
				Position = UDim2.new(0, 2, 0.5, 0),
				Size = UDim2.new(1, -2, 0, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextSize = 12,
				FontFace = CustomFont,
			})

			local ObjectIndexLabelStroke = Functions["Create"]("UIStroke", {
				Parent = ObjectIndexLabel,
			})

			local ObjectValueLabel = Functions["Create"]("TextLabel", {
				Parent = ObjectMain,
				Text = Object.Value,
				Theme = Object.Theme,
				Position = UDim2.new(1, -2, 0.5, 0),
				Size = UDim2.new(1, -2, 0, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextSize = 12,
				FontFace = CustomFont,
			})

			local ObjectValueLabelStroke = Functions["Create"]("UIStroke", {
				Parent = ObjectValueLabel,
			})

			Object.Objects.Main = ObjectMain
			Object.Objects.Index = ObjectIndexLabel
			Object.Objects.Value = ObjectValueLabel

			local Index = #Indicator.Values + 1
			Indicator.Values[Index] = Object
			Indicator.Functions:Resize()

			Object.Functions.SetVisible = function(Self, Bool)
				ObjectMain.Visible = Bool
				Indicator.Functions:Resize()
			end

			Object.Functions.SetIndex = function(Self, String)
				Object.Index = String
				ObjectIndexLabel.Text = String
			end

			Object.Functions.SetValue = function(Self, String)
				Object.Value = String
				ObjectValueLabel.Text = String
			end

			Object.Functions.SetTheme = function(Self, Data)
				Functions["UpdateThemeRegistery"](ObjectIndexLabel, Data)
				Functions["UpdateThemeRegistery"](ObjectValueLabel, Data)
			end

			Object.Functions.Remove = function()
				Indicator.Functions:Remove(Index)
			end

			return Object
		end

		Indicator.Functions.Remove = function(Self, Index)
			local Found = Indicator.Values[Index]

			for Index, Object in next, Found.Objects do
				Object:Destroy()
			end

			Indicator.Functions:Resize()
		end

		Indicator.Functions:Resize()

		return Indicator
	end

	Library.Keybinds = Library["Indicator"]({ Title = "KEYBINDS" })

	Library["Watermark"] = function(Properties)
		local Info = Properties or {}
		local Watermark = {
			Functions = {},
			Visible = true,
		}

		local Inset = GuiService:GetGuiInset()
		local WatermarkOutline = Functions["Create"]("TextButton", {
			Size = UDim2.new(0, 206, 0, 23),
			Position = UDim2.new(0, 10, 0, Inset.Y + 10),
			AnchorPoint = Vector2.new(0, 0),
			Theme = { BackgroundColor3 = "Border 1" },
			Visible = true,
			Parent = MainGUI,
		})

		local WatermarkMiddle = Functions["Create"]("Frame", {
			Parent = WatermarkOutline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			AnchorPoint = Vector2.new(0, 0),
			Theme = { BackgroundColor3 = "Accent" },
		})

		local WatermarkInline = Functions["Create"]("Frame", {
			Parent = WatermarkMiddle,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			AnchorPoint = Vector2.new(0, 0),
			Theme = { BackgroundColor3 = "Border 1" },
		})

		local WatermarkMain = Functions["Create"]("Frame", {
			Parent = WatermarkInline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			AnchorPoint = Vector2.new(0, 0),
			Theme = { BackgroundColor3 = "Background 1" },
		})

		local WatermarkLabel = Functions["Create"]("TextLabel", {
			Parent = WatermarkMain,
			Text = "??? | ??? | ??? | ???",
			Theme = { TextColor3 = "Active Text" },
			Position = UDim2.new(0, 5, 0, 2),
			AnchorPoint = Vector2.new(0, 0),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextSize = 12,
			FontFace = CustomFont,
		})

		local WatermarkLabelStroke = Functions["Create"]("UIStroke", {
			Parent = WatermarkLabel,
		})

		local DragFrame = Functions["Create"]("Frame", {
			Parent = MainGUI,
			Size = WatermarkOutline.Size,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			Transparency = 1,
		})

		local DragStroke = Functions["Create"]("UIStroke", {
			Parent = DragFrame,
			Color = Color3.fromRGB(255, 255, 255),
			Transparency = 1,
		})

		Functions["AddConnection"]("WatermarkDragStart", WatermarkOutline.MouseButton1Down, function()
			for i, v in next, ComponentsGUI:GetChildren() do
				if v.Visible then
					return
				end
			end

			if not Watermark.Visible then
				return
			end

			local Offset = Vector2.new(
				Mouse.X - WatermarkOutline.AbsolutePosition.X,
				Mouse.Y - WatermarkOutline.AbsolutePosition.Y
			)

			DragFrame.Position = WatermarkOutline.Position
			DragFrame.AnchorPoint = WatermarkOutline.AnchorPoint
			DragFrame.Size = WatermarkOutline.Size

			local TweenFrame = TweenService:Create(
				DragFrame,
				TweenInfo.new(0.25, Enum.EasingStyle.Quad),
				{ BackgroundTransparency = 0.7 }
			)
			local TweenStroke =
				TweenService:Create(DragStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Transparency = 0 })
			TweenFrame:Play()
			TweenStroke:Play()

			Functions["AddConnection"]("WatermarkDragMove", UserInputService.InputChanged, function(Input, Processed)
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					local MousePosition = UserInputService:GetMouseLocation()
					local TargetX = MousePosition.X - Offset.X
					local TargetY = MousePosition.Y - Offset.Y

					local ViewportSize = Camera.ViewportSize
					local FrameSize = DragFrame.AbsoluteSize
					local AnchorPoint = DragFrame.AnchorPoint

					local MinX = FrameSize.X * AnchorPoint.X
					local MinY = FrameSize.Y * AnchorPoint.Y
					local MaxX = ViewportSize.X - FrameSize.X * (1 - AnchorPoint.X)
					local MaxY = ViewportSize.Y - FrameSize.Y * (1 - AnchorPoint.Y)

					TargetX = math.clamp(TargetX, MinX, MaxX)
					TargetY = math.clamp(TargetY, MinY, MaxY)

					DragFrame.Position = UDim2.new(0, TargetX, 0, TargetY)
				end
			end)

			Functions["AddConnection"]("WatermarkDragEnded", UserInputService.InputEnded, function(Input, Processed)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Functions["RemoveConnection"]("WatermarkDragEnded")
					Functions["RemoveConnection"]("WatermarkDragMove")

					local TweenFrame = TweenService:Create(
						DragFrame,
						TweenInfo.new(0.25, Enum.EasingStyle.Quad),
						{ BackgroundTransparency = 1 }
					)
					local TweenStroke = TweenService:Create(
						DragStroke,
						TweenInfo.new(0.25, Enum.EasingStyle.Quad),
						{ Transparency = 1 }
					)
					TweenFrame:Play()
					TweenStroke:Play()

					WatermarkOutline.Position = DragFrame.Position
				end
			end)
		end)

		local Rate = 0
		Functions["AddConnection"]("Watermark", RunService.Heartbeat, function()
			if (tick() - Rate) < (60 / Info.Rate) then
				return
			end

			Rate = tick()
			WatermarkLabel.Text = Info.Format
				:gsub("${FPS}", Library.Stats.FPS or 0)
				:gsub("${PING}", Library.Stats.Ping or 0)
				:gsub("${MODE}", Library.Stats.Mode or "OFFLINE")
				:gsub("${TIME}", os.date("%X", os.time()))
				:gsub("${DATE}", os.date("%Y/%m/%d", os.time()))

			local Bounds = Functions["GetTextBounds"](WatermarkLabel.Text, 12, CustomFont)
			WatermarkOutline.Size = UDim2.new(0, Bounds.X + 15, 0, 22)
		end)

		local Transparencys = {}
		Watermark.Functions.Fade = function(Self, Bool, Duration)
			if not Duration then
				return Functions["Message"]("Duration Argument left blank.", "Error")
			end
			if Bool == nil then
				return Functions["Message"]("Bool Argument left blank.", "Error")
			end

			if typeof(Bool) ~= "boolean" then
				return Functions["Message"]("Bool Argument is not a boolean.", "Error")
			end
			if typeof(Duration) ~= "number" then
				return Functions["Message"]("Duration Argument is not a number.", "Error")
			end

			if Bool == Watermark.Visible then
				return
			end

			UserInputService.MouseIconEnabled = not Bool

			local Objects = WatermarkOutline:GetDescendants()
			table.insert(Objects, WatermarkOutline)

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

				if Data.Transparency and not Data.BackgroundTransparency and not Data.ImageTransparency then
					TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{ Transparency = Bool and Data.Transparency or 1 }
					):Play()
				end

				if Data.TextTransparency then
					TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{ TextTransparency = Bool and Data.TextTransparency or 1 }
					):Play()
				end

				if Data.BackgroundTransparency then
					TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{ BackgroundTransparency = Bool and Data.BackgroundTransparency or 1 }
					):Play()
				end

				if Data.ImageTransparency then
					TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{ ImageTransparency = Bool and Data.ImageTransparency or 1 }
					):Play()
				end
			end

			Watermark.Visible = Bool
		end

		Library.Watermark = Watermark
	end

	Library["Menu"] = function(Properties)
		local Menu = {
			Tabs = {},
			Functions = {},
			Visible = true,
		}

		getgenv().Flags = Library.Flags
		getgenv().Relations = Library.Relations

		local MainFrameOutline = Functions["Create"]("TextButton", {
			Size = Properties.Size,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Border 1" },

			Parent = MenuGUI,
		})

		local MainFrameMiddle = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Accent" },
			Parent = MainFrameOutline,
		})

		local MainFrameInner = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Border 1" },
			Parent = MainFrameMiddle,
		})

		local MainFrameHolder = Functions["Create"]("Frame", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Border 2" },
			Parent = MainFrameInner,
		})

		local Title = Functions["Create"]("TextLabel", {
			Parent = MainFrameHolder,
			Text = string.upper(Properties.Name),
			Theme = { TextColor3 = "Accent" },
			Position = UDim2.new(0.5, 0, 0.015, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			TextSize = 12,
			FontFace = CustomFont,
		})

		local TitleStroke = Functions["Create"]("UIStroke", {
			Parent = Title,
		})

		local InnerFrameOutline = Functions["Create"]("Frame", {
			Parent = MainFrameHolder,
			Size = UDim2.new(1, -12, 1, -26),
			Position = UDim2.new(0, 6, 0, 20),
			Theme = { BackgroundColor3 = "Border 1" },
		})

		local InnerFrameMiddle = Functions["Create"]("Frame", {
			Parent = InnerFrameOutline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Border 3" },
		})

		local InnerFrameInline = Functions["Create"]("Frame", {
			Parent = InnerFrameMiddle,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Background 1" },
		})

		local ListFrame = Functions["Create"]("Frame", {
			Parent = InnerFrameInline,
			Size = UDim2.new(1, -10, 1, -10),
			Position = UDim2.new(0, 5, 0, 5),
			Theme = { BackgroundColor3 = "Border 2" },
			Transparency = 1,
		})

		local TabFrameOutline = Functions["Create"]("Frame", {
			Parent = ListFrame,
			Size = UDim2.new(1, 0, 0.05, 1),
			Position = UDim2.new(0, 0, 0, 0),
			Theme = { BackgroundColor3 = "Border 1" },
		})

		local TabFrameInline = Functions["Create"]("Frame", {
			Parent = TabFrameOutline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Border 2" },
		})

		local TabFrameHolder = Functions["Create"]("Frame", {
			Parent = TabFrameInline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Background 1" },
		})

		local DataFrameOutline = Functions["Create"]("Frame", {
			Parent = ListFrame,
			Size = UDim2.new(1, 0, 0.94, 0),
			Position = UDim2.new(0, 0, 0.06, 0),
			Theme = { BackgroundColor3 = "Border 1" },
		})

		local DataFrameInline = Functions["Create"]("Frame", {
			Parent = DataFrameOutline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Border 2" },
		})

		local DataFrameHolder = Functions["Create"]("Frame", {
			Parent = DataFrameInline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Theme = { BackgroundColor3 = "Background 1" },
		})

		local ContainerLeft = Functions["Create"]("ScrollingFrame", {
			Size = UDim2.new(0.493, -8, 1, -16),
			Position = UDim2.new(0, 8, 0, 8),
			Parent = DataFrameHolder,
			ScrollBarThickness = 0,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Theme = { BackgroundColor3 = "Background 1" },
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
			Theme = { BackgroundColor3 = "Background 1" },
			ClipsDescendants = true,
		})

		local ContainerRightLayout = Functions["Create"]("UIListLayout", {
			Parent = ContainerRight,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 8),
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
			Theme = { ImageColor3 = "Border 1" },
			Image = Functions["CustomAsset"]("Fondra/Assets/Images/Cursor.png"),
		})

		local CursorFill = Functions["Create"]("ImageLabel", {
			Parent = CursorOutline,
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0, 1, 0, 1),
			BackgroundTransparency = 1,
			Theme = { ImageColor3 = "Accent" },
			Image = Functions["CustomAsset"]("Fondra/Assets/Images/Cursor.png"),
		})

		Functions["AddConnection"](nil, UserInputService.InputBegan, function(Input, Processed)
			if Processed then
				return
			end

			if Input.KeyCode == Enum.KeyCode.Home and Menu then
				Menu.Functions:Fade(not Menu.Visible, 0.3)
			end
		end)

		Functions["AddConnection"]("MouseMove", UserInputService.InputChanged, function(Input, Processed)
			if Input.UserInputType == Enum.UserInputType.MouseMovement then
				local MousePosition = UserInputService:GetMouseLocation()
				CursorOutline.Position = UDim2.new(0, MousePosition.X, 0, MousePosition.Y)
			end
		end)

		Functions["AddConnection"]("MenuDragStart", MainFrameOutline.MouseButton1Down, function()
			for i, v in next, ComponentsGUI:GetChildren() do
				if v.Visible then
					return
				end
			end

			if not MainFrameOutline.Visible then
				return
			end

			local Offset = Vector2.new(
				Mouse.X - MainFrameOutline.AbsolutePosition.X + (-MainFrameOutline.AbsoluteSize.X / 2),
				Mouse.Y - MainFrameOutline.AbsolutePosition.Y + (-MainFrameOutline.AbsoluteSize.Y / 2)
			)
			DragFrame.Position = MainFrameOutline.Position
			DragFrame.AnchorPoint = MainFrameOutline.AnchorPoint
			DragFrame.Size = MainFrameOutline.Size

			local TweenFrame = TweenService:Create(
				DragFrame,
				TweenInfo.new(0.25, Enum.EasingStyle.Quad),
				{ BackgroundTransparency = 0.7 }
			)
			local TweenStroke =
				TweenService:Create(DragStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad), { Transparency = 0 })
			TweenFrame:Play()
			TweenStroke:Play()

			Functions["AddConnection"]("MenuDragMove", UserInputService.InputChanged, function(Input, Processed)
				if Input.UserInputType == Enum.UserInputType.MouseMovement then
					local MousePosition = UserInputService:GetMouseLocation()
					local TargetX = MousePosition.X - Offset.X
					local TargetY = MousePosition.Y - Offset.Y

					local ViewportSize = Camera.ViewportSize
					local FrameSize = DragFrame.AbsoluteSize
					local AnchorPoint = DragFrame.AnchorPoint

					local MinX = FrameSize.X * AnchorPoint.X
					local MinY = FrameSize.Y * AnchorPoint.Y
					local MaxX = ViewportSize.X - FrameSize.X * (1 - AnchorPoint.X)
					local MaxY = ViewportSize.Y - FrameSize.Y * (1 - AnchorPoint.Y)

					TargetX = math.clamp(TargetX, MinX, MaxX)
					TargetY = math.clamp(TargetY, MinY, MaxY)

					DragFrame.Position = UDim2.new(0, TargetX, 0, TargetY)
				end
			end)

			Functions["AddConnection"]("MenuDragEnded", UserInputService.InputEnded, function(Input, Processed)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Functions["RemoveConnection"]("MenuDragEnded")
					Functions["RemoveConnection"]("MenuDragMove")

					local TweenFrame = TweenService:Create(
						DragFrame,
						TweenInfo.new(0.25, Enum.EasingStyle.Quad),
						{ BackgroundTransparency = 1 }
					)
					local TweenStroke = TweenService:Create(
						DragStroke,
						TweenInfo.new(0.25, Enum.EasingStyle.Quad),
						{ Transparency = 1 }
					)
					TweenFrame:Play()
					TweenStroke:Play()

					MainFrameOutline.Position = DragFrame.Position
				end
			end)
		end)

		local Transparencys = {}
		Menu.Functions.Fade = function(Self, Bool, Duration)
			if not Duration then
				return Functions["Message"]("Duration Argument left blank.", "Error")
			end
			if Bool == nil then
				return Functions["Message"]("Bool Argument left blank.", "Error")
			end

			if typeof(Bool) ~= "boolean" then
				return Functions["Message"]("Bool Argument is not a boolean.", "Error")
			end
			if typeof(Duration) ~= "number" then
				return Functions["Message"]("Duration Argument is not a number.", "Error")
			end

			if Bool == Menu.Visible then
				return
			end

			UserInputService.MouseIconEnabled = not Bool
			CursorOutline.Visible = Bool

			local Objects = MainFrameOutline:GetDescendants()
			table.insert(Objects, MainFrameOutline)

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

				if Data.Transparency and not Data.BackgroundTransparency and not Data.ImageTransparency then
					TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{ Transparency = Bool and Data.Transparency or 1 }
					):Play()
				end

				if Data.TextTransparency then
					TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{ TextTransparency = Bool and Data.TextTransparency or 1 }
					):Play()
				end

				if Data.BackgroundTransparency then
					TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{ BackgroundTransparency = Bool and Data.BackgroundTransparency or 1 }
					):Play()
				end

				if Data.ImageTransparency then
					TweenService:Create(
						Object,
						TweenInfo.new(Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
						{ ImageTransparency = Bool and Data.ImageTransparency or 1 }
					):Play()
				end
			end

			Menu.Visible = Bool
		end

		Menu.Functions.Refresh = function(Self, Current)
			table.sort(Menu.Tabs, function(A, B)
				return A.Order < B.Order
			end)

			for i, Tab in next, Menu.Tabs do
				local Selected = Tab == Current

				if Tab.Objects.List then
					Tab.Objects.List.Visible = false
				end

				Tab.Objects.Background.Size = UDim2.new(1 / #Menu.Tabs, i == #Menu.Tabs and -2 or -1, 1, -2)
				Tab.Objects.Background.Position = UDim2.new((i - 1) * (1 / #Menu.Tabs), 1, 0, 1)
				Tab.Objects.Gradient.Rotation = Selected and 0 or 180

				Functions["UpdateThemeRegistery"](
					Tab.Objects.Background,
					{ BackgroundColor3 = Selected and "Selected Tab" or "Unselected Tab" }
				)
				Functions["UpdateThemeRegistery"](
					Tab.Objects.Label,
					{ TextColor3 = Selected and "Accent" or "Inactive Text" }
				)

				if Tab.Sections then
					for i, Section in next, Tab.Sections do
						Section.Objects.Main.Visible = false
					end
				end
			end

			Menu.Tab = Current

			if Menu.Tab.Sections then
				for i, Section in next, Menu.Tab.Sections do
					Section.Objects.Main.Visible = true
				end

				if Menu.Tab.Objects.List then
					Menu.Tab.Objects.List.Visible = true
				end
			end
		end

		Menu.Functions.Players = function(Properties)
			local Tab = {
				Order = #Menu.Tabs + 1,
				Functions = {},
				Objects = {},
				Sections = {},
				List = {},
			}

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
				Image = Functions["CustomAsset"]("Fondra/Assets/Images/Gradient 90.png"),
			})

			local Label = Functions["Create"]("TextLabel", {
				Parent = Main,
				Text = Properties.Name,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				FontFace = CustomFont,
				TextSize = 12,
			})

			local LabelStroke = Functions["Create"]("UIStroke", {
				Parent = Label,
			})

			Tab.Objects["Background"] = Main
			Tab.Objects["Gradient"] = Gradient
			Tab.Objects["Label"] = Label

			local PlayerListOutline = Functions["Create"]("TextButton", {
				Parent = DataFrameHolder,
				Size = UDim2.new(1, -16, 1, -16),
				Position = UDim2.new(0, 8, 0, 8),
				Theme = { BackgroundColor3 = "Border 2" },
			})

			local PlayerListAccent = Functions["Create"]("TextButton", {
				Parent = PlayerListOutline,
				Size = UDim2.new(1, -2, 0, 1),
				Position = UDim2.new(0, 1, 0, 0),
				AnchorPoint = Vector2.new(0, 0),
				Theme = { BackgroundColor3 = "Accent" },
			})

			local PlayerListMiddle = Functions["Create"]("TextButton", {
				Parent = PlayerListOutline,
				Size = UDim2.new(1, -2, 1, -3),
				Position = UDim2.new(0.5, 0, 0, 2),
				AnchorPoint = Vector2.new(0.5, 0),
				Theme = { BackgroundColor3 = "Border 1" },
			})

			local PlayerListInline = Functions["Create"]("TextButton", {
				Parent = PlayerListMiddle,
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Theme = { BackgroundColor3 = "Border 2" },
			})

			local PlayerListFill = Functions["Create"]("TextButton", {
				Parent = PlayerListInline,
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Theme = { BackgroundColor3 = "Section Background" },
			})

			local PlayerListScrollFrameOutline = Functions["Create"]("TextButton", {
				Parent = PlayerListFill,
				Size = UDim2.new(1, -16, 0.8, -16),
				Position = UDim2.new(0, 8, 0, 8),
				Theme = { BackgroundColor3 = "Border 1" },
			})

			local PlayerListScrollFrameInline = Functions["Create"]("ScrollingFrame", {
				Parent = PlayerListScrollFrameOutline,
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Theme = { BackgroundColor3 = "Border 2" },
				ClipsDescendants = true,
				ScrollBarThickness = 0,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
			})

			local PlayerListScrollFrameLayout = Functions["Create"]("UIListLayout", {
				Parent = PlayerListScrollFrameInline,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			})

			local PlayerListDataFrameOutline = Functions["Create"]("TextButton", {
				Parent = PlayerListFill,
				Size = UDim2.new(1, -16, 0.2, -8),
				Position = UDim2.new(0, 8, 1, -8),
				AnchorPoint = Vector2.new(0, 1),
				Theme = { BackgroundColor3 = "Border 1" },
			})

			local PlayerListDataFrameInline = Functions["Create"]("TextButton", {
				Parent = PlayerListDataFrameOutline,
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Theme = { BackgroundColor3 = "Border 2" },
			})

			Tab.Objects["List"] = PlayerListOutline

			local PreviewIconOutline = Functions["Create"]("Frame", {
				Size = UDim2.new(1, -16, 1, -16),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Position = UDim2.new(0, 8, 0, 8),
				Theme = { BackgroundColor3 = "Border 1" },
				Parent = PlayerListDataFrameInline,
			})

			local PreviewIconInline = Functions["Create"]("Frame", {
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0, 1, 0, 1),
				Theme = { BackgroundColor3 = "Border 2" },

				Parent = PreviewIconOutline,
			})

			local PreviewIconFill = Functions["Create"]("Frame", {
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0, 1, 0, 1),
				Theme = { BackgroundColor3 = "Option Background" },
				Parent = PreviewIconInline,
			})

			local PreviewIconImage = Functions["Create"]("ImageLabel", {
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0, 1, 0, 1),
				BackgroundTransparency = 1,
				Parent = PreviewIconFill,
			})

			local PreviewNameText = Functions["Create"]("TextLabel", {
				Parent = PreviewIconOutline,
				Text = "???",
				Theme = { TextColor3 = "Active Text" },
				Position = UDim2.new(1, 4, 0, 2),
				AnchorPoint = Vector2.new(1, 0),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 18,
				FontFace = CustomFont,
			})

			local PreviewStatusDropdown = Functions["Create"]("Frame", {
				Parent = PreviewIconOutline,
				Position = UDim2.new(1, 2, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				Size = UDim2.new(1.5, 0, 0, 22),
				BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
				Transparency = Library.Debug and 0 or 1,
			})

			local PreviewStatusDropdownComponent = Components["Dropdown"](PreviewStatusDropdown, {
				Text = "STATUS",
				Options = { "NONE", "FRIENDLY", "PRIORITY" },
				Current = { "NONE" },
				Minimum = 1,
				Maximum = 1,
				Callback = function(Result)
					local Selected = Tab.Selected
					if Selected then
						local Status = Result[1]
						Tab.List[Selected].Status.Text = Status
						Library.Relations[Selected] = Status

						if Status == "FRIENDLY" then
							Functions["UpdateThemeRegistery"](Tab.List[Selected].Status, { TextColor3 = "Accent" })
						elseif Status == "PRIORITY" then
							Functions["UpdateThemeRegistery"](
								Tab.List[Selected].Status,
								{ TextColor3 = "Warning Text" }
							)
						else
							Functions["UpdateThemeRegistery"](Tab.List[Selected].Status, { TextColor3 = "Active Text" })
						end
					end
				end,
			})

			local function CreatePlayerEntry(Player)
				if Player == Client then
					return
				end

				Library.Relations[Player] = "NONE"

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
					Theme = { TextColor3 = "Active Text" },
				})

				local PlayerStatus = Functions["Create"]("TextLabel", {
					Parent = PlayerButton,
					Text = "NONE",
					Position = UDim2.new(1, -8, 0.5, 0),
					Size = UDim2.new(0.3, -8, 0, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					FontFace = CustomFont,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Right,
					Theme = { TextColor3 = "Active Text" },
				})

				Tab.List[Player] = {
					Button = PlayerButton,
					Name = PlayerName,
					Status = PlayerStatus,
				}

				Functions["AddConnection"](Tab, PlayerButton.MouseButton1Down, function()
					if Tab.Selected then
						Functions["UpdateThemeRegistery"](Tab.List[Tab.Selected].Name, { TextColor3 = "Active Text" })
					end

					Tab.Selected = Player
					Functions["UpdateThemeRegistery"](PlayerName, { TextColor3 = "Accent" })

					PreviewNameText.Text = Player.Name
					PreviewStatusDropdownComponent.Functions.Set({ PlayerStatus.Text })

					spawn(function()
						local Success, Content = pcall(function()
							return Players:GetUserThumbnailAsync(
								Player.UserId,
								Enum.ThumbnailType.HeadShot,
								Enum.ThumbnailSize.Size150x150
							)
						end)
						if Success then
							PreviewIconImage.Image = Content
						end
					end)
				end)
			end

			local function RemovePlayerEntry(Player)
				if Tab.List[Player] then
					if Tab.Selected == Player then
						Tab.Selected = nil
						PreviewNameText.Text = "Select Player"
						PreviewIconImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
					end

					Tab.List[Player].Button:Destroy()
					Tab.List[Player] = nil
					Library.Relations[Player] = nil
				end
			end

			for _, Player in next, Players:GetPlayers() do
				CreatePlayerEntry(Player)
			end

			Functions["AddConnection"](Tab, Players.PlayerAdded, CreatePlayerEntry)
			Functions["AddConnection"](Tab, Players.PlayerRemoving, RemovePlayerEntry)
			Functions["AddConnection"](nil, Main.MouseButton1Down, function()
				if Menu.Tab == Tab then
					return
				end

				Menu.Functions:Refresh(Tab)
			end)

			table.insert(Menu.Tabs, Tab)
			Menu.Functions:Refresh(Tab)
		end

		Menu.Functions.Tab = function(Properties)
			local Tab = {
				Order = #Menu.Tabs + 1,
				Functions = {},
				Objects = {},
				Sections = {},
			}

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
				Image = Functions["CustomAsset"]("Fondra/Assets/Images/Gradient 90.png"),
			})

			local Label = Functions["Create"]("TextLabel", {
				Parent = Main,
				Text = Properties.Name,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				FontFace = CustomFont,
				TextSize = 12,
			})

			local LabelStroke = Functions["Create"]("UIStroke", {
				Parent = Label,
			})

			Tab.Objects["Background"] = Main
			Tab.Objects["Gradient"] = Gradient
			Tab.Objects["Label"] = Label

			Functions["AddConnection"](nil, Main.MouseButton1Down, function()
				if Menu.Tab == Tab then
					return
				end

				Menu.Functions:Refresh(Tab)
			end)

			Tab.Functions.Section = function(Properties)
				local Properties = {
					Side = Properties.Side or "LEFT",
					Text = Properties.Text or "SECTION",
				}

				local Column = Properties.Side == "RIGHT" and ContainerRight
					or Properties.Side == "LEFT" and ContainerLeft
				local Main = Functions["Create"]("TextButton", {
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 0, 40),
					Theme = { BackgroundColor3 = "Border 2" },
					Visible = Menu.Tab == Tab,
					Parent = Column,
				})

				local ButtonsOutline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 2),
					Size = UDim2.new(1, -2, 0, 18),
					Theme = { BackgroundColor3 = "Border 1" },
					Parent = Main,
				})

				local ButtonsInline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					Theme = { BackgroundColor3 = "Border 2" },
					Parent = ButtonsOutline,
				})

				local ButtonsHolder = Functions["Create"]("Frame", {
					Parent = ButtonsInline,
					Size = UDim2.new(1, -2, 1, -2),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Theme = { BackgroundColor3 = "Section Background" },
				})

				local SectionLabel = Functions["Create"]("TextLabel", {
					Parent = ButtonsHolder,
					Text = Properties.Text,
					Theme = { TextColor3 = "Active Text", BackgroundColor3 = "Section Background" },
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
					Theme = { BackgroundColor3 = "Accent" },
					Parent = Main,
				})

				local HolderOutline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 19),
					Size = UDim2.new(1, -2, 1, -20),
					Theme = { BackgroundColor3 = "Border 1" },
					Parent = Main,
				})

				local HolderInline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					Theme = { BackgroundColor3 = "Border 2" },
					Parent = HolderOutline,
				})

				local HolderMain = Functions["Create"]("Frame", {
					Parent = HolderInline,
					Size = UDim2.new(1, -2, 1, -2),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Theme = { BackgroundColor3 = "Section Background" },
				})

				local HolderLayout = Functions["Create"]("UIListLayout", {
					Parent = HolderMain,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				})

				local Section = {
					Objects = {},
					Functions = {},
				}

				Section.Objects.Main = Main

				do
					Section.Functions.Resize = function(Self)
						if #HolderMain:GetChildren() < 2 then
							Main.Size = UDim2.new(1, 0, 0, 40)
						else
							Main.Size = UDim2.new(1, 0, 0, 24 + HolderLayout.AbsoluteContentSize.Y)
						end
					end

					Section.Functions.Toggle = function(Self, Options)
						local Holder = Functions["Create"]("Frame", {
							Parent = HolderMain,
							Size = UDim2.new(1, 0, 0, 20),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
						})

						local Main = Functions["Create"]("Frame", {
							Parent = Holder,
							Size = UDim2.new(1, 0, 1, -4),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.new(0.5, 0, 0.5, 0),
						})

						local Toggle = Components["Toggle"](Main, Options)
						Self:Resize()

						return Toggle
					end

					Section.Functions.Slider = function(Self, Options)
						local Holder = Functions["Create"]("Frame", {
							Parent = HolderMain,
							Size = UDim2.new(1, 0, 0, 22),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
						})

						local Main = Functions["Create"]("Frame", {
							Parent = Holder,
							Size = UDim2.new(1, -4, 1, -4),
							Transparency = Library.Debug and 0 or 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
						})

						local Slider = Components["Slider"](Main, Options)
						Self:Resize()

						return Slider
					end

					Section.Functions.Dropdown = function(Self, Options)
						local Holder = Functions["Create"]("Frame", {
							Parent = HolderMain,
							Size = UDim2.new(1, 0, 0, 22),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
						})

						local Main = Functions["Create"]("Frame", {
							Parent = Holder,
							Size = UDim2.new(1, -4, 1, -4),
							Transparency = Library.Debug and 0 or 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
						})

						local Dropdown = Components["Dropdown"](Main, Options)
						Self:Resize()

						return Dropdown
					end

					Section.Functions.TextBox = function(Self, Options)
						local Holder = Functions["Create"]("Frame", {
							Parent = HolderMain,
							Size = UDim2.new(1, 0, 0, 22),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
						})

						local Main = Functions["Create"]("Frame", {
							Parent = Holder,
							Size = UDim2.new(1, -4, 1, -4),
							Transparency = Library.Debug and 0 or 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
						})

						local TextBox = Components["TextBox"](Main, Options)
						Self:Resize()

						return TextBox
					end

					Section.Functions.Button = function(Self, Options)
						local Holder = Functions["Create"]("Frame", {
							Parent = HolderMain,
							Size = UDim2.new(1, 0, 0, 22),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
						})

						local Main = Functions["Create"]("Frame", {
							Parent = Holder,
							Size = UDim2.new(1, -4, 1, -4),
							Transparency = Library.Debug and 0 or 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
						})

						local Button = Components["Button"](Main, Options)
						Self:Resize()

						return Button
					end

					Section.Functions.Label = function(Self, Options)
						local Holder = Functions["Create"]("Frame", {
							Parent = HolderMain,
							Size = UDim2.new(1, 0, 0, 22),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
						})

						local Main = Functions["Create"]("Frame", {
							Parent = Holder,
							Size = UDim2.new(1, -4, 1, -4),
							Transparency = Library.Debug and 0 or 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
						})

						local Label = Components["Label"](Main, Options)
						Self:Resize()

						return Label
					end

					Section.Functions.Divider = function(Self, Options)
						local Holder = Functions["Create"]("Frame", {
							Parent = HolderMain,
							Size = UDim2.new(1, 0, 0, Options.Gap or 10),
							BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
							Transparency = Library.Debug and 0 or 1,
						})

						local Main = Functions["Create"]("Frame", {
							Parent = Holder,
							Size = UDim2.new(1, -4, 1, -4),
							Transparency = Library.Debug and 0 or 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
						})

						Self:Resize()

						return
					end
				end

				Tab.Sections[#Tab.Sections + 1] = Section
				Section.Functions:Resize()

				return Section
			end

			Tab.Functions.MultiSection = function(Properties)
				local Properties = {
					Side = Properties.Side or "LEFT",
					Sections = {},
				}

				local Column = Properties.Side == "RIGHT" and ContainerRight
					or Properties.Side == "LEFT" and ContainerLeft
				local Main = Functions["Create"]("TextButton", {
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 0, 40),
					Theme = { BackgroundColor3 = "Border 2" },
					Visible = Menu.Tab == Tab,
					Parent = Column,
				})

				local ButtonsOutline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 2),
					Size = UDim2.new(1, -2, 0, 18),
					Theme = { BackgroundColor3 = "Border 1" },
					Parent = Main,
				})

				local ButtonsInline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					Theme = { BackgroundColor3 = "Border 2" },
					Parent = ButtonsOutline,
				})

				local ButtonsHolder = Functions["Create"]("Frame", {
					Parent = ButtonsInline,
					Size = UDim2.new(1, -2, 1, -2),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Theme = { BackgroundColor3 = "Section Background" },
				})

				local Accent = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 0, 1),
					Theme = { BackgroundColor3 = "Accent" },
					Parent = Main,
				})

				local HolderOutline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 19),
					Size = UDim2.new(1, -2, 1, -20),
					Theme = { BackgroundColor3 = "Border 1" },
					Parent = Main,
				})

				local HolderInline = Functions["Create"]("Frame", {
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
					Theme = { BackgroundColor3 = "Border 2" },
					Parent = HolderOutline,
				})

				local HolderMain = Functions["Create"]("Frame", {
					Parent = HolderInline,
					Size = UDim2.new(1, -2, 1, -2),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Theme = { BackgroundColor3 = "Section Background" },
				})

				local HolderLayout = Functions["Create"]("UIListLayout", {
					Parent = HolderMain,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				})

				local MultiSection = {
					Objects = {},
					Functions = {},
					Tabs = {},
					Selected = nil,
				}

				MultiSection.Objects.Main = Main

				do
					MultiSection.Functions.Resize = function(Self) end

					MultiSection.Functions.Refresh = function(Self, Current)
						table.sort(MultiSection.Tabs, function(A, B)
							return A.Order < B.Order
						end)

						for i, Tab in next, MultiSection.Tabs do
							local Selected = Tab == Current

							Tab.Objects.Background.Size =
								UDim2.new(1 / #MultiSection.Tabs, i == #MultiSection.Tabs and -2 or -1, 1, -2)
							Tab.Objects.Background.Position = UDim2.new((i - 1) * (1 / #MultiSection.Tabs), 1, 0, 1)
							Tab.Objects.Gradient.Rotation = Selected and 0 or 180

							Functions["UpdateThemeRegistery"](
								Tab.Objects.Label,
								{ TextColor3 = Selected and "Active Text" or "Inactive Text" }
							)

							Tab.Objects.Main.Visible = false
						end

						MultiSection.Selected = Current
						Current.Objects.Main.Visible = true
					end

					MultiSection.Functions.Section = function(Properties)
						local Properties = {
							Text = Properties.Text or "SECTION",
						}

						local Section = {
							Objects = {},
							Functions = {},
							Order = #MultiSection.Tabs + 1,
						}

						local HolderMain = Functions["Create"]("Frame", {
							Parent = HolderInline,
							Size = UDim2.new(1, -2, 1, -2),
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							Theme = { BackgroundColor3 = "Section Background" },
						})

						local HolderLayout = Functions["Create"]("UIListLayout", {
							Parent = HolderMain,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
						})

						local Button = Functions["Create"]("TextButton", {
							Parent = ButtonsHolder,
							Size = UDim2.new(0, 0, 0, 0),
							Position = UDim2.new(0, 0, 0, 0),
							Theme = { BackgroundColor3 = "Section Background" },
						})

						local Gradient = Functions["Create"]("ImageLabel", {
							Parent = Button,
							Size = UDim2.new(1, 0, 1, 0),
							Position = UDim2.new(0, 0, 0, 0),
							BackgroundTransparency = 1,
							ImageTransparency = 0.6,
							Image = Functions["CustomAsset"]("Fondra/Assets/Images/Gradient 90.png"),
						})

						local Label = Functions["Create"]("TextLabel", {
							Parent = Button,
							Text = Properties.Text,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							AnchorPoint = Vector2.new(0.5, 0.5),
							FontFace = CustomFont,
							TextSize = 12,
						})

						local LabelStroke = Functions["Create"]("UIStroke", {
							Parent = Label,
						})

						Section.Objects["Background"] = Button
						Section.Objects["Gradient"] = Gradient
						Section.Objects["Label"] = Label
						Section.Objects["Main"] = HolderMain

						Functions["AddConnection"](nil, Button.MouseButton1Down, function()
							if MultiSection.Selected == Section then
								return
							end

							MultiSection.Functions:Refresh(Section)
							Section.Functions:Resize()
						end)

						do
							Section.Functions.Resize = function(Self)
								if #HolderMain:GetChildren() < 2 then
									Main.Size = UDim2.new(1, 0, 0, 40)
								else
									Main.Size = UDim2.new(1, 0, 0, 24 + HolderLayout.AbsoluteContentSize.Y)
								end
							end

							Section.Functions.Toggle = function(Self, Options)
								local Holder = Functions["Create"]("Frame", {
									Parent = HolderMain,
									Size = UDim2.new(1, 0, 0, 20),
									BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
									Transparency = Library.Debug and 0 or 1,
								})

								local Main = Functions["Create"]("Frame", {
									Parent = Holder,
									Size = UDim2.new(1, 0, 1, -4),
									BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
									Transparency = Library.Debug and 0 or 1,
									AnchorPoint = Vector2.new(0.5, 0.5),
									Position = UDim2.new(0.5, 0, 0.5, 0),
								})

								local Toggle = Components["Toggle"](Main, Options)
								Self:Resize()

								return Toggle
							end

							Section.Functions.Slider = function(Self, Options)
								local Holder = Functions["Create"]("Frame", {
									Parent = HolderMain,
									Size = UDim2.new(1, 0, 0, 22),
									BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
									Transparency = Library.Debug and 0 or 1,
								})

								local Main = Functions["Create"]("Frame", {
									Parent = Holder,
									Size = UDim2.new(1, -4, 1, -4),
									Transparency = Library.Debug and 0 or 1,
									Position = UDim2.new(0.5, 0, 0.5, 0),
									AnchorPoint = Vector2.new(0.5, 0.5),
								})

								local Slider = Components["Slider"](Main, Options)
								Self:Resize()

								return Slider
							end

							Section.Functions.Dropdown = function(Self, Options)
								local Holder = Functions["Create"]("Frame", {
									Parent = HolderMain,
									Size = UDim2.new(1, 0, 0, 22),
									BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
									Transparency = Library.Debug and 0 or 1,
								})

								local Main = Functions["Create"]("Frame", {
									Parent = Holder,
									Size = UDim2.new(1, -4, 1, -4),
									Transparency = Library.Debug and 0 or 1,
									Position = UDim2.new(0.5, 0, 0.5, 0),
									AnchorPoint = Vector2.new(0.5, 0.5),
								})

								local Dropdown = Components["Dropdown"](Main, Options)
								Self:Resize()

								return Dropdown
							end

							Section.Functions.TextBox = function(Self, Options)
								local Holder = Functions["Create"]("Frame", {
									Parent = HolderMain,
									Size = UDim2.new(1, 0, 0, 22),
									BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
									Transparency = Library.Debug and 0 or 1,
								})

								local Main = Functions["Create"]("Frame", {
									Parent = Holder,
									Size = UDim2.new(1, -4, 1, -4),
									Transparency = Library.Debug and 0 or 1,
									Position = UDim2.new(0.5, 0, 0.5, 0),
									AnchorPoint = Vector2.new(0.5, 0.5),
								})

								local TextBox = Components["TextBox"](Main, Options)
								Self:Resize()

								return TextBox
							end

							Section.Functions.Button = function(Self, Options)
								local Holder = Functions["Create"]("Frame", {
									Parent = HolderMain,
									Size = UDim2.new(1, 0, 0, 22),
									BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
									Transparency = Library.Debug and 0 or 1,
								})

								local Main = Functions["Create"]("Frame", {
									Parent = Holder,
									Size = UDim2.new(1, -4, 1, -4),
									Transparency = Library.Debug and 0 or 1,
									Position = UDim2.new(0.5, 0, 0.5, 0),
									AnchorPoint = Vector2.new(0.5, 0.5),
								})

								local Button = Components["Button"](Main, Options)
								Self:Resize()

								return Button
							end

							Section.Functions.Label = function(Self, Options)
								local Holder = Functions["Create"]("Frame", {
									Parent = HolderMain,
									Size = UDim2.new(1, 0, 0, 22),
									BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
									Transparency = Library.Debug and 0 or 1,
								})

								local Main = Functions["Create"]("Frame", {
									Parent = Holder,
									Size = UDim2.new(1, -4, 1, -4),
									Transparency = Library.Debug and 0 or 1,
									Position = UDim2.new(0.5, 0, 0.5, 0),
									AnchorPoint = Vector2.new(0.5, 0.5),
								})

								local Label = Components["Label"](Main, Options)
								Self:Resize()

								return Label
							end

							Section.Functions.Divider = function(Self, Options)
								local Holder = Functions["Create"]("Frame", {
									Parent = HolderMain,
									Size = UDim2.new(1, 0, 0, Options.Gap or 10),
									BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
									Transparency = Library.Debug and 0 or 1,
								})

								local Main = Functions["Create"]("Frame", {
									Parent = Holder,
									Size = UDim2.new(1, -4, 1, -4),
									Transparency = Library.Debug and 0 or 1,
									Position = UDim2.new(0.5, 0, 0.5, 0),
									AnchorPoint = Vector2.new(0.5, 0.5),
								})

								Self:Resize()

								return
							end
						end

						table.insert(MultiSection.Tabs, Section)
						MultiSection.Functions:Refresh(Section)
						MultiSection.Functions:Resize()

						return Section
					end
				end

				Tab.Sections[#Tab.Sections + 1] = MultiSection
				MultiSection.Functions:Resize()

				return MultiSection
			end

			table.insert(Menu.Tabs, Tab)
			Menu.Functions:Refresh(Tab)

			return Tab
		end

		Menu.Functions:Fade(false, 0)
		Menu.Functions:Fade(true, 0)

		return Menu
	end
end

return Library
