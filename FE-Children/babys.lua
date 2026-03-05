-- r6 only
-- babys by pwnmaster99
-- look up tutorials for the needed hats!
-- needed hats are 

-- Spidercola
-- Robox 
-- Roblox baseball cap
-- Crystalline Companion
-- Slime
-- Daniel Ricciardo 2021 Helmet - Closed Visor
-- Daniel Ricciardo 2021 Helmet - Open Visor
-- Lando Norris 2021 Helmet - Closed Visor
-- Lando Norris 2021 Helmet - Open Visor

local targetPlayerName = "Robloxannoysme28384" -- set this to who you want the babys to follow!



































local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local ws = game:GetService("Workspace")
local lp = plrs.LocalPlayer
local cam = ws.CurrentCamera





local botConfigs = {
    {
        attachments = {
            {mesh = "3164803967", height = 0, rotation = CFrame.Angles(0, 0, 0)}, -- Spidercola
        }
    },
    {
        attachments = {
            {mesh = "4819720316", height = 0.3, rotation = CFrame.Angles(0, 0, -0.25)}, -- Robox 
            {mesh = "71483350", height = 2.4, rotation = CFrame.Angles(0, 0, 0)}, -- Roblox baseball cap
        }
    },
    {
        attachments = {
            {mesh = "5548388222", height = 0.4, rotation = CFrame.Angles(0, 0, 0)}, -- Crystalline Companion
        }
    },
    {
        attachments = {
            {mesh = "6881003268", height = 0, rotation = CFrame.Angles(0, 0, 0)}, -- Slime
        }
    },
    {
        attachments = {
            {mesh = "8843497703", height = 0.4, rotation = CFrame.Angles(0, 0, 0)}, -- Daniel Ricciardo 2021 Helmet - Closed Visor
        }
    },
    {
        attachments = {
            {mesh = "8843559870", height = 0.4, rotation = CFrame.Angles(0, 0, 0)}, -- Daniel Ricciardo 2021 Helmet - Open Visor
        }
    },
    {
        attachments = {
            {mesh = "8843491450", height = 0.4, rotation = CFrame.Angles(0, 0, 0)}, -- Lando Norris 2021 Helmet - Closed Visor
        }
    },
    {
        attachments = {
            {mesh = "8843452599", height = 0.4, rotation = CFrame.Angles(0, 0, 0)}, -- Lando Norris 2021 Helmet - Open Visor
        }
    },
}

-- config (broken in some games for now, but it doesnt really matter)
local off = 3

-- sim radius
lp.SimulationRadius = math.huge
lp.MaximumSimulationRadius = math.huge
pcall(function() setsimulationradius(math.huge) end)
rs.Heartbeat:Connect(function()
    lp.SimulationRadius = math.huge
    lp.MaximumSimulationRadius = math.huge
end)

local bots = {}
for _, config in ipairs(botConfigs) do
    local part = Instance.new("Part")
    part.Size = Vector3.new(2, 1, 1)
    part.CFrame = CFrame.new(0, 10, 0)
    part.Anchored = false
    part.CanCollide = true
    part.Transparency = 1
    part.CustomPhysicalProperties = PhysicalProperties.new(1, 0.3, 0.5)
    part.Parent = ws
    table.insert(bots, {
        part = part,
        attachments = config.attachments,
        direction = Vector3.zero,
        lastChange = tick(),
        nextChange = math.random(1, 3),
        stopped = false,
        stopEnd = 0,
        canJump = true,
        spawned = false,
    })
end

local function setCam()
    if #bots > 0 then
        cam.CameraType = Enum.CameraType.Custom
        lp.CameraMode = Enum.CameraMode.Classic
        cam.CameraSubject = bots[1].part
    end
end
setCam()


local function applyOff(root)
    if off == 1 then
        root.CFrame = bots[1].part.CFrame * CFrame.new(0, 10000, 0)
    elseif off == 2 then
        root.CFrame = bots[1].part.CFrame * CFrame.new(0, 5, 10)
    elseif off == 3 then
        root.CFrame = Vector3.new(0,100,0)
    end
