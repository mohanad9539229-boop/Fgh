-- SLAX HUB: San Diego Roleplay - WindUI Glassmorphism Interface (Dark Red Theme with Speed Input)
-- Production-Ready Code for Maximum Vehicle Control and Automation
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("__remotes")
local VehicleService = Remotes:FindFirstChild("VehicleService")
local DevConsole = Remotes:FindFirstChild("DeveloperConsole")
local BankRobbery = Remotes:FindFirstChild("BankRobbery")
local ShopRobbery = Remotes:FindFirstChild("ShopTillRobberyService")
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
warn("[SLAX HUB]: Failed to load WindUI. Please check internet connection or environment support.")
return
end
-- Create Window with Dark Red Glassmorphism Aesthetics
local Window = WindUI:CreateWindow({
Title = "SLAX HUB | San Diego Roleplay",
Icon = "rbxassetid://6031097225",
Author = "Advanced Exploitation Suite",
Folder = "SlaxHubSanDiego",
Size = UDim2.fromOffset(580, 420),
Theme = "Dark",
Acrylic = true, -- Glassmorphism Blur Effect
Transparent = 0.25, -- Glass Transparency
AccentColor = Color3.fromRGB(150, 0, 25), -- Deep Dark Red Accent
})
-- Create Tabs
local VehicleTab = Window:Tab({ Title = "Vehicle Physics", Icon = "car" })
local FarmTab = Window:Tab({ Title = "Automation & Heists", Icon = "coins" })
local UtilityTab = Window:Tab({ Title = "World & Dev", Icon = "globe" })
-- State Variables
local _G_GodDriveActive = false
local _G_CurrentSpeedMultiplier = 2
-- VEHICLE TAB: Speed & Jump Controls
VehicleTab:Section({ Title = "Vehicle Enhancements" })
VehicleTab:Input({
Title = "Max Speed Multiplier (Text)",
Desc = "Type any custom speed multiplier (e.g., 5, 10, 50) and press enter.",
Default = "2",
Placeholder = "Enter multiplier...",
Callback = function(text)
local value = tonumber(text)
if not value then
WindUI:Notify({ Title = "Invalid Input", Content = "Please enter a valid numeric value.", Duration = 3 })
return
end
_G_CurrentSpeedMultiplier = value
local vehicle = GetCurrentVehicle()
if not vehicle then
WindUI:Notify({ Title = "Speed Hub", Content = "Speed saved! Enter a vehicle to apply.", Duration = 2 })
return
end
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
VehicleTab:Button({
Title = "Vehicle Jump Impulse",
Desc = "Launches your vehicle straight up into the air.",
Callback = function()
local vehicle = GetCurrentVehicle()
if not vehicle then return end
if VehicleService then
local nudgeImpulse = VehicleService:FindFirstChild("VehicleNudgeImpulse")
if nudgeImpulse then
SafeInvoke(nudgeImpulse, Vector3.new(0, 150, 0))
end
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
-- FARM TAB: Automation & Robberies
FarmTab:Section({ Title = "Automated Heists" })
FarmTab:Button({
Title = "Execute Bank Trolley Robbery",
Desc = "Instantly reserves and grabs cash from the bank trolley.",
Callback = function()
if BankRobbery then
local startRob = BankRobbery:FindFirstChild("StartRobTrolley")
local beginRob = BankRobbery:FindFirstChild("BeginRobTrolley")
local grabCash = BankRobbery:FindFirstChild("GrabTrolleyCash")
if startRob then SafeInvoke(startRob) end
if beginRob then SafeInvoke(beginRob) end
if grabCash then SafeInvoke(grabCash) end
WindUI:Notify({ Title = "Bank Heist", Content = "Executed bank trolley exploit sequence.", Duration = 3 })
end
end
})
FarmTab:Button({
Title = "Execute Shop Till Robbery",
Desc = "Instantly loops through till reserves and loots cash.",
Callback = function()
if ShopRobbery then
local reserve = ShopRobbery:FindFirstChild("ReserveTill")
local beginTill = ShopRobbery:FindFirstChild("BeginTill")
local grabCash = ShopRobbery:FindFirstChild("GrabTillCash")
if reserve then SafeInvoke(reserve) end
if beginTill then SafeInvoke(beginTill) end
if grabCash then SafeInvoke(grabCash) end
WindUI:Notify({ Title = "Shop Robbery", Content = "Looted cash registers successfully.", Duration = 3 })
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
Content = "San Diego Roleplay interface loaded successfully with text input.",
Duration = 4,
})
