-- SLAX HUB: San Diego Roleplay - Production Architecture Refactor with Balanced Maybach Hydraulics
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("__remotes")
local VehicleService = Remotes:WaitForChild("VehicleService")
local DevConsole = Remotes:WaitForChild("DeveloperConsole")
local BankRobbery = Remotes:WaitForChild("BankRobbery")
local ShopRobbery = Remotes:WaitForChild("ShopTillRobberyService")
local SmuggleService = Remotes:WaitForChild("SmuggleService")
local BorderService = Remotes:WaitForChild("BorderAuthorisationService")
local WorldBuyable = Remotes:WaitForChild("WorldBuyableItemService")
local AntiTp = Remotes:WaitForChild("AntiTp")
local function SafeInvoke(remote, ...)
if not remote then return end
local success, result = pcall(function(...)
if remote:IsA("RemoteEvent") then
remote:FireServer(...)
elseif remote:IsA("RemoteFunction") then
return remote:InvokeServer(...)
end
end, ...)
if not success then
warn("[SLAX HUB Error]: Remote invocation failed -> " .. tostring(remote.Name))
end
return result
end
local function GetCurrentVehicle()
local character = LocalPlayer.Character
if not character then return nil end
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid then return nil end
local seat = humanoid.SeatPart
if seat and seat:IsA("VehicleSeat") then
return seat.Parent
end
return nil
end
local success, WindUI = pcall(function()
return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end)
if not success or not WindUI then
warn("[SLAX HUB]: Failed to load WindUI framework.")
return
end
local Window = WindUI:CreateWindow({
Title = "SLAX HUB | San Diego Roleplay",
Icon = "rbxassetid://6031097225",
Author = "Senior Architecture Suite",
Folder = "SlaxHubSanDiego",
Size = UDim2.fromOffset(580, 480),
Theme = "Dark",
Acrylic = true,
Transparent = 0.25,
AccentColor = Color3.fromRGB(150, 0, 25),
})
local VehicleTab = Window:Tab({ Title = "Vehicle Physics", Icon = "car" })
local FarmTab = Window:Tab({ Title = "Safe Automation & Heists", Icon = "coins" })
local SmuggleTab = Window:Tab({ Title = "Autonomous Smuggling", Icon = "package" })
local UtilityTab = Window:Tab({ Title = "World & Dev", Icon = "globe" })
local State = {
SpeedMultiplier = 2,
MaybachActive = false,
MaybachSyncActive = false,
AutoFarmActive = false,
SmuggleActive = false,
GodDriveActive = false,
Connections = {}
}
if AntiTp then
for _, remote in ipairs(AntiTp:GetChildren()) do
if remote:IsA("RemoteEvent") then
remote.OnClientEvent:Connect(function()
if remote.Name == "ApplyVehicleRollback" or remote.Name == "ApplyRollbackCFrame" then
local ack = AntiTp:FindFirstChild("AckVehicleRollback")
if ack then SafeInvoke(ack) end
end
end)
end
end
end
VehicleTab:Section({ Title = "Vehicle Enhancements" })
VehicleTab:Input({
Title = "Max Speed Multiplier",
Desc = "Sets custom speed multiplier.",
Default = "2",
Placeholder = "Enter multiplier...",
Callback = function(text)
local value = tonumber(text)
if not value then return end
State.SpeedMultiplier = value
local vehicle = GetCurrentVehicle()
if vehicle and DevConsole then
SafeInvoke(DevConsole:FindFirstChild("SetCurrentVehicleEnginePitchMultiplier"), value)
SafeInvoke(DevConsole:FindFirstChild("SetCurrentVehicleEngineVolumeMultiplier"), 2.0)
end
end
})
VehicleTab:Toggle({
Title = "Maybach E-ABC Rocking Mode (Side-to-Side)",
Desc = "Simulates real Mercedes-Maybach independent corner rocking.",
Default = false,
Callback = function(state)
State.MaybachActive = state
if State.Connections.Maybach then
State.Connections.Maybach:Disconnect()
State.Connections.Maybach = nil
end
if State.MaybachActive then
local timeElapsed = 0
State.Connections.Maybach = RunService.Heartbeat:Connect(function(dt)
timeElapsed = timeElapsed + dt
local vehicle = GetCurrentVehicle()
if vehicle then
local primaryPart = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
if primaryPart then
local bounce = math.sin(timeElapsed * 6.5) * 1.5
local pitch = math.cos(timeElapsed * 4.875) * 0.4
local roll = math.sin(timeElapsed * 3.25) * 0.3
primaryPart.AssemblyAngularVelocity = Vector3.new(pitch, 0, roll)
primaryPart.AssemblyLinearVelocity = primaryPart.AssemblyLinearVelocity + Vector3.new(0, bounce * 0.2, 0)
SafeInvoke(DevConsole:FindFirstChild("SetCurrentVehicleHealth"), 99999)
end
end
end)
end
end
})
VehicleTab:Toggle({
Title = "Maybach Synchronized Full-Body Bounce (Balanced Ground Heave)",
Desc = "Unified balanced up-and-down hydraulic heave keeping the car firmly on the ground.",
Default = false,
Callback = function(state)
State.MaybachSyncActive = state
if State.Connections.MaybachSync then
State.Connections.MaybachSync:Disconnect()
State.Connections.MaybachSync = nil
end
if State.MaybachSyncActive then
local timeElapsed = 0
State.Connections.MaybachSync = RunService.Heartbeat:Connect(function(dt)
timeElapsed = timeElapsed + dt
local vehicle = GetCurrentVehicle()
if vehicle then
local primaryPart = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
if primaryPart then
-- قوة صعود ونزول متوازنة ومدروسة لتبقى السيارة على الأرض
local heaveForce = math.sin(timeElapsed * 7.0) * 2.2
primaryPart.AssemblyLinearVelocity = Vector3.new(
primaryPart.AssemblyLinearVelocity.X,
primaryPart.AssemblyLinearVelocity.Y + heaveForce,
primaryPart.AssemblyLinearVelocity.Z
)
-- الحفاظ على استقامة السيارة بدون ميلان
primaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
SafeInvoke(DevConsole:FindFirstChild("SetCurrentVehicleHealth"), 99999)
end
end
end)
end
end
})
VehicleTab:Button({
Title = "Vehicle Jump Impulse",
Desc = "Launches vehicle vertically.",
Callback = function()
local vehicle = GetCurrentVehicle()
if not vehicle then return end
SafeInvoke(VehicleService:FindFirstChild("VehicleNudgeImpulse"), Vector3.new(0, 150, 0))
local primaryPart = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
if primaryPart then
primaryPart.AssemblyLinearVelocity = primaryPart.AssemblyLinearVelocity + Vector3.new(0, 150, 0)
end
end
})
VehicleTab:Toggle({
Title = "God Drive / Unstuck Loop",
Desc = "Keeps vehicle health maxed and unstucks automatically.",
Default = false,
Callback = function(state)
State.GodDriveActive = state
if State.Connections.GodDrive then
State.Connections.GodDrive:Disconnect()
State.Connections.GodDrive = nil
end
if State.GodDriveActive then
State.Connections.GodDrive = RunService.Heartbeat:Connect(function()
local vehicle = GetCurrentVehicle()
if vehicle then
SafeInvoke(DevConsole:FindFirstChild("SetCurrentVehicleHealth"), 99999)
SafeInvoke(VehicleService:FindFirstChild("UnstuckVehicle"), vehicle)
end
end)
end
end
})
FarmTab:Section({ Title = "Anti-Ban Safe Automated Heists" })
FarmTab:Toggle({
Title = "Humanized Safe Auto-Farm",
Desc = "Loops bank trolleys and shop tills with randomized organic delays.",
Default = false,
Callback = function(state)
State.AutoFarmActive = state
if State.Connections.AutoFarm then
task.cancel(State.Connections.AutoFarm)
State.Connections.AutoFarm = nil
end
if State.AutoFarmActive then
State.Connections.AutoFarm = task.spawn(function()
while State.AutoFarmActive do
if ShopRobbery then
pcall(function()
SafeInvoke(ShopRobbery:FindFirstChild("ReserveOpenTill") or ShopRobbery:FindFirstChild("ReserveTill"))
task.wait(math.random(0.4, 0.8))
SafeInvoke(ShopRobbery:FindFirstChild("BeginOpenTillLooting") or ShopRobbery:FindFirstChild("BeginTill"))
task.wait(math.random(0.4, 0.8))
SafeInvoke(ShopRobbery:FindFirstChild("GrabTillCash"))
end)
end
task.wait(math.random(3.5, 6.0))
if BankRobbery then
pcall(function()
SafeInvoke(BankRobbery:FindFirstChild("StartRobTrolley"))
task.wait(math.random(0.5, 1.0))
SafeInvoke(BankRobbery:FindFirstChild("BeginRobTrolley"))
task.wait(math.random(0.5, 1.0))
SafeInvoke(BankRobbery:FindFirstChild("GrabTrolleyCash"))
end)
end
task.wait(math.random(12, 20))
end
end)
end
end
})
SmuggleTab:Section({ Title = "Ground Autopilot Smuggling" })
SmuggleTab:Toggle({
Title = "Autonomous Smuggler Ground Route",
Desc = "Drives vehicle along ground via terrain clamping, clears border, and sells goods.",
Default = false,
Callback = function(state)
State.SmuggleActive = state
if State.Connections.Smuggle then
task.cancel(State.Connections.Smuggle)
State.Connections.Smuggle = nil
end
if State.SmuggleActive then
State.Connections.Smuggle = task.spawn(function()
local function DriveToPoint(targetCFrame)
local vehicle = GetCurrentVehicle()
while vehicle and State.SmuggleActive do
local primaryPart = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
if not primaryPart then break end
local currentPos = primaryPart.Position
local targetPos = targetCFrame.Position
local distance = (Vector3.new(targetPos.X, currentPos.Y, targetPos.Z) - currentPos).Magnitude
if distance < 8 then break end
local direction = (targetPos - currentPos).Unit
local rayParams = RaycastParams.new()
rayParams.FilterType = RaycastParams.FilterType.Exclude
rayParams.FilterDescendantsInstances = {vehicle}
local result = workspace:Raycast(currentPos + Vector3.new(0, 5, 0), Vector3.new(0, -30, 0), rayParams)
local groundY = result and result.Position.Y + 2 or currentPos.Y
local targetGroundPos = Vector3.new(targetPos.X, groundY, targetPos.Z)
primaryPart.CFrame = CFrame.new(currentPos:Lerp(targetGroundPos, 0.1), targetPos)
primaryPart.AssemblyLinearVelocity = direction * (25 * State.SpeedMultiplier)
RunService.Heartbeat:Wait()
end
end
while State.SmuggleActive do
local vehicle = GetCurrentVehicle()
if vehicle then
pcall(function()
if WorldBuyable then
SafeInvoke(WorldBuyable, "MonaLisa")
end
end)
task.wait(1.5)
local startPos = vehicle.PrimaryPart.Position
DriveToPoint(CFrame.new(startPos + Vector3.new(150, 0, 100)))
pcall(function()
if BorderService then
SafeInvoke(BorderService:FindFirstChild("GrantEntry"))
end
end)
task.wait(2.0)
DriveToPoint(CFrame.new(startPos + Vector3.new(350, 0, 250)))
pcall(function()
if SmuggleService then
SafeInvoke(SmuggleService:FindFirstChild("SellSmuggledGoods"))
end
end)
end
task.wait(math.random(15, 25))
end
end)
end
end
})
SmuggleTab:Button({
Title = "Instant Sell Smuggled Goods",
Desc = "Triggers smuggle sell remote instantly.",
Callback = function()
if SmuggleService then
SafeInvoke(SmuggleService:FindFirstChild("SellSmuggledGoods"))
end
end
})
UtilityTab:Section({ Title = "Server & World Utility" })
UtilityTab:Button({
Title = "Unlock Luxury Beach House",
Desc = "Grants beach house assets via developer console.",
Callback = function()
if DevConsole then
SafeInvoke(DevConsole:FindFirstChild("UnlockLuxuryBeachHouse"))
end
end
})
UtilityTab:Button({
Title = "Clear All Local Vehicles",
Desc = "Cleans up stuck vehicles.",
Callback = function()
if DevConsole then
SafeInvoke(DevConsole:FindFirstChild("ClearAllVehicles"))
end
end
})
WindUI:Notify({
Title = "SLAX HUB Initialized",
Content = "Balanced Maybach hydraulics applied successfully.",
Duration = 3,
})
