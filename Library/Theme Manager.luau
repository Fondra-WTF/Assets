local Game = game
local Services = setmetatable({}, {
	__index = function(Self, Service)
		local Cache = Game.GetService(Game, Service)

		rawset(Self, Service, Cache)

		return Cache
	end,
})

local ThemeManager = {}
do
	ThemeManager.Folder = "Fondra/Themes"
	ThemeManager.Library = nil
	ThemeManager.Presets = {
		Fondra = {
			1,
			{
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
		},

		Gamesense = {
			2,
			{
				["Accent"] = Color3.fromRGB(126, 195, 66),
				["Background 1"] = Color3.fromRGB(20, 20, 20),
				["Background 2"] = Color3.fromRGB(28, 28, 28),
				["Background 3"] = Color3.fromRGB(16, 16, 16),
				["Border 1"] = Color3.fromRGB(0, 0, 0),
				["Border 2"] = Color3.fromRGB(40, 40, 40),
				["Border 3"] = Color3.fromRGB(55, 55, 55),
				["Selected Tab"] = Color3.fromRGB(28, 28, 28),
				["Unselected Tab"] = Color3.fromRGB(20, 20, 20),
				["Selected Section"] = Color3.fromRGB(32, 32, 32),
				["Unselected Section"] = Color3.fromRGB(26, 26, 26),
				["Section Background"] = Color3.fromRGB(24, 24, 24),
				["Option Background"] = Color3.fromRGB(36, 36, 36),
				["Active Text"] = Color3.fromRGB(240, 240, 240),
				["Inactive Text"] = Color3.fromRGB(160, 160, 160),
				["Warning Text"] = Color3.fromRGB(255, 90, 90),
			},
		},

		Neverlose = {
			3,
			{
				["Accent"] = Color3.fromRGB(79, 172, 254),
				["Background 1"] = Color3.fromRGB(16, 20, 28),
				["Background 2"] = Color3.fromRGB(20, 26, 36),
				["Background 3"] = Color3.fromRGB(12, 16, 22),
				["Border 1"] = Color3.fromRGB(6, 8, 12),
				["Border 2"] = Color3.fromRGB(28, 36, 48),
				["Border 3"] = Color3.fromRGB(36, 46, 60),
				["Selected Tab"] = Color3.fromRGB(18, 24, 32),
				["Unselected Tab"] = Color3.fromRGB(16, 20, 28),
				["Selected Section"] = Color3.fromRGB(22, 30, 40),
				["Unselected Section"] = Color3.fromRGB(26, 34, 46),
				["Section Background"] = Color3.fromRGB(18, 22, 30),
				["Option Background"] = Color3.fromRGB(24, 32, 42),
				["Active Text"] = Color3.fromRGB(255, 255, 255),
				["Inactive Text"] = Color3.fromRGB(160, 170, 185),
				["Warning Text"] = Color3.fromRGB(255, 120, 120),
			},
		},

		Spotify = {
			4,
			{
				["Accent"] = Color3.fromRGB(30, 215, 96),
				["Background 1"] = Color3.fromRGB(18, 18, 18),
				["Background 2"] = Color3.fromRGB(24, 24, 24),
				["Background 3"] = Color3.fromRGB(12, 12, 12),
				["Border 1"] = Color3.fromRGB(0, 0, 0),
				["Border 2"] = Color3.fromRGB(40, 40, 40),
				["Border 3"] = Color3.fromRGB(60, 60, 60),
				["Selected Tab"] = Color3.fromRGB(24, 24, 24),
				["Unselected Tab"] = Color3.fromRGB(18, 18, 18),
				["Selected Section"] = Color3.fromRGB(28, 28, 28),
				["Unselected Section"] = Color3.fromRGB(22, 22, 22),
				["Section Background"] = Color3.fromRGB(20, 20, 20),
				["Option Background"] = Color3.fromRGB(32, 32, 32),
				["Active Text"] = Color3.fromRGB(255, 255, 255),
				["Inactive Text"] = Color3.fromRGB(179, 179, 179),
				["Warning Text"] = Color3.fromRGB(255, 80, 80),
			},
		},

		Primordial = {
			5,
			{
				["Accent"] = Color3.fromRGB(190, 60, 255),
				["Background 1"] = Color3.fromRGB(15, 15, 20),
				["Background 2"] = Color3.fromRGB(20, 20, 26),
				["Background 3"] = Color3.fromRGB(12, 12, 16),
				["Border 1"] = Color3.fromRGB(6, 6, 8),
				["Border 2"] = Color3.fromRGB(32, 32, 40),
				["Border 3"] = Color3.fromRGB(46, 46, 58),
				["Selected Tab"] = Color3.fromRGB(20, 20, 28),
				["Unselected Tab"] = Color3.fromRGB(15, 15, 20),
				["Selected Section"] = Color3.fromRGB(24, 24, 32),
				["Unselected Section"] = Color3.fromRGB(18, 18, 24),
				["Section Background"] = Color3.fromRGB(20, 20, 28),
				["Option Background"] = Color3.fromRGB(28, 28, 36),
				["Active Text"] = Color3.fromRGB(245, 245, 255),
				["Inactive Text"] = Color3.fromRGB(160, 160, 175),
				["Warning Text"] = Color3.fromRGB(255, 100, 100),
			},
		},

		Aimware = {
			6,
			{
				["Accent"] = Color3.fromRGB(255, 50, 50),
				["Background 1"] = Color3.fromRGB(25, 25, 25),
				["Background 2"] = Color3.fromRGB(32, 32, 32),
				["Background 3"] = Color3.fromRGB(18, 18, 18),
				["Border 1"] = Color3.fromRGB(0, 0, 0),
				["Border 2"] = Color3.fromRGB(48, 48, 48),
				["Border 3"] = Color3.fromRGB(64, 64, 64),
				["Selected Tab"] = Color3.fromRGB(32, 32, 32),
				["Unselected Tab"] = Color3.fromRGB(25, 25, 25),
				["Selected Section"] = Color3.fromRGB(36, 36, 36),
				["Unselected Section"] = Color3.fromRGB(28, 28, 28),
				["Section Background"] = Color3.fromRGB(30, 30, 30),
				["Option Background"] = Color3.fromRGB(40, 40, 40),
				["Active Text"] = Color3.fromRGB(240, 240, 240),
				["Inactive Text"] = Color3.fromRGB(170, 170, 170),
				["Warning Text"] = Color3.fromRGB(255, 90, 90),
			},
		},
	}

	local Indexes = {
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
	}

	function ThemeManager:ApplyTheme(Theme, Button)
		if Theme == nil or Theme == "" then
			return self.Library["Notification"]("[ThemeManager]: Invalid Selection.", 3, Color3.fromRGB(255, 0, 0))
		end

		local CustomThemeData = self:GetCustomTheme(Theme)
		local Data = CustomThemeData or self.Presets[Theme][2]

		if not Data then
			return self.Library["Notification"]("[ThemeManager]: Theme does not exist.", 3, Color3.fromRGB(255, 0, 0))
		end

		for Index, Information in next, Data do
			local Color = Information
			local Mode = "NONE"

			if CustomThemeData then
				local Current = Information[1]
				Color = Color3.fromHSV(Current[1], Current[2], Current[3])
				Mode = Information[2]
			end

			self.Library.Flags["Colorpicker"][Index]["Functions"]:Set(Color, nil, Mode)
		end

		self:ThemeUpdate()

		return Button
				and self.Library["Notification"](string.format("[ThemeManager]: Loaded Theme %q", Theme), 3, "Accent")
			or nil
	end

	function ThemeManager:ThemeUpdate()
		for Index, Field in next, Indexes do
			if not self.Library.Flags or not self.Library.Flags["Colorpicker"][Field] then
				continue
			end

			do
				local Data = self.Library.Flags["Colorpicker"][Field]["Current"]
				self.Library.Theme[Field] = Color3.fromHSV(Data[1], Data[2], Data[3])
			end
		end

		self.Library.Functions:RefreshThemeRegistery()
	end

	function ThemeManager:LoadDefault()
		local Theme = "Default"
		local Content = isfile(string.format("%s/Default.txt", self.Folder))
			and readfile(string.format("%s/Default.txt", self.Folder))
		local Presets = true

		if Content then
			if self.Presets[Content] then
				Theme = Content
			elseif self:GetCustomTheme(Content) then
				Theme = Content
				Presets = false
			end
		elseif self.Presets["Fondra"] then
			Theme = "Fondra"
		end

		if self.Library.Flags["Dropdown"]["ThemeManagerCustomThemeList"] then
			if not Presets then
				self.Library.Flags["Dropdown"]["ThemeManagerCustomThemeList"]["Functions"]:Set({ Theme })
			else
				self.Library.Flags["Dropdown"]["ThemeManagerBuiltList"]["Functions"]:Set({ Theme })
			end
		end
	end

	function ThemeManager:LoadAutoloadConfig()
		self:LoadDefault()
	end

	function ThemeManager:SaveDefault(Theme)
		if Theme == nil or Theme == "" then
			return self.Library["Notification"]("[ThemeManager]: Invalid Selection.", 3, Color3.fromRGB(255, 0, 0))
		end

		writefile(string.format("%s/Default.txt", self.Folder), Theme)
		self.Library["Notification"](string.format("[ThemeManager]: Set default theme to %q", Theme), 3, "Accent")
	end

	function ThemeManager:RemoveDefault()
		if not isfile(string.format("%s/Default.txt", self.Folder)) then
			return self.Library["Notification"](
				"[ThemeManager]: There is no default theme.",
				3,
				Color3.fromRGB(255, 0, 0)
			)
		end

		delfile(string.format("%s/Default.txt", self.Folder))
		self.Library["Notification"]("[ThemeManager]: Removed the default theme.", 3, "Accent")
	end

	function ThemeManager:GetCustomTheme(Name)
		local Path = string.format("%s/%s.json", self.Folder, Name)

		if not isfile(Path) then
			return nil
		end

		local Data = readfile(Path)
		local Success, Decrypted = pcall(crypt.base64decode, Data)
		local Success, Decoded = pcall(Services.HttpService.JSONDecode, Services.HttpService, Decrypted)

		if not Success then
			return nil
		end

		return Decoded
	end

	function ThemeManager:OverrideCustomTheme(Name)
		if Name == nil or Name == "" then
			return self.Library["Notification"]("[ThemeManager]: Invalid Selection.", 3, Color3.fromRGB(255, 0, 0))
		end
		if not isfile(string.format("%s/%s.json", self.Folder, Name)) then
			return self.Library["Notification"]("[ThemeManager]: Theme does not exist", 3, Color3.fromRGB(255, 0, 0))
		end

		local Theme = {}
		for _, Field in next, Indexes do
			local Data = self.Library.Flags["Colorpicker"][Field]["Functions"]["Get"]()
			Theme[Field] = { Data.Current, Data.Mode }
		end

		local Success, Encoded = pcall(Services.HttpService.JSONEncode, Services.HttpService, Theme)
		local Success, Encrypted = pcall(crypt.base64encode, Encoded)

		writefile(string.format("%s/%s.json", self.Folder, Name), Encrypted)

		return self.Library["Notification"](string.format("[ThemeManager]: Overrided theme %q", Name), 3, "Accent")
	end

	function ThemeManager:SaveCustomTheme(Name)
		if Name:gsub(" ", "") == "" then
			return self.Library["Notification"](
				"[ThemeManager]: Invalid file name for theme. [Empty]",
				3,
				Color3.fromRGB(255, 0, 0)
			)
		end
		if isfile(string.format("%s/%s.json", self.Folder, Name)) then
			return self.Library["Notification"]("[ThemeManager]: Theme already exists.", 3, Color3.fromRGB(255, 0, 0))
		end

		local Theme = {}
		for _, Field in next, Indexes do
			local Data = self.Library.Flags["Colorpicker"][Field]["Functions"]["Get"]()
			Theme[Field] = { Data.Current, Data.Mode }
		end

		local Success, Encoded = pcall(Services.HttpService.JSONEncode, Services.HttpService, Theme)
		local Success, Encrypted = pcall(crypt.base64encode, Encoded)

		writefile(string.format("%s/%s.json", self.Folder, Name), Encrypted)

		return self.Library["Notification"](string.format("[ThemeManager]: Saved Theme %q", Name), 3, "Accent")
	end

	function ThemeManager:DeleteCustomTheme(Name)
		if Name == nil or Name == "" then
			return self.Library["Notification"]("[ThemeManager]: Invalid Selection.", 3, Color3.fromRGB(255, 0, 0))
		end
		if not isfile(string.format("%s/%s.json", self.Folder, Name)) then
			return self.Library["Notification"](
				"[ThemeManager]: Invalid file. [Does not exist]",
				3,
				Color3.fromRGB(255, 0, 0)
			)
		end

		delfile(string.format("%s/%s.json", self.Folder, Name))

		return self.Library["Notification"](string.format("[ThemeManager]: Deleted Theme %q", Name), 3, "Accent")
	end

	function ThemeManager:ReloadCustomThemes()
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

	function ThemeManager:SetLibrary(Library)
		self.Library = Library
	end

	function ThemeManager:BuildFolderTree()
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

	function ThemeManager:SetFolder(Folder)
		self.Folder = Folder
		self:BuildFolderTree()
	end

	function ThemeManager:BuildThemeSection(Tab)
		assert(self.Library, "Must set ThemeManager.Library first!")

		local Themes = Tab.Functions.Section({ Text = "Themes", Side = "LEFT" })
		for _, Name in next, Indexes do
			Themes.Functions:Label({ Text = Name }).Functions:Colorpicker({
				Color = self.Library.Theme[Name],
				Flag = Name,
				Callback = function()
					self:ThemeUpdate()
				end,
			})
		end

		local ThemesArray = {}

		for Name, Theme in next, self.Presets do
			table.insert(ThemesArray, Name)
		end

		table.sort(ThemesArray, function(A, B)
			return self.Presets[A][1] < self.Presets[B][1]
		end)

		Themes.Functions:Dropdown({
			Text = "Built In Themes",
			Flag = "ThemeManagerBuiltList",
			Options = ThemesArray,
			Current = { ThemesArray[1] },
			Minimum = 1,
			Maximum = 1,

			Callback = function(A)
				self:ApplyTheme(A[1])
			end,
		})

		Themes.Functions:Dropdown({
			Text = "Custom Themes List",
			Flag = "ThemeManagerCustomThemeList",

			Current = {},
			Options = self:ReloadCustomThemes(),

			Minimum = 1,
			Maximum = 1,
		})

		Themes.Functions:TextBox({
			Text = "",
			Placeholder = "Custom Theme Name",
			Flag = "ThemeManagerCustomThemeName",
		})

		Themes.Functions
			:Button({
				Text = "CREATE",
				Result = "CREATED",
				Callback = function()
					self:SaveCustomTheme(self.Library.Flags["TextBox"]["ThemeManagerCustomThemeName"]["Text"])

					self.Library.Flags["Dropdown"]["ThemeManagerCustomThemeList"]["Functions"]:Values(
						self:ReloadCustomThemes()
					)
					self.Library.Flags["Dropdown"]["ThemeManagerCustomThemeList"]["Functions"]:Set({})
				end,
			}).Functions
			:Button({
				Text = "DELETE",
				Result = "DELETED",
				Callback = function()
					self:DeleteCustomTheme(self.Library.Flags["Dropdown"]["ThemeManagerCustomThemeList"]["Current"][1])

					self.Library.Flags["Dropdown"]["ThemeManagerCustomThemeList"]["Functions"]:Values(
						self:ReloadCustomThemes()
					)
					self.Library.Flags["Dropdown"]["ThemeManagerCustomThemeList"]["Functions"]:Set({})
				end,
			})

		Themes.Functions
			:Button({
				Text = "LOAD",
				Result = "LOADED",
				Callback = function()
					self:ApplyTheme(self.Library.Flags["Dropdown"]["ThemeManagerCustomThemeList"]["Current"][1], true)
				end,
			}).Functions
			:Button({
				Text = "OVERWRITE",
				Result = "OVERWRITED",
				Callback = function()
					self:OverrideCustomTheme(
						self.Library.Flags["Dropdown"]["ThemeManagerCustomThemeList"]["Current"][1]
					)
				end,
			})

		Themes.Functions
			:Button({
				Text = "SAVE DEFAULT",
				Result = "DONE",
				Callback = function()
					self:SaveDefault(
						self.Library.Flags["Dropdown"]["ThemeManagerCustomThemeList"]["Current"][1]
							or self.Library.Flags["Dropdown"]["ThemeManagerBuiltList"]["Current"][1]
					)
				end,
			}).Functions
			:Button({
				Text = "REMOVE DEFAULT",
				Result = "DONE",
				Callback = function()
					self:RemoveDefault()
				end,
			})

		Themes.Functions:Button({
			Text = "REFRESH LIST",
			Result = "REFRESHED",
			Callback = function()
				self.Library.Flags["Dropdown"]["ThemeManagerCustomThemeList"]["Functions"]:Values(
					self:ReloadCustomThemes()
				)
				self.Library.Flags["Dropdown"]["ThemeManagerCustomThemeList"]["Functions"]:Set({})
			end,
		})
	end
end

getgenv().ThemeManager = ThemeManager

return ThemeManager
