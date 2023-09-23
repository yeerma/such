assert(_G.IsRunning == false, "Error: Already Running")
_G.IsRunning = true

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PowerUps = nil
local MoneyThing = false
local PlayerGui = LocalPlayer.PlayerGui

if PlayerGui.HUD then
    PowerUps = PlayerGui.HUD:FindFirstChild("PowerUps")
end

local function SendNotification(Title, Text, Duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = Title,
        Text = Text,
        Icon = "",
        Duration = Duration or 1.5
    })
end

SendNotification("Hello,", "Make Sure You Shoot A Zombie First", 4)

task.spawn(function()
    local Zaza = 0

    task.spawn(function()
        local OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local Args = {...}
            if getnamecallmethod() == "FireServer" and self.Name == "Damage" then
                Zaza = Args[2]
            end
            return OldNamecall(self, ...)
        end)
    end)

    local function Cash(Number)
        local DamageEvent = workspace.Baddies.Zombie.Humanoid.Damage
        for i = 1, Number do
            local Args = {
                BodyPart = workspace.Baddies.Zombie.HeadBox,
                Force = 0,
                GibPower = 0,
                Damage = 0
            }
            DamageEvent:FireServer(Args, Zaza)
        end
        MoneyThing = true
    end

    while true do
        task.wait()
        if Zaza ~= 0 or (LocalPlayer.Character and LocalPlayer.Character.Humanoid.Health <= 0) then
            SendNotification("Hello,", "You Can Use It Via !points")
            break
        end
    end

    LocalPlayer.CharacterAdded:Connect(function(Character)
        if not MoneyThing then
            SendNotification("Hello,", "Shoot A Zombie First.")
        end
    end)

    LocalPlayer.Chatted:Connect(function(Message)
        local Command, Amount = string.find(Message, "^(%S+)%s?(%d+)$")

        if Command == "!points" and Amount then
            local Points = tonumber(Amount)
            task.spawn(function()
                local Baddies = workspace.Baddies
                if Baddies:FindFirstChild("Zombie") then
                    if Zaza ~= 0 then
                        if PowerUps and PowerUps:FindFirstChild("InstaKill") then
                            SendNotification("Error", "You can't use it on instakill")
                        else
                            Cash(Points / (PowerUps and PowerUps:FindFirstChild("DoublePoints") and 20 or 10))
                        end
                    end
                else
                    SendNotification("Error", "No Zombies Are Found")
                end
            end)
        end
    end)
end)
