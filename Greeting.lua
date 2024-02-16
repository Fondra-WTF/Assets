-- Ignore this is for fondra.

Fondra.Functions.DownloadAsset("Sounds/WTF.mp3", "https://github.com/Fondra-Hub/Assets/raw/main/Sounds/WTF.wav")

local Sound = Instance.new("Sound")
Sound.Parent = nil
Sound.Volume = 2.5
Sound.SoundId = Fondra.Functions.GetAsset("Sounds/WTF.mp3")
Sound:Play()

Fondra.Services.Debris:AddItem(Sound, 5)
