local function printTime(action)
    local formatDate = os.date(" %I:%M %p", os.time())
    rconsoleprint(action..formatDate.."\n")
end

syn.queue_on_teleport(game:HttpGet("https://raw.githubusercontent.com/1POP1k33kxx0x0xz/misc/main/wins.lua"))
printTime(... and "Started" or "Joined")

local runService = game:GetService("RunService")
local players = game:GetService("Players")
local coreGui = game:GetService("CoreGui")
local teleportService = game:GetService("TeleportService")

local localPlayer = players.LocalPlayer

if not localPlayer then
    players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    localPlayer = players.LocalPlayer
end

local renderStepped = runService.RenderStepped
local wins = localPlayer:WaitForChild("leaderstats"):WaitForChild("Wins")
local prompts = coreGui:WaitForChild("RobloxPromptGui"):WaitForChild("promptOverlay")
local toggleBool, connections, finishValue, spawn1, spawn2, head, namecall, finished = true, {}, 200000

local function findCharacterPart()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    
    return character:WaitForChild("Head")
end

local function addWin()
    if finished then return end
    
    local currentSpawn = toggleBool and spawn1 or spawn2
    head = head:IsAncestorOf(game) and head or findCharacterPart()
    
    firetouchinterest(head, currentSpawn, 0)
    renderStepped:Wait()
    firetouchinterest(head, currentSpawn, 1)
    toggleBool = not toggleBool
    
    if wins.Value >= finishValue then
        finished = true
        
        for _,connection in pairs(connections) do
            connection:Disconnect()
        end
        
        localPlayer:Kick("Finished!")
        printTime("Finished")
    end
end

local function onKick()
    teleportService:Teleport(game.PlaceId)
    printTime("Teleport attempted")
end

for _,child in ipairs(workspace:GetChildren()) do
    if child:IsA("SpawnLocation") then
        if child:FindFirstChild("Won") then
            spawn1 = child
        else
            spawn2 = child
        end
    end
end

local blackGui = Instance.new("ScreenGui")
blackGui.DisplayOrder = -100
blackGui.IgnoreGuiInset = true
blackGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = blackGui

blackGui.Parent = coreGui
runService:Set3dRenderingEnabled(false)

connections.Kicked = prompts.ChildAdded:Connect(onKick)
connections.TeleportInitFailed = teleportService.TeleportInitFailed:Connect(onKick)
head = findCharacterPart()
connections.RenderStepped = renderStepped:Connect(addWin)
