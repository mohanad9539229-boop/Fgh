-- SLAX HUB: San Diego Roleplay - WindUI Glassmorphism Interface (Maybach E-ABC Bounce & Autonomous Ground Smuggling Farm)
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("__remotes")
local VehicleService = Remotes:FindFirstChild("VehicleService")
local DevConsole = Remotes:FindFirstChild("DeveloperConsole")
local BankRobbery = Remotes:FindFirstChild("BankRobbery")
local ShopRobbery = Remotes:FindFirstChild("ShopTillRobberyService")
local SmuggleService = Remotes:FindFirstChild("SmuggleService")
local BorderService = Remotes:FindFirstChild("BorderAuthorisationService")
local WorldBuyable = Remotes:FindFirstChild("WorldBuyableItemService")
-- Safe Remote Execution Utility
local function SafeInvoke(remote, ...)
if remote then
if remote:IsA("RemoteEvent") then
remote:FireServer(...)
elseif remote:IsA("RemoteFunction") then
return remote:InvokeServer(...)
end
end
end
-- Get Current Vehicle Function
local function GetCurrentVehicle()
local character = LocalPlayer.Character
if character and character:FindFirstChild("Humanoid") then
local seat = character.Humanoid.SeatPart
if seat and seat:IsA("VehicleSeat") then
return seat.Parent
end
end
return nil
end
-- Load WindUI Library (Safe Fallback / Dynamic Loader)
local success, WindUI = pcall(function()
return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end)
if not success or not WindUI then
warn("[SLAX HUB]: Failed to load WindUI.")
return
end
-- Create Window with Dark Red Glassmorphism Aesthetics
local Window = WindUI:CreateWindow({
Title = "SLAX HUB | San Diego Roleplay",
Icon = "rbxassetid://6031097225",
Author = "Advanced Exploitation Suite",
Folder = "SlaxHubSanDiego",
Size = UDim2.fromOffset(580, 480),
Theme = "Dark",
Acrylic = true,
Transparent = 0.25,
AccentColor = Color3.fromRGB(150, 0, 25),
})
-- Create Tabs
local VehicleTab = Window:Tab({ Title = "Vehicle Physics", Icon = "car" })
local FarmTab = Window:Tab({ Title = "Safe Automation & Heists", Icon = "coins" })
local SmuggleTab = Window:Tab({ Title = "Autonomous Smuggling", Icon = "package" })
local UtilityTab = Window:Tab({ Title = "World & Dev", Icon = "globe" })
-- State Variables
local _G_GodDriveActive = false
local _G_CurrentSpeedMultiplier = 2
local _G_MaybachDanceActive = false
local _G_AutoFarmActive = false
local _G_SmuggleAutoActive = false
local _G_DanceFrequency = 6.5
local _G_DanceAmplitude = 3.2
-- VEHICLE TAB: Speed & Authentic Maybach E-ABC Suspension Bounce
VehicleTab:Section({ Title = "Vehicle Enhancements" })
VehicleTab:Input({
Title = "Max Speed Multiplier (Text)",
Desc = "Type custom speed multiplier and press enter.",
Default = "2",
Placeholder = "Enter multiplier...",
Callback = function(text)
local value = tonumber(text)
if not value then return end
_G_CurrentSpeedMultiplier = value
local vehicle = GetCurrentVehicle()
if not vehicle then return end
if DevConsole then
local setPitch = DevConsole:FindFirstChild("SetCurrentVehicleEnginePitchMultiplier")
local setVolume = DevConsole:FindFirstChild("SetCurrentVehicleEngineVolumeMultiplier")
if setPitch then SafeInvoke(setPitch, value) end
if setVolume then SafeInvoke(setVolume, 2.0) end
end
local primaryPart = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
if primaryPart then
primaryPart.AssemblyLinearVelocity = primaryPart.AssemblyLinearVelocity * value
end
WindUI:Notify({ Title = "Speed Applied", Content = "Multiplier set to: " .. tostring(value), Duration = 2 })
end
})
VehicleTab:Toggle({
Title = "Maybach E-ABC Active Bounce / Rocking Mode",
Desc = "Simulates real Mercedes-Maybach independent corner bouncing.",
Default = false,
Callback = function(state)
_G_MaybachDanceActive = state
if _G_MaybachDanceConnection then
_G_MaybachDanceConnection:Disconnect()
_G_MaybachDanceConnection = nil
end
if _G_MaybachDanceActive then
local timeElapsed = 0
_G_MaybachDanceConnection = RunService.Heartbeat:Connect(function(dt)
timeElapsed = timeElapsed + dt
local vehicle = GetCurrentVehicle()
if vehicle then
local primaryPart = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
if primaryPart then
local verticalBounce = math.sin(timeElapsed * _G_DanceFrequency) * _G_DanceAmplitude
local pitchOscillation = math.cos(timeElapsed * (_G_DanceFrequency * 0.75)) * (_G_DanceAmplitude * 0.25)
local rollOscillation = math.sin(timeElapsed * (_G_DanceFrequency * 0.5)) * (_G_DanceAmplitude * 0.2)
primaryPart.AssemblyAngularVelocity = Vector3.new(pitchOscillation, 0, rollOscillation)
primaryPart.AssemblyLinearVelocity = primaryPart.AssemblyLinearVelocity + Vector3.new(0, verticalBounce * 0.4, 0)
if DevConsole and DevConsole:FindFirstChild("SetCurrentVehicleHealth") then
SafeInvoke(DevConsole.SetCurrentVehicleHealth, 99999)
end
end
end
end)
WindUI:Notify({ Title = "Maybach E-ABC Engaged", Content = "Active body control rocking mode active.", Duration = 2 })
else
WindUI:Notify({ Title = "Maybach E-ABC Disengaged", Content = "Suspension normalized.", Duration = 2 })
end
end
})
VehicleTab:Button({
Title = "Vehicle Jump Impulse",
Desc = "Launches your vehicle straight up.",
Callback = function()
local vehicle = GetCurrentVehicle()
if not vehicle then return end
if VehicleService then
local nudgeImpulse = VehicleService:FindFirstChild("VehicleNudgeImpulse")
if nudgeImpulse then SafeInvoke(nudgeImpulse, Vector3.new(0, 150, 0)) end
end
local primaryPart = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
if primaryPart then
primaryPart.AssemblyLinearVelocity = primaryPart.AssemblyLinearVelocity + Vector3.new(0, 150, 0)
end
end
})
VehicleTab:Toggle({
Title = "God Drive / Unstuck Loop",
Desc = "Keeps vehicle health maxed out and unstucks automatically.",
Default = false,
Callback = function(state)
_G_GodDriveActive = state
if _G_GodDriveConnection then
_G_GodDriveConnection:Disconnect()
_G_GodDriveConnection = nil
end
if _G_GodDriveActive then
_G_GodDriveConnection = RunService.Heartbeat:Connect(function()
local vehicle = GetCurrentVehicle()
if vehicle then
if DevConsole and DevConsole:FindFirstChild("SetCurrentVehicleHealth") then
SafeInvoke(DevConsole.SetCurrentVehicleHealth, 99999)
end
if VehicleService and VehicleService:FindFirstChild("UnstuckVehicle") then
SafeInvoke(VehicleService.UnstuckVehicle, vehicle)
end
end
end)
end
end
})
-- FARM TAB: Safe Automation & Heists
FarmTab:Section({ Title = "Anti-Ban Safe Automated Heists" })
FarmTab:Toggle({
Title = "Humanized Safe Auto-Farm (Anti-Ban)",
Desc = "Loops bank and shop till robberies with random organic delays.",
Default = false,
Callback = function(state)
_G_AutoFarmActive = state
if _G_AutoFarmThread then
task.cancel(_G_AutoFarmThread)
_G_AutoFarmThread = nil
end
if _G_AutoFarmActive then
_G_AutoFarmThread = task.spawn(function()
while _G_AutoFarmActive do
if ShopRobbery then
pcall(function()
local reserve = ShopRobbery:FindFirstChild("ReserveTill")
local beginTill = ShopRobbery:FindFirstChild("BeginTill")
local grabCash = ShopRobbery:FindFirstChild("GrabTillCash")
if reserve then SafeInvoke(reserve) end
task.wait(math.random(0.4, 0.8))
if beginTill then SafeInvoke(beginTill) end
task.wait(math.random(0.4, 0.8))
if grabCash then SafeInvoke(grabCash) end
end)
end
task.wait(math.random(3.5, 6.0))
if BankRobbery then
pcall(function()
local startRob = BankRobbery:FindFirstChild("StartRobTrolley")
local beginRob = BankRobbery:FindFirstChild("BeginRobTrolley")
local grabCash = BankRobbery:FindFirstChild("GrabTrolleyCash")
if startRob then SafeInvoke(startRob) end
task.wait(math.random(0.5, 1.0))
if beginRob then SafeInvoke(beginRob) end
task.wait(math.random(0.5, 1.0))
if grabCash then SafeInvoke(grabCash) end
end)
end
task.wait(math.random(12, 20))
end
end)
WindUI:Notify({ Title = "Safe Auto-Farm", Content = "Anti-ban humanized loop enabled.", Duration = 3 })
else
WindUI:Notify({ Title = "Safe Auto-Farm", Content = "Automation halted.", Duration = 3 })
end
end
})
-- SMUGGLE TAB: Autonomous Ground Driving & Mona Lisa / Smuggling Loop
SmuggleTab:Section({ Title = "Ground Autopilot Smuggling (Anti-Fly Bypass)" })
SmuggleTab:Toggle({
Title = "Autonomous Mona Lisa / Smuggler Ground Route",
Desc = "Drives your vehicle along the ground via surface-clamped checkpoints, auto-clears border, and sells goods.",
Default = false,
Callback = function(state)
_G_SmuggleAutoActive = state
if _G_SmuggleThread then
task.cancel(_G_SmuggleThread)
_G_SmuggleThread = nil
end
if _G_SmuggleAutoActive then
_G_SmuggleThread = task.spawn(function()
-- Ground-clamped waypoint navigation algorithm to prevent flying flags
local function DriveToPoint(targetCFrame)
local vehicle = GetCurrentVehicle()
while vehicle and _G_SmuggleAutoActive do
local primaryPart = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
if not primaryPart then break end
local currentPos = primaryPart.Position
local targetPos = targetCFrame.Position
local distance = (Vector3.new(targetPos.X, currentPos.Y, targetPos.Z) - currentPos).Magnitude
if distance < 8 then break end
local direction = (targetPos - currentPos).Unit
-- Ground raycast to ensure vehicle stays locked to terrain height (avoids flying/clipping flags)
local raycastParams = RaycastParams.new()
raycastParams.FilterType = RaycastParams.FilterType.Exclude
raycastParams.FilterDescendantsInstances = {vehicle}
local raycastResult = workspace:Raycast(currentPos + Vector3.new(0, 5, 0), Vector3.new(0, -30, 0), raycastParams)
local groundY = raycastResult and raycastResult.Position.Y + 2 or currentPos.Y
local targetGroundPos = Vector3.new(targetPos.X, groundY, targetPos.Z)
primaryPart.CFrame = CFrame.new(currentPos:Lerp(targetGroundPos, 0.1), targetPos)
primaryPart.AssemblyLinearVelocity = direction * (25 * _G_CurrentSpeedMultiplier)
RunService.Heartbeat:Wait()
end
end
while _G_SmuggleAutoActive do
local vehicle = GetCurrentVehicle()
if vehicle then
-- Step 1: Purchase Smuggled Item / Art piece (Mona Lisa) via WorldBuyable or Smuggle Service
pcall(function()
if WorldBuyable then
SafeInvoke(WorldBuyable.PurchaseWorldBuyableItem, "MonaLisa")
end
end)
task.wait(1.5)
-- Step 2: Ground Autopilot to Border / Inspection Point
-- Using safe ground-clamped intermediate vectors
local startPos = vehicle.PrimaryPart.Position
DriveToPoint(CFrame.new(startPos + Vector3.new(150, 0, 100)))
-- Step 3: Trigger Border Clearance automatically
pcall(function()
if BorderService then
local grantEntry = BorderService:FindFirstChild("GrantEntry")
if grantEntry then SafeInvoke(grantEntry) end
end
end)
task.wait(2.0)
-- Step 4: Drive to Smuggling Delivery / Sell Point
DriveToPoint(CFrame.new(startPos + Vector3.new(350, 0, 250)))
-- Step 5: Execute Sell Smuggled Goods Remote
pcall(function()
if SmuggleService then
local sellGoods = SmuggleService:FindFirstChild("SellSmuggledGoods")
if sellGoods then SafeInvoke(sellGoods) end
end
end)
WindUI:Notify({ Title = "Smuggle Run", Content = "Successfully completed ground smuggling loop cycle.", Duration = 3 })
else
WindUI:Notify({ Title = "Autopilot Warning", Content = "Please enter a vehicle to start ground smuggling.", Duration = 3 })
end
-- Organic randomized delay between smuggling runs to remain undetected
task.wait(math.random(15, 25))
end
end)
WindUI:Notify({ Title = "Autonomous Smuggling", Content = "Ground autopilot smuggling loop enabled.", Duration = 3 })
else
WindUI:Notify({ Title = "Autonomous Smuggling", Content = "Smuggling automation stopped.", Duration = 3 })
end
end
})
SmuggleTab:Button({
Title = "Instant Sell Smuggled Goods (Manual)",
Desc = "Triggers the smuggle sell remote instantly.",
Callback = function()
if SmuggleService then
local sellGoods = SmuggleService:FindFirstChild("SellSmuggledGoods")
if sellGoods then
SafeInvoke(sellGoods)
WindUI:Notify({ Title = "Smuggling", Content = "Sell smuggled goods remote executed.", Duration = 3 })
end
end
end
})
-- UTILITY TAB: World & Developer Controls
UtilityTab:Section({ Title = "Server & World Utility" })
UtilityTab:Button({
Title = "Unlock Luxury Beach House",
Desc = "Forces developer console to grant beach house assets.",
Callback = function()
if DevConsole then
local unlockHouse = DevConsole:FindFirstChild("UnlockLuxuryBeachHouse")
if unlockHouse then
SafeInvoke(unlockHouse)
WindUI:Notify({ Title = "Developer Utility", Content = "Beach house asset unlock command sent.", Duration = 3 })
end
end
end
})
UtilityTab:Button({
Title = "Clear All Local Vehicles",
Desc = "Cleans up stuck or lagging vehicles via DevConsole.",
Callback = function()
if DevConsole then
local clearVehicles = DevConsole:FindFirstChild("ClearAllVehicles")
if clearVehicles then
SafeInvoke(clearVehicles)
WindUI:Notify({ Title = "Cleanup", Content = "All vehicles cleared from client replication.", Duration = 3 })
end
end
end
})
WindUI:Notify({
Title = "SLAX HUB Initialized",
Content = "San Diego Roleplay loaded with Ground Smuggling Autopilot.",
Duration = 4,
})
