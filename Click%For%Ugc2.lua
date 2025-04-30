local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(newChar)
    character = newChar
end)

local Settings = {
    AutoClick = {
        Enabled = false,
        Delay = 0.5,
        MaxClicks = 200,
        PauseTime = 15,
        LastClick = 0
    },
    AutoSpin = {
        Enabled = false,
        Delay = 30,
        LastSpin = 0
    },
    GUI = {
        Enabled = true,
        Keybind = Enum.KeyCode.RightShift,
        Position = UDim2.new(0.8, 0, 0.5, 0),
        ThemeColor = Color3.fromRGB(0, 170, 255)
    }
}

local Stats = {
    TotalClicks = 0,
    TotalSpins = 0,
    LastReward = "None"
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoClickUGC2GUI"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = Settings.GUI.Position
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Settings.GUI.ThemeColor
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 40, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "UGC 2 Auto Farmer"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Icon = Instance.new("ImageLabel")
Icon.Name = "Icon"
Icon.Size = UDim2.new(0, 30, 0, 30)
Icon.Position = UDim2.new(0, 5, 0, 5)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxassetid://106900523989296"
Icon.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TopBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    script:Destroy()
end)

local Tabs = Instance.new("Frame")
Tabs.Name = "Tabs"
Tabs.Size = UDim2.new(1, 0, 0, 40)
Tabs.Position = UDim2.new(0, 0, 0, 40)
Tabs.BackgroundTransparency = 1
Tabs.Parent = MainFrame

local ClickerTab = Instance.new("TextButton")
ClickerTab.Name = "ClickerTab"
ClickerTab.Size = UDim2.new(0.5, 0, 1, 0)
ClickerTab.Position = UDim2.new(0, 0, 0, 0)
ClickerTab.BackgroundColor3 = Settings.GUI.ThemeColor
ClickerTab.Text = "Auto Click"
ClickerTab.TextColor3 = Color3.fromRGB(255, 255, 255)
ClickerTab.TextSize = 14
ClickerTab.Font = Enum.Font.GothamBold
ClickerTab.Parent = Tabs

local SpinTab = Instance.new("TextButton")
SpinTab.Name = "SpinTab"
SpinTab.Size = UDim2.new(0.5, 0, 1, 0)
SpinTab.Position = UDim2.new(0.5, 0, 0, 0)
SpinTab.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SpinTab.Text = "Auto Spin"
SpinTab.TextColor3 = Color3.fromRGB(200, 200, 200)
SpinTab.TextSize = 14
SpinTab.Font = Enum.Font.GothamBold
SpinTab.Parent = Tabs

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -80)
ContentFrame.Position = UDim2.new(0, 0, 0, 80)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local ClickerContent = Instance.new("Frame")
ClickerContent.Name = "ClickerContent"
ClickerContent.Size = UDim2.new(1, 0, 1, 0)
ClickerContent.BackgroundTransparency = 1
ClickerContent.Visible = true
ClickerContent.Parent = ContentFrame

local ClickerToggle = Instance.new("TextButton")
ClickerToggle.Name = "ClickerToggle"
ClickerToggle.Size = UDim2.new(0.9, 0, 0, 40)
ClickerToggle.Position = UDim2.new(0.05, 0, 0, 10)
ClickerToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
ClickerToggle.Text = "Auto Click: OFF"
ClickerToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
ClickerToggle.TextSize = 16
ClickerToggle.Font = Enum.Font.GothamBold
ClickerToggle.Parent = ClickerContent

local ClickerDelay = Instance.new("TextBox")
ClickerDelay.Name = "ClickerDelay"
ClickerDelay.Size = UDim2.new(0.9, 0, 0, 30)
ClickerDelay.Position = UDim2.new(0.05, 0, 0, 60)
ClickerDelay.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ClickerDelay.PlaceholderText = "Click Delay (seconds)"
ClickerDelay.Text = tostring(Settings.AutoClick.Delay)
ClickerDelay.TextColor3 = Color3.fromRGB(255, 255, 255)
ClickerDelay.TextSize = 14
ClickerDelay.Font = Enum.Font.Gotham
ClickerDelay.Parent = ClickerContent

