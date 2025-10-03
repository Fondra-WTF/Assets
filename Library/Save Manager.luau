-- SaveManager.lua
local Game = game
local Services = setmetatable({}, {
	__index = function(Self, Service)
		local Cache = Game.GetService(Game, Service)
		rawset(Self, Service, Cache)
		return Cache
	end,
})

local SaveManager = {}
do
	SaveManager.Folder = "Fondra/Games/Criminality"
	SaveManager.Library = nil
	SaveManager.Ignore = {}

	function SaveManager:SetLibrary(Library)
		self.Library = Library
	end

	function SaveManager:SetFolder(Folder)
		self.Folder = Folder
		self:BuildFolderTree()
	end

	function SaveManager:SetIgnoreIndexes(List)
		for _, Key in next, List do
			self.Ignore[Key] = true
		end
	end

	function SaveManager:BuildFolderTree()
		local Directorys = {}

		self.Folder:gsub("([^/]+)", function(Directory)
			table.insert(Directorys, Directory)
		end)

		for _, Directory in next, Directorys do
			local Directory = table.concat(Directorys, "/", 1, _)

			if isfolder(Directory) then
				continue
			end

			makefolder(Directory)
		end
	end

	function SaveManager:GetConfigList()
		local List = listfiles(self.Folder)
		local Output = {}

		for i = 1, #List do
			local File = List[i]

			if File:sub(-5) == ".json" then
				local Position = File:find(".json", 1, true)
				local Start = Position
				local Character = File:sub(Position, Position)

				while Character ~= "/" and Character ~= "\\" and Character ~= "" do
					Position = Position - 1
					Character = File:sub(Position, Position)
				end

				if Character == "/" or Character == "\\" then
					table.insert(Output, File:sub(Position + 1, Start - 1))
				end
			end
		end

		return Output
	end

	function SaveManager:SaveConfig(Name)
		if Name:gsub(" ", "") == "" then
			return self.Library:Notification(
				"[SaveManager]: Invalid file name for config. [Empty]",
				3,
				Color3.fromRGB(255, 0, 0)
			)
		end
		if isfile(string.format("%s/%s.json", self.Folder, Name)) then
			return self.Library:Notification("[SaveManager]: Config already exists.", 3, Color3.fromRGB(255, 0, 0))
		end

		local Config = {}

		for Index, Toggle in next, Toggles do
			if self.Ignore[Index] then
				continue
			end

			Config[Index] = {
				Type = "Toggle",
				Value = Toggle.Value,
			}
		end

		for Index, Slider in next, Sliders do
			if self.Ignore[Index] then
				continue
			end

			Config[Index] = {
				Type = "Slider",
				Value = Slider.Current,
			}
		end

		for Index, Dropdown in next, Dropdowns do
			if self.Ignore[Index] then
				continue
			end

			Config[Index] = {
				Type = "Dropdown",
				Value = Dropdown.Current,
			}
		end

		for Index, TextBox in next, TextBoxes do
			if self.Ignore[Index] then
				continue
			end

			Config[Index] = {
				Type = "TextBox",
				Value = TextBox.Text,
			}
		end

		for Index, Keypicker in next, Keypickers do
			if self.Ignore[Index] then
				continue
			end

			Config[Index] = {
				Type = "Keypicker",
				Value = {
					Input = Keypicker.Input,
					Mode = Keypicker.Mode,
				},
			}
		end

		for Index, Colorpicker in next, Colorpickers do
			if self.Ignore[Index] then
				continue
			end

			local Data = Colorpicker:Get()
			local R, G, B = Data.Color.R, Data.Color.G, Data.Color.B

			Config[Index] = {
				Type = "Colorpicker",
				Value = {
					Color = { R, G, B },
					Alpha = Data.Alpha,
					Mode = Data.Mode,
				},
			}
		end

		local Success, Encoded = pcall(Services.HttpService.JSONEncode, Services.HttpService, Config)
		local Success, Encrypted = pcall(crypt.base64encode, Encoded)

		if not Success then
			return self.Library:Notification("[SaveManager]: Failed to encode config.", 3, Color3.fromRGB(255, 0, 0))
		end

		writefile(string.format("%s/%s.json", self.Folder, Name), Encrypted)

		return self.Library:Notification(string.format("[SaveManager]: Saved Config %q", Name), 3, "Accent")
	end

	function SaveManager:LoadConfig(Name, Button)
		if Name == nil or Name == "" then
			return self.Library:Notification("[SaveManager]: Invalid Selection.", 3, Color3.fromRGB(255, 0, 0))
		end

		local File = string.format("%s/%s.json", self.Folder, Name)

		if not isfile(File) then
			return self.Library:Notification("[SaveManager]: Config does not exist.", 3, Color3.fromRGB(255, 0, 0))
		end

		local Success, Decoded = pcall(crypt.base64decode, readfile(File))
		local Success, Config = pcall(Services.HttpService.JSONDecode, Services.HttpService, Decoded)

		if not Success then
			return self.Library:Notification("[SaveManager]: Failed to decode config.", 3, Color3.fromRGB(255, 0, 0))
		end

		for Index, Data in next, Config do
			task.spawn(function()
				if Data.Type == "Toggle" and Toggles[Index] then
					Toggles[Index]:Set(Data.Value)
				elseif Data.Type == "Slider" and Sliders[Index] then
					Sliders[Index]:Set(Data.Value)
				elseif Data.Type == "Dropdown" and Dropdowns[Index] then
					Dropdowns[Index]:Set(Data.Value)
				elseif Data.Type == "TextBox" and TextBoxes[Index] then
					TextBoxes[Index]:Set(Data.Value)
				elseif Data.Type == "Keypicker" and Keypickers[Index] then
					Keypickers[Index]:Set(Data.Value.Input, Data.Value.Mode)
				elseif Data.Type == "Colorpicker" and Colorpickers[Index] then
					local Current = Data.Value.Color
					local Color = Color3.new(Current[1], Current[2], Current[3])
					local Alpha = Data.Value.Alpha
					local Mode = Data.Value.Mode
					Colorpickers[Index]:Set(Color, Alpha, Mode)
				end
			end)
		end

		return Button and self.Library:Notification(string.format("[SaveManager]: Loaded Config %q", Name), 3, "Accent")
			or nil
	end

	function SaveManager:OverrideConfig(Name)
		if Name == nil or Name == "" then
			return self.Library:Notification("[SaveManager]: Invalid Selection.", 3, Color3.fromRGB(255, 0, 0))
		end
		if not isfile(string.format("%s/%s.json", self.Folder, Name)) then
			return self.Library:Notification("[SaveManager]: Config does not exist.", 3, Color3.fromRGB(255, 0, 0))
		end

		local Config = {}

		for Index, Toggle in next, Toggles do
			if self.Ignore[Index] then
				continue
			end

			Config[Index] = {
				Type = "Toggle",
				Value = Toggle.Value,
			}
		end

		for Index, Slider in next, Sliders do
			if self.Ignore[Index] then
				continue
			end

			Config[Index] = {
				Type = "Slider",
				Value = Slider.Current,
			}
		end

		for Index, Dropdown in next, Dropdowns do
			if self.Ignore[Index] then
				continue
			end

			Config[Index] = {
				Type = "Dropdown",
				Value = Dropdown.Current,
			}
		end

		for Index, TextBox in next, TextBoxes do
			if self.Ignore[Index] then
				continue
			end

			Config[Index] = {
				Type = "TextBox",
				Value = TextBox.Text,
			}
		end

		for Index, Keypicker in next, Keypickers do
			if self.Ignore[Index] then
				continue
			end

			Config[Index] = {
				Type = "Keypicker",
				Value = {
					Input = Keypicker.Input,
					Mode = Keypicker.Mode,
				},
			}
		end

		for Index, Colorpicker in next, Colorpickers do
			if self.Ignore[Index] then
				continue
			end

			local Data = Colorpicker:Get()
			local R, G, B = Data.Color.R, Data.Color.G, Data.Color.B

			Config[Index] = {
				Type = "Colorpicker",
				Value = {
					Color = { R, G, B },
					Alpha = Data.Alpha,
					Mode = Data.Mode,
				},
			}
		end

		local Success, Encoded = pcall(Services.HttpService.JSONEncode, Services.HttpService, Config)
		local Success, Encrypted = pcall(crypt.base64encode, Encoded)

		if not Success then
			return self.Library:Notification("[SaveManager]: Failed to encode config.", 3, Color3.fromRGB(255, 0, 0))
		end

		writefile(string.format("%s/%s.json", self.Folder, Name), Encrypted)

		return self.Library:Notification(string.format("[SaveManager]: Overrided config %q", Name), 3, "Accent")
	end

	function SaveManager:DeleteConfig(Name)
		if Name == nil or Name == "" then
			return self.Library:Notification("[SaveManager]: Invalid Selection.", 3, Color3.fromRGB(255, 0, 0))
		end
		if not isfile(string.format("%s/%s.json", self.Folder, Name)) then
			return self.Library:Notification("[SaveManager]: Config does not exist.", 3, Color3.fromRGB(255, 0, 0))
		end

		delfile(string.format("%s/%s.json", self.Folder, Name))

		return self.Library:Notification(string.format("[SaveManager]: Deleted Config %q", Name), 3, "Accent")
	end

	function SaveManager:SaveDefault(Name)
		if Name == nil or Name == "" then
			return self.Library:Notification("[SaveManager]: Invalid Selection.", 3, Color3.fromRGB(255, 0, 0))
		end

		writefile(string.format("%s/Default.txt", self.Folder), Name)
		self.Library:Notification(string.format("[SaveManager]: Set default config to %q", Name), 3, "Accent")
	end

	function SaveManager:RemoveDefault()
		if not isfile(string.format("%s/Default.txt", self.Folder)) then
			return self.Library:Notification("[SaveManager]: There is no default config.", 3, Color3.fromRGB(255, 0, 0))
		end

		delfile(string.format("%s/Default.txt", self.Folder))
		self.Library:Notification("[SaveManager]: Removed the default config.", 3, "Accent")
	end

	function SaveManager:LoadDefault()
		local Content = isfile(string.format("%s/Default.txt", self.Folder))
			and readfile(string.format("%s/Default.txt", self.Folder))

		if Content then
			local ConfigExists = false
			for _, ConfigName in next, self:GetConfigList() do
				if ConfigName == Content then
					ConfigExists = true
					break
				end
			end

			if ConfigExists then
				self:LoadConfig(Content, false)
				if Dropdowns["SaveManagerConfigList"] then
					Dropdowns["SaveManagerConfigList"]:Set({ Content })
				end
			end
		end
	end

	function SaveManager:LoadAutoloadConfig()
		self:LoadDefault()
	end

	function SaveManager:BuildConfigSection(Tab)
		self:SetIgnoreIndexes({
			"Accent",
			"Background 1",
			"Background 2",
			"Background 3",
			"Border 1",
			"Border 2",
			"Border 3",
			"Selected Tab",
			"Unselected Tab",
			"Selected Section",
			"Unselected Section",
			"Section Background",
			"Option Background",
			"Active Text",
			"Inactive Text",
			"Warning Text",
			"ThemeManagerBuiltList",
			"ThemeManagerCustomThemeList",
			"ThemeManagerCustomThemeName",
			"SaveManagerConfigList",
			"SaveManagerConfigName",
		})

		local Config = Tab:Section({
			Title = "Config",
			Side = "RIGHT",
		})

		Config:TextBox({
			Text = "",
			Placeholder = "Config Name",
			Flag = "SaveManagerConfigName",
		})

		Config:Dropdown({
			Text = "Config List",
			Flag = "SaveManagerConfigList",
			Options = self:GetConfigList(),
			Current = {},
			Minimum = 0,
			Maximum = 1,
		})

		Config:Button({
			Text = "CREATE",
			Result = "CREATED",
			Callback = function()
				self:SaveConfig(TextBoxes["SaveManagerConfigName"].Text)
				Dropdowns["SaveManagerConfigList"]:Values(self:GetConfigList())
				Dropdowns["SaveManagerConfigList"]:Set({})
			end,
		}):Button({
			Text = "DELETE",
			Result = "DELETED",
			Callback = function()
				self:DeleteConfig(Dropdowns["SaveManagerConfigList"].Current[1])
				Dropdowns["SaveManagerConfigList"]:Values(self:GetConfigList())
				Dropdowns["SaveManagerConfigList"]:Set({})
			end,
		})

		Config:Button({
			Text = "LOAD",
			Result = "LOADED",
			Callback = function()
				self:LoadConfig(Dropdowns["SaveManagerConfigList"].Current[1], true)
			end,
		}):Button({
			Text = "OVERWRITE",
			Result = "OVERWRITED",
			Callback = function()
				self:OverrideConfig(Dropdowns["SaveManagerConfigList"].Current[1])
			end,
		})

		Config:Button({
			Text = "SAVE DEFAULT",
			Result = "DONE",
			Callback = function()
				self:SaveDefault(Dropdowns["SaveManagerConfigList"].Current[1])
			end,
		}):Button({
			Text = "REMOVE DEFAULT",
			Result = "DONE",
			Callback = function()
				self:RemoveDefault()
			end,
		})

		Config:Button({
			Text = "REFRESH LIST",
			Result = "REFRESHED",
			Callback = function()
				Dropdowns["SaveManagerConfigList"]:Values(self:GetConfigList())
				Dropdowns["SaveManagerConfigList"]:Set({})
			end,
		})
	end
end

getgenv().SaveManager = SaveManager

return SaveManager
