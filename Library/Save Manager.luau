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
		local Directories = {}
		self.Folder:gsub("([^/]+)", function(Directory)
			table.insert(Directories, Directory)
		end)

		for _, Directory in next, Directories do
			local Path = table.concat(Directories, "/", 1, _)
			if not isfolder(Path) then
				makefolder(Path)
			end
		end
	end

	function SaveManager:GetConfigList()
		local List = listfiles(self.Folder)
		local Output = {}

		for _, File in next, List do
			if File:sub(-5) == ".json" then
				local Position = File:find(".json", 1, true)
				local Start = Position
				local Character = File:sub(Position, Position)
				while Character ~= "/" and Character ~= "\\" and Character ~= "" do
					Position -= 1
					Character = File:sub(Position, Position)
				end
				if Character == "/" or Character == "\\" then
					table.insert(Output, File:sub(Position + 1, Start - 1))
				end
			end
		end
		return Output
	end

	local function Encode(Data)
		local ok, json = pcall(Services.HttpService.JSONEncode, Services.HttpService, Data)
		if not ok then return nil end
		local ok2, encoded = pcall(crypt.base64encode, json)
		if not ok2 then return nil end
		return encoded
	end

	local function Decode(Text)
		local ok, decoded = pcall(crypt.base64decode, Text)
		if not ok then return nil end
		local ok2, data = pcall(Services.HttpService.JSONDecode, Services.HttpService, decoded)
		if not ok2 then return nil end
		return data
	end

	function SaveManager:SaveConfig(Name)
		if not Name or Name:gsub(" ", "") == "" then
			return self.Library:Notification("[SaveManager]: Invalid file name.", 3, Color3.fromRGB(255, 0, 0))
		end

		local Path = string.format("%s/%s.json", self.Folder, Name)
		if isfile(Path) then
			return self.Library:Notification("[SaveManager]: Config already exists.", 3, Color3.fromRGB(255, 0, 0))
		end

		local Config = {}

		for Index, Toggle in next, Toggles do
			if not self.Ignore[Index] then
				Config[Index] = { Type = "Toggle", Value = Toggle.Value }
			end
		end

		for Index, Slider in next, Sliders do
			if not self.Ignore[Index] then
				Config[Index] = { Type = "Slider", Value = Slider.Current }
			end
		end

		for Index, Dropdown in next, Dropdowns do
			if not self.Ignore[Index] then
				Config[Index] = { Type = "Dropdown", Value = Dropdown.Current }
			end
		end

		for Index, TextBox in next, TextBoxes do
			if not self.Ignore[Index] then
				Config[Index] = { Type = "TextBox", Value = TextBox.Text }
			end
		end

		for Index, Keypicker in next, Keypickers do
			if not self.Ignore[Index] then
				local InputName = Keypicker.Input and Keypicker.Input.Name or nil
				Config[Index] = {
					Type = "Keypicker",
					Value = {
						Input = InputName,
						Mode = Keypicker.Mode,
						Sync = Keypicker.Sync or true,
						Value = Keypicker.Value or false,
					},
				}
			end
		end

		for Index, Colorpicker in next, Colorpickers do
			if not self.Ignore[Index] then
				local Data = Colorpicker:Get()
				Config[Index] = {
					Type = "Colorpicker",
					Value = {
						Color = { Data.Color.R, Data.Color.G, Data.Color.B },
						Alpha = Data.Alpha,
						Mode = Data.Mode,
					},
				}
			end
		end

		local Encoded = Encode(Config)
		if not Encoded then
			return self.Library:Notification("[SaveManager]: Failed to encode config.", 3, Color3.fromRGB(255, 0, 0))
		end

		writefile(Path, Encoded)
		return self.Library:Notification(string.format("[SaveManager]: Saved Config %q", Name), 3, "Accent")
	end

	function SaveManager:LoadConfig(Name, Notify)
		if not Name or Name == "" then
			return self.Library:Notification("[SaveManager]: Invalid selection.", 3, Color3.fromRGB(255, 0, 0))
		end

		local Path = string.format("%s/%s.json", self.Folder, Name)
		if not isfile(Path) then
			return self.Library:Notification("[SaveManager]: Config not found.", 3, Color3.fromRGB(255, 0, 0))
		end

		local Data = Decode(readfile(Path))
		if not Data then
			return self.Library:Notification("[SaveManager]: Failed to decode config.", 3, Color3.fromRGB(255, 0, 0))
		end

		for Index, Item in next, Data do
			task.spawn(function()
				if Item.Type == "Toggle" and Toggles[Index] then
					Toggles[Index]:Set(Item.Value)
				elseif Item.Type == "Slider" and Sliders[Index] then
					Sliders[Index]:Set(Item.Value)
				elseif Item.Type == "Dropdown" and Dropdowns[Index] then
					Dropdowns[Index]:Set(Item.Value)
				elseif Item.Type == "TextBox" and TextBoxes[Index] then
					TextBoxes[Index]:Set(Item.Value)
				elseif Item.Type == "Keypicker" and Keypickers[Index] then
					local Input = nil
					if Item.Value.Input and Enum.KeyCode[Item.Value.Input] then
						Input = Enum.KeyCode[Item.Value.Input]
					end
					Keypickers[Index]:Set(Input, Item.Value.Mode)
					if Item.Value.Sync ~= nil then
						Keypickers[Index].Sync = Item.Value.Sync
					end
					Keypickers[Index].Value = Item.Value.Value or false
				elseif Item.Type == "Colorpicker" and Colorpickers[Index] then
					local Col = Item.Value.Color
					local C = Color3.new(Col[1], Col[2], Col[3])
					Colorpickers[Index]:Set(C, Item.Value.Alpha, Item.Value.Mode)
				end
			end)
		end

		if Notify then
			self.Library:Notification(string.format("[SaveManager]: Loaded Config %q", Name), 3, "Accent")
		end
	end

	function SaveManager:OverrideConfig(Name)
		if not Name or Name == "" then
			return self.Library:Notification("[SaveManager]: Invalid Selection.", 3, Color3.fromRGB(255, 0, 0))
		end
		local Path = string.format("%s/%s.json", self.Folder, Name)
		if not isfile(Path) then
			return self.Library:Notification("[SaveManager]: Config not found.", 3, Color3.fromRGB(255, 0, 0))
		end
		delfile(Path)
		self:SaveConfig(Name)
		self.Library:Notification(string.format("[SaveManager]: Overwrote Config %q", Name), 3, "Accent")
	end

	function SaveManager:DeleteConfig(Name)
		if not Name or Name == "" then
			return self.Library:Notification("[SaveManager]: Invalid Selection.", 3, Color3.fromRGB(255, 0, 0))
		end
		local Path = string.format("%s/%s.json", self.Folder, Name)
		if not isfile(Path) then
			return self.Library:Notification("[SaveManager]: Config not found.", 3, Color3.fromRGB(255, 0, 0))
		end
		delfile(Path)
		self.Library:Notification(string.format("[SaveManager]: Deleted Config %q", Name), 3, "Accent")
	end

	function SaveManager:SaveDefault(Name)
		if not Name or Name == "" then
			return self.Library:Notification("[SaveManager]: Invalid Selection.", 3, Color3.fromRGB(255, 0, 0))
		end
		writefile(string.format("%s/Default.txt", self.Folder), Name)
		self.Library:Notification(string.format("[SaveManager]: Set default config to %q", Name), 3, "Accent")
	end

	function SaveManager:RemoveDefault()
		local Path = string.format("%s/Default.txt", self.Folder)
		if not isfile(Path) then
			return self.Library:Notification("[SaveManager]: No default config found.", 3, Color3.fromRGB(255, 0, 0))
		end
		delfile(Path)
		self.Library:Notification("[SaveManager]: Removed default config.", 3, "Accent")
	end

	function SaveManager:LoadDefault()
		local Path = string.format("%s/Default.txt", self.Folder)
		if not isfile(Path) then return end

		local Content = readfile(Path)
		for _, Name in next, self:GetConfigList() do
			if Name == Content then
				self:LoadConfig(Content, false)
				if Dropdowns["SaveManagerConfigList"] then
					Dropdowns["SaveManagerConfigList"]:Set({ Content })
				end
				break
			end
		end
	end

	function SaveManager:LoadAutoloadConfig()
		self:LoadDefault()
	end

	function SaveManager:BuildConfigSection(Tab)
		self:SetIgnoreIndexes({
			"Accent", "Background 1", "Background 2", "Background 3",
			"Border 1", "Border 2", "Border 3", "Selected Tab",
			"Unselected Tab", "Selected Section", "Unselected Section",
			"Section Background", "Option Background", "Active Text",
			"Inactive Text", "Warning Text", "ThemeManagerBuiltList",
			"ThemeManagerCustomThemeList", "ThemeManagerCustomThemeName",
			"SaveManagerConfigList", "SaveManagerConfigName",
		})

		local Config = Tab:Section({ Title = "Config", Side = "RIGHT" })

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
		})
			:Button({
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
		})
			:Button({
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
		})
			:Button({
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