local ClickerStats = Instance.new("TextLabel")
ClickerStats.Name = "ClickerStats"
ClickerStats.Size = UDim2.new(0.9, 0, 0, 80)
ClickerStats.Position = UDim2.new(0.05, 0, 0, 100)
ClickerStats.BackgroundTransparency = 1
ClickerStats.Text = "Total Clicks: 0\nClicks/Min: 0\nStatus: Idle"
ClickerStats.TextColor3 = Color3.fromRGB(200, 200, 200)
ClickerStats.TextSize = 14
ClickerStats.TextXAlignment = Enum.TextXAlignment.Left
ClickerStats.TextYAlignment = Enum.TextYAlignment.Top
ClickerStats.Font = Enum.Font.Gotham
ClickerStats.Parent = ClickerContent

local SpinContent = Instance.new("Frame")
SpinContent.Name = "SpinContent"
SpinContent.Size = UDim2.new(1, 0, 1, 0)
SpinContent.BackgroundTransparency = 1
SpinContent.Visible = false
SpinContent.Parent = ContentFrame

local SpinToggle = Instance.new("TextButton")
SpinToggle.Name = "SpinToggle"
SpinToggle.Size = UDim2.new(0.9, 0, 0, 40)
SpinToggle.Position = UDim2.new(0.05, 0, 0, 10)
SpinToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
SpinToggle.Text = "Auto Spin: OFF"
SpinToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
SpinToggle.TextSize = 16
SpinToggle.Font = Enum.Font.GothamBold
SpinToggle.Parent = SpinContent

local SpinDelay = Instance.new("TextBox")
SpinDelay.Name = "SpinDelay"
SpinDelay.Size = UDim2.new(0.9, 0, 0, 30)
SpinDelay.Position = UDim2.new(0.05, 0, 0, 60)
SpinDelay.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
SpinDelay.PlaceholderText = "Spin Delay (seconds)"
SpinDelay.Text = tostring(Settings.AutoSpin.Delay)
SpinDelay.TextColor3 = Color3.fromRGB(255, 255, 255)
SpinDelay.TextSize = 14
SpinDelay.Font = Enum.Font.Gotham
SpinDelay.Parent = SpinContent

local SpinStats = Instance.new("TextLabel")
SpinStats.Name = "SpinStats"
SpinStats.Size = UDim2.new(0.9, 0, 0, 80)
SpinStats.Position = UDim2.new(0.05, 0, 0, 100)
SpinStats.BackgroundTransparency = 1
SpinStats.Text = "Total Spins: 0\nLast Reward: None\nStatus: Idle"
SpinStats.TextColor3 = Color3.fromRGB(200, 200, 200)
SpinStats.TextSize = 14
SpinStats.TextXAlignment = Enum.TextXAlignment.Left
SpinStats.TextYAlignment = Enum.TextYAlignment.Top
SpinStats.Font = Enum.Font.Gotham
SpinStats.Parent = SpinContent

ClickerTab.MouseButton1Click:Connect(function()
    ClickerContent.Visible = true
    SpinContent.Visible = false
    ClickerTab.BackgroundColor3 = Settings.GUI.ThemeColor
    SpinTab.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
end)

SpinTab.MouseButton1Click:Connect(function()
    ClickerContent.Visible = false
    SpinContent.Visible = true
    ClickerTab.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    SpinTab.BackgroundColor3 = Settings.GUI.ThemeColor
end)

