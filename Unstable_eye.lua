local P = game:GetService("Players")
local TS = game:GetService("TweenService")
local L = game:GetService("Lighting")
local LP = P.LocalPlayer
local C = workspace.CurrentCamera
local char = LP.Character or LP.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local originalWS = hum.WalkSpeed

local tool = Instance.new("Tool")
tool.Name = "Unstable Eye"
tool.RequiresHandle = false
tool.Parent = LP.Backpack

local CD = false
local CDT = 15

tool.Activated:Connect(function()
    if CD then return end
    CD = true

    local url = "https://raw.githubusercontent.com/XQZ-official/Musics/main/Unstable_eyeSFX.mp3"
local fileName = "hnngh! I see youuu~"

if not isfile(fileName) then
    writefile(fileName, game:HttpGet(url))
end

local sound = Instance.new("Sound")
sound.SoundId = getcustomasset(fileName)
sound.Volume = 1.5
sound.Looped = false
sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

sound:Play()
sound.Ended:Connect(function() end)

hum.WalkSpeed = 0
task.wait(0.8)

hum.WalkSpeed = 27
task.delay(7.5, function()
    hum.WalkSpeed = originalWS
end)

    local HL = {}

    local B = Instance.new("BlurEffect")
    B.Size = 0
    B.Parent = L

    local oFOV = C.FieldOfView
    local zIn = TS:Create(C, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        FieldOfView = oFOV - 15
    })

    local bIn = TS:Create(B, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Size = 60 })
    bIn:Play()
    zIn:Play()

    task.wait(0.7)

    local maxD = 250
    local cPos = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character.HumanoidRootPart.Position

    if cPos then
        for _, plr in pairs(P:GetPlayers()) do
            if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local tPos = plr.Character.HumanoidRootPart.Position
                local dist = (tPos - cPos).Magnitude

                if dist <= maxD then
                    if not plr.Character:FindFirstChild("ESPHighlight") then
                        local h = Instance.new("Highlight")
                        h.Name = "ESPHighlight"
                        h.FillColor = Color3.new(1, 1, 0)
                        h.OutlineColor = Color3.new(0.7, 0.7, 0)
                        h.FillTransparency = 1
                        h.OutlineTransparency = 1
                        h.Adornee = plr.Character
                        h.Parent = plr.Character

                        table.insert(HL, h)
                    end
                end
            end
        end
    end

    for _, h in pairs(HL) do
        local tIn = TS:Create(h, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            FillTransparency = 0.5,
            OutlineTransparency = 0
        })
        tIn:Play()
    end

    task.wait(4)

    for _, h in pairs(HL) do
        local tOut = TS:Create(h, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            FillTransparency = 1,
            OutlineTransparency = 1
        })
        tOut:Play()
        tOut.Completed:Once(function()
            h:Destroy()
        end)
    end

    local bOut = TS:Create(B, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { Size = 0 })
    local zOut = TS:Create(C, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { FieldOfView = oFOV })

    task.delay(3, function()
        bOut:Play()
        zOut:Play()
        bOut.Completed:Once(function()
            B:Destroy()
        end)
    end)

    task.delay(CDT, function()
        CD = false
    end)
end)