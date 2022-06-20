spawn(function()
for i,v in pairs(game:GetDescendants()) do
if v.ClassName == "Sound" then
    v.Volume = 0
end
end
local hi = Instance.new("Sound")
hi.Name = "Sound"
hi.SoundId = "http://www.roblox.com/asset/?id=7027640335"
hi.Volume = 10
hi.Looped = true
hi.archivable = false
hi.Parent = game.Workspace

hi:Play()
wait(0.1)
while true do
end
end)
