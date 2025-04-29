-- Базовый ESP скрипт (для образовательных целей)

local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local function createESP(player)
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.OutlineColor = Color3.new(1, 1, 1)

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        else
            highlight:Destroy()
            connection:Disconnect()
        end
    end)

    player.CharacterRemoving:Connect(function()
        highlight:Destroy()
        connection:Disconnect()
    end)
end


for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            createESP(player)
        end)
    end
end


Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if player ~= Players.LocalPlayer then
            createESP(player)
        end
    end)
end)