ClickerToggle.MouseButton1Click:Connect(function()
    Settings.AutoClick.Enabled = not Settings.AutoClick.Enabled
    if Settings.AutoClick.Enabled then
        ClickerToggle.Text = "Auto Click: ON"
        ClickerToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        ClickerToggle.Text = "Auto Click: OFF"
        ClickerToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

SpinToggle.MouseButton1Click:Connect(function()
    Settings.AutoSpin.Enabled = not Settings.AutoSpin.Enabled
    if Settings.AutoSpin.Enabled then
        SpinToggle.Text = "Auto Spin: ON"
        SpinToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        SpinToggle.Text = "Auto Spin: OFF"
        SpinToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

ClickerDelay.FocusLost:Connect(function()
    local num = tonumber(ClickerDelay.Text)
    if num and num > 0 then
        Settings.AutoClick.Delay = num
    else
        ClickerDelay.Text = tostring(Settings.AutoClick.Delay)
    end
end)

SpinDelay.FocusLost:Connect(function()
    local num = tonumber(SpinDelay.Text)
    if num and num > 0 then
        Settings.AutoSpin.Delay = num
    else
        SpinDelay.Text = tostring(Settings.AutoSpin.Delay)
    end
end)

local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

local function findClickableObjects()
    local clickables = {}
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ClickDetector") and (obj.Parent.Name:lower():find("click") 
           or obj.Parent.Name:lower():find("ugc") 
           or obj.Parent.Name:lower():find("button")) then
            table.insert(clickables, obj.Parent)
        end
    end
    
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and (obj.Name:lower():find("click") 
           or obj.Name:lower():find("reward") 
           or obj.Name:lower():find("spin")) then
            table.insert(clickables, obj)
        end
    end
    
    return clickables
end

local function performClick(target)
    if target:IsA("BasePart") or target:IsA("Model") then
        local clickDetector = target:FindFirstChildOfClass("ClickDetector")
        if clickDetector then
            fireclickdetector(clickDetector)
            return true
        end
    elseif target:IsA("RemoteEvent") then
        target:FireServer()
        return true
    end
    return false
end

local function findWheel()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("wheel") 
           or obj.Name:lower():find("spin") 
           or obj.Name:lower():find("reward")) then
            return obj
        end
    end
    return nil
end

local function performSpin()
    local wheel = findWheel()
    if wheel then
        local spinButton = wheel:FindFirstChild("SpinButton") or wheel:FindFirstChildOfClass("ClickDetector")
        
        if spinButton then
            if performClick(spinButton.Parent or spinButton) then
                return true
            end
        end
        
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") and (obj.Name:lower():find("spin") 
               or obj.Name:lower():find("wheel")) then
                obj:FireServer()
                return true
            end
        end
    end
    return false
end

local lastUpdate = tick()
local clicksThisMinute = 0

coroutine.wrap(function()
    while true do
        if tick() - lastUpdate >= 60 then
            lastUpdate = tick()
            clicksThisMinute = 0
        end
        
        if Settings.AutoClick.Enabled then
            local clickables = findClickableObjects()
            
            if #clickables > 0 then
                ClickerStats.Text = string.format("Total Clicks: %d\nClicks/Min: %d\nStatus: Clicking...", Stats.TotalClicks, clicksThisMinute)
                
                for _, target in ipairs(clickables) do
                    if not Settings.AutoClick.Enabled then break end
                    
                    if performClick(target) then
                        Stats.TotalClicks = Stats.TotalClicks + 1
                        clicksThisMinute = clicksThisMinute + 1
                        task.wait(Settings.AutoClick.Delay)
                    end
                end
            else
                ClickerStats.Text = string.format("Total Clicks: %d\nClicks/Min: %d\nStatus: No clickables found", Stats.TotalClicks, clicksThisMinute)
                task.wait(5)
            end
        else
            ClickerStats.Text = string.format("Total Clicks: %d\nClicks/Min: %d\nStatus: Idle", Stats.TotalClicks, clicksThisMinute)
            task.wait(1)
        end
    end
end)()

coroutine.wrap(function()
    while true do
        if Settings.AutoSpin.Enabled then
            SpinStats.Text = string.format("Total Spins: %d\nLast Reward: %s\nStatus: Spinning...", Stats.TotalSpins, Stats.LastReward)
            
            if performSpin() then
                Stats.TotalSpins = Stats.TotalSpins + 1
                SpinStats.Text = string.format("Total Spins: %d\nLast Reward: %s\nStatus: Waiting...", Stats.TotalSpins, Stats.LastReward)
                task.wait(Settings.AutoSpin.Delay)
            else
                SpinStats.Text = string.format("Total Spins: %d\nLast Reward: %s\nStatus: Wheel not found", Stats.TotalSpins, Stats.LastReward)
                task.wait(5)
            end
        else
            SpinStats.Text = string.format("Total Spins: %d\nLast Reward: %s\nStatus: Idle", Stats.TotalSpins, Stats.LastReward)
            task.wait(1)
        end
    end
end)()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Settings.GUI.Keybind then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("UGC 2 Auto Farmer loaded! Press RightShift to toggle GUI.")
