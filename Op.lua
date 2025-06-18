-- 📜 Delta Executor Check
if getexecutorname and getexecutorname() ~= "Delta" then
    game.Players.LocalPlayer:Kick("Delta Executor Required")
    return
end

-- 🖼️ GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Button = Instance.new("TextButton")
local Status = Instance.new("TextLabel")

ScreenGui.Name = "ChestFarmGui"
ScreenGui.Parent = game.CoreGui

Frame.Name = "MainFrame"
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderSizePixel = 2
Frame.Position = UDim2.new(0.7, 0, 0.3, 0)
Frame.Size = UDim2.new(0, 200, 0, 120)

Status.Name = "Status"
Status.Parent = Frame
Status.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Status.Position = UDim2.new(0, 0, 0, 0)
Status.Size = UDim2.new(1, 0, 0.4, 0)
Status.Text = "Auto Chest: OFF"
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.TextScaled = true

Button.Name = "ToggleButton"
Button.Parent = Frame
Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Button.Position = UDim2.new(0.1, 0, 0.5, 0)
Button.Size = UDim2.new(0.8, 0, 0.4, 0)
Button.Text = "Toggle Auto Chest"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextScaled = true

-- 💡 Chest Farming Logic
local Farming = false
local function GetChests()
    local chests = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("MeshPart") and v.Name:lower():match("chest") then
            table.insert(chests, v)
        end
    end
    return chests
end

local function TweenTo(pos)
    local TweenService = game:GetService("TweenService")
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local info = TweenInfo.new((hrp.Position - pos).Magnitude / 150, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, info, {CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))})
    tween:Play()
    tween.Completed:Wait()
end

local function ChestFarmLoop()
    while Farming and task.wait(0.5) do
        local chests = GetChests()
        if #chests > 0 then
            for _, chest in pairs(chests) do
                if not Farming then break end
                TweenTo(chest.Position)
                wait(0.3)
            end
        end
    end
end

-- 🖱️ Button Click
Button.MouseButton1Click:Connect(function()
    Farming = not Farming
    Status.Text = "Auto Chest: " .. (Farming and "ON" or "OFF")
    if Farming then
        task.spawn(ChestFarmLoop)
    end
end)

-- 💬 Chat Command Toggle
game.Players.LocalPlayer.Chatted:Connect(function(msg)
    msg = msg:lower()
    if msg == "!chest on" then
        Farming = true
        Status.Text = "Auto Chest: ON"
        task.spawn(ChestFarmLoop)
    elseif msg == "!chest off" then
        Farming = false
        Status.Text = "Auto Chest: OFF"
    elseif msg == "!black" then
        Frame.Visible = not Frame.Visible
    end
end)
