--[[
SLAX HUB - Car Jump & Movable Lock Control
Features:
- Interactive Modern UI (SLAX HUB Theme)
- Car Jump Button (for clearing walls/obstacles)
- Movable Lock/Unlock Toggle Button (locks/unlocks car jump state)
]]
-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
-- Clean up any existing SLAX HUB UI to prevent duplicates
pcall(function()
if CoreGui:FindFirstChild("SLAX_CAR_JUMP_GUI") then
CoreGui.SLAX_CAR_JUMP_GUI:Destroy()
end
end)
-- Create ScreenGui with fallback parent if CoreGui is restricted
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SLAX_CAR_JUMP_GUI"
ScreenGui.ResetOnSpawn = false
pcall(function()
ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
-- Main Frame (Draggable Main Hub)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 220)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame
-- UI Stroke for border glow effect
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame
-- Top Bar / Title
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
TitleBar.Text = "  SLAX HUB // CAR JUMP CONTROL"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.TextSize = 14
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Parent = MainFrame
local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar
-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 48)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame
-- Car Jump Button (قفز السيارة من فوق السور)
local CarJumpButton = Instance.new("TextButton")
CarJumpButton.Size = UDim2.new(1, -20, 0, 40)
CarJumpButton.Position = UDim2.new(0, 10, 0, 80)
CarJumpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
CarJumpButton.Text = "🚗 CAR JUMP (CLEAR WALL)"
CarJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CarJumpButton.TextSize = 13
CarJumpButton.Font = Enum.Font.GothamBold
CarJumpButton.Parent = MainFrame
local CarJumpCorner = Instance.new("UICorner")
CarJumpCorner.CornerRadius = UDim.new(0, 8)
CarJumpCorner.Parent = CarJumpButton
-- Lock / Unlock State Button (زر مربع متحرك للتحكم في قفل وضعية القفز)
local LockStateButton = Instance.new("TextButton")
LockStateButton.Size = UDim2.new(1, -20, 0, 40)
LockStateButton.Position = UDim2.new(0, 10, 0, 130)
LockStateButton.BackgroundColor3 = Color3.fromRGB(50, 180, 90)
LockStateButton.Text = "🔒 LOCK STATE: UNLOCKED"
LockStateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockStateButton.TextSize = 13
LockStateButton.Font = Enum.Font.GothamBold
LockStateButton.Parent = MainFrame
local LockCorner = Instance.new("UICorner")
LockCorner.CornerRadius = UDim.new(0, 8)
LockCorner.Parent = LockStateButton
-- Draggable Movable Control Helper for Lock State Button (زر متحرك بحرية داخل النافذة أو الشاشة)
local isDraggingLockBtn = false
local dragInput, dragStart, startPos
LockStateButton.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
isDraggingLockBtn = true
dragStart = input.Position
startPos = LockStateButton.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
isDraggingLockBtn = false
end
end)
end
end)
UserInputService.InputChanged:Connect(function(input)
if isDraggingLockBtn and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - dragStart
LockStateButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)
-- Credit Label
local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1, 0, 0, 20)
Credit.Position = UDim2.new(0, 0, 1, -20)
Credit.BackgroundTransparency = 1
Credit.Text = "Powered by SLAX HUB"
Credit.TextColor3 = Color3.fromRGB(100, 100, 100)
Credit.TextSize = 10
Credit.Font = Enum.Font.GothamItalic
Credit.Parent = MainFrame
-- States
local isLockedState = false
-- Helper to get RootPart or Vehicle Part
local function getActiveVehicleOrRoot()
local character = LocalPlayer.Character
if character then
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid and humanoid.SeatPart then
local vehicleModel = humanoid.SeatPart.Parent
if vehicleModel and vehicleModel:IsA("Model") then
local primaryPart = vehicleModel.PrimaryPart or vehicleModel:FindFirstChild("HumanoidRootPart") or vehicleModel:FindFirstChildWhichIsA("BasePart")
return primaryPart, vehicleModel
end
end
local rootPart = character:FindFirstChild("HumanoidRootPart")
if rootPart then
return rootPart, character
end
end
return nil, nil
end
-- Car Jump Logic (قفز السيارة من فوق السور)
local function triggerCarJump()
if isLockedState then
StatusLabel.Text = "Status: State is LOCKED! Jump ignored."
return
end
local targetPart, model = getActiveVehicleOrRoot()
if targetPart then
pcall(function()	
targetPart.AssemblyLinearVelocity = targetPart.AssemblyLinearVelocity + Vector3.new(0, 85, 0) + (targetPart.CFrame.LookVector * 40)
StatusLabel.Text = "Status: Car Jump Executed! Cleared wall."
end)
else
StatusLabel.Text = "Status: No active vehicle/character found."
end
end
-- Lock / Unlock Button Toggle Logic
LockStateButton.MouseButton1Click:Connect(function()
isLockedState = not isLockedState
if isLockedState then
LockStateButton.Text = "🔒 LOCK STATE: LOCKED"
LockStateButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
StatusLabel.Text = "Status: Car Jump is now LOCKED."
else
LockStateButton.Text = "🔓 LOCK STATE: UNLOCKED"
LockStateButton.BackgroundColor3 = Color3.fromRGB(50, 180, 90)
StatusLabel.Text = "Status: Car Jump is now UNLOCKED."
end
end)
-- Car Jump Button Event
CarJumpButton.MouseButton1Click:Connect(function()
triggerCarJump()
end)
print("[SLAX HUB] Car Jump & Lock Controller Loaded Successfully!")
