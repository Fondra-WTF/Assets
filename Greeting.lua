Fondra.Functions.DownloadAsset("Sounds/Temporary.mp3", "https://github.com/Fondra-Hub/Assets/raw/main/Sounds/Temporary.mp3")

local Sound = Instance.new("Sound")
Sound.TimePosition = 0.5
Sound.Parent = workspace
Sound.Volume = 5
Sound.SoundId = Fondra.Functions.GetAsset("Sounds/Temporary.mp3")
Sound:Play()

Fondra.Services.Debris:AddItem(Sound, 5)