end

lp.CharacterAdded:Connect(function(c)
    local root = c:WaitForChild("HumanoidRootPart")
    applyOff(root)
    for _, v in next, c:GetDescendants() do
        if v:IsA("BasePart") and v.Name ~= "Handle" then
            rs.Heartbeat:Connect(function()
                v.Velocity = Vector3.new(0, 0, 100000) -- THIS IS THE NETLESS, CHANGE IT IF YOU WANT
            end)
        end
    end
    rs.Heartbeat:Wait()
    setCam()
end)

local spd = 16
local jp = 50
local jumpProb = 0.0022

-- rip permadeath
rs.Heartbeat:Connect(function()
    local c = lp.Character
    if c then
        local h = c:FindFirstChildOfClass("Humanoid")
        if h and h.Health > 0 then
            h.Health = 0
        end
    end
end)

rs.Heartbeat:Connect(function()
    local targetPlayer = plrs:FindFirstChild(targetPlayerName)
    if not targetPlayer then return end
    local targetChar = targetPlayer.Character
    if not targetChar then return end
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    local targetPos = targetRoot.Position
    local spawnAbove = targetPos + Vector3.new(0, 10, 0)

    for _, bot in ipairs(bots) do
        local part = bot.part


        if not bot.spawned then
            part.CFrame = CFrame.new(spawnAbove)
            part.AssemblyLinearVelocity = Vector3.zero
            bot.spawned = true
        end


        local distToSpawn = (part.Position - spawnAbove).Magnitude
        if distToSpawn > 30 then
            part.CFrame = CFrame.new(spawnAbove)
            part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end

        local targetFlat = Vector3.new(targetPos.X, part.Position.Y, targetPos.Z)
        local dist = (part.Position - targetFlat).Magnitude


        local currentTime = tick()
        if dist > 10 then
            bot.direction = (targetFlat - part.Position).Unit
            bot.stopped = false
        else

            if bot.stopped then
                if currentTime > bot.stopEnd then
                    bot.stopped = false
                    local angle = math.random() * 2 * math.pi
                    bot.direction = Vector3.new(math.cos(angle), 0, math.sin(angle))
                    bot.nextChange = math.random(1, 3)
                    bot.lastChange = currentTime
                else
                    bot.direction = Vector3.zero
                end
            else
                if currentTime - bot.lastChange > bot.nextChange then
                    bot.stopped = true
                    bot.stopEnd = currentTime + math.random(1, 6)
                    bot.direction = Vector3.zero
                end
            end
        end

        local vel = part.AssemblyLinearVelocity
        local y = vel.Y


        if math.random() < jumpProb and bot.canJump then
            y = jp
            bot.canJump = false
        end

        if bot.direction.Magnitude > 0 then
            local normDir = bot.direction.Unit
            local ang = math.atan2(-normDir.X, -normDir.Z)
            part.CFrame = CFrame.new(part.Position) * CFrame.Angles(0, ang, 0)
            part.AssemblyLinearVelocity = Vector3.new(normDir.X * spd, y, normDir.Z * spd)
        else
            part.AssemblyLinearVelocity = Vector3.new(0, y, 0)
        end

        local ray = Ray.new(part.Position, Vector3.new(0, -1.5, 0))
        local hit = ws:FindPartOnRay(ray, part)
        if hit then
            bot.canJump = true
        end
    end


    local c = lp.Character
    if not c then return end
    for _, bot in ipairs(bots) do
        for _, att in ipairs(bot.attachments) do
            for _, a in ipairs(c:GetChildren()) do
                if a:IsA("Accessory") then
                    local h = a:FindFirstChild("Handle")
                    local m = h and h:FindFirstChildOfClass("SpecialMesh")
                    if h and m and m.MeshId:find(att.mesh) then
                        h.CFrame = bot.part.CFrame * att.rotation * CFrame.new(0, att.height, 0)
                    end
                end
            end
        end
    end
end)


