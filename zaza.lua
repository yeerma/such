if not _G.isRunning then
    _G.isRunning = true
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PowerUps
local hasShotZombie = false

if LocalPlayer.PlayerGui:FindFirstChild("HUD") then
    PowerUps = LocalPlayer.PlayerGui.HUD:FindFirstChild("PowerUps")
end

game.StarterGui:SetCore("SendNotification", {
    Title = "Hey Bro",
    Text = "Remember, You Gotta Shoot A Zombie First.",
    Icon = "",
    Duration = 1.5,
})
    spawn(function()
        local zaza = 0

        spawn(function()
            OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args = {...}
                if getnamecallmethod() == "FireServer" and self.Name == "Damage" then
                    zaza = args[2]
                end
                return OldNamecall(self, ...)
            end)
        end)

        local function themcash(number)
            for i = 1, number do
                local args = {
                    [1] = {
                        ["BodyPart"] = workspace.Baddies.Zombie.HeadBox,
                        ["Force"] = 0,
                        ["GibPower"] = 0,
                        ["Damage"] = 0
                    },
                    [2] = zaza
                }

                workspace.Baddies.Zombie.Humanoid.Damage:FireServer(unpack(args))
            end
            hasShotZombie = true
        end

        while true do
            wait()
            if zaza ~= 0 or (LocalPlayer.Character and LocalPlayer.Character.Humanoid.Health <= 0) then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Hey Bro",
                    Text = "You can use it now by saying !points number",
                    Icon = "",
                    Duration = 1.5,
                })
                break
            end
        end

        LocalPlayer.CharacterAdded:Connect(function(character)
            if not hasShotZombie then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Hey Bro",
                    Text = "Remember, You Gotta Shoot A Zombie First.",
                    Icon = "",
                    Duration = 1.5,
                })
            end
        end)

        LocalPlayer.Chatted:Connect(function(message)
            local _, _, command, amount = string.find(message, "^(%S+)%s?(%d+)$")

            if command == "!points" and amount then
                local points = tonumber(amount)
                spawn(function()
                    if workspace.Baddies:FindFirstChild("Zombie") then
                        if zaza ~= 0 then
                            if PowerUps and PowerUps:FindFirstChild("InstaKill") then
                                game.StarterGui:SetCore("SendNotification", {
                                    Title = "Hey Bro",
                                    Text = "You can't use it on instakill",
                                    Icon = "",
                                    Duration = 1.5,
                                })
                            else
                                if PowerUps and PowerUps:FindFirstChild("DoublePoints") then
                                    themcash(points / 20)
                                else
                                    themcash(points / 10)
                                end
                            end
                        end
                    else
                        game.StarterGui:SetCore("SendNotification", {
                            Title = "Hey Bro",
                            Text = "There are no zombies",
                            Icon = "",
                            Duration = 1.5,
                        })
                    end
                end)
            end
        end)
    end)
end
