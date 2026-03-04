-- made by pwnmaster99, all you need is the spidercola hat
-- roblox.com/redeem, and enter "SPIDERCOLA"
-- dont skid, but realisticly this script is shit, who would steal it
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local ws = game:GetService("Workspace")
local uis = game:GetService("UserInputService")

local lp = plrs.LocalPlayer
local cam = ws.CurrentCamera

-- config (this is useless)
local off = 1

-- sim radius
lp.SimulationRadius = math.huge
lp.MaximumSimulationRadius = math.huge
pcall(function() setsimulationradius(math.huge) end)

rs.Heartbeat:Connect(function()
	lp.SimulationRadius = math.huge
	lp.MaximumSimulationRadius = math.huge
end)


local part = Instance.new("Part")
part.Size = Vector3.new(2,1,1)
part.CFrame = CFrame.new(0,10,0)
part.Anchored = false
part.CanCollide = true
part.Transparency = 1
part.CustomPhysicalProperties = PhysicalProperties.new(1,0.3,0.5)
part.Parent = ws


local function setCam()
	cam.CameraType = Enum.CameraType.Custom
	lp.CameraMode = Enum.CameraMode.Classic
	cam.CameraSubject = part
end

setCam()

-- respawn
local function applyOff(root)
	if off == 1 then
		root.CFrame = part.CFrame * CFrame.new(0,10000,0)
	elseif off == 2 then
		root.CFrame = part.CFrame * CFrame.new(0,5,10)
	elseif off == 3 then
		root.CFrame = part.CFrame * CFrame.new(0,-20,10)
	end
end

lp.CharacterAdded:Connect(function(c)
	local root = c:WaitForChild("HumanoidRootPart")
	applyOff(root)

	for _,v in next, c:GetDescendants() do
		if v:IsA("BasePart") and v.Name ~= "Handle" then
			rs.Heartbeat:Connect(function()
				v.Velocity = Vector3.new(0,1000,0) -- THIS IS THE NETLESS, CHANGE IT IF YOU WANT
			end)
		end
	end

	rs.Heartbeat:Wait()
	setCam()
end)

local k = {W=false,A=false,S=false,D=false,Sp=false}
local spd = 16
local jp = 50
local canJump = true

uis.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.W then k.W=true end
	if i.KeyCode == Enum.KeyCode.A then k.A=true end
	if i.KeyCode == Enum.KeyCode.S then k.S=true end
	if i.KeyCode == Enum.KeyCode.D then k.D=true end
	if i.KeyCode == Enum.KeyCode.Space then k.Sp=true end
end)

uis.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.W then k.W=false end
	if i.KeyCode == Enum.KeyCode.A then k.A=false end
	if i.KeyCode == Enum.KeyCode.S then k.S=false end
	if i.KeyCode == Enum.KeyCode.D then k.D=false end
	if i.KeyCode == Enum.KeyCode.Space then k.Sp=false end
end)

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
	local look = cam.CFrame.LookVector
	local flat = Vector3.new(look.X,0,look.Z)
	if flat.Magnitude == 0 then return end

	flat = flat.Unit
	local ang = math.atan2(-flat.X,-flat.Z)

	part.CFrame = CFrame.new(part.Position) * CFrame.Angles(0,ang,0)

	local dir = Vector3.zero
	if k.W then dir += flat end
	if k.S then dir -= flat end

	local right = Vector3.new(-flat.Z,0,flat.X)
	if k.A then dir -= right end
	if k.D then dir += right end

	local vel = part.AssemblyLinearVelocity
	local y = vel.Y

	if k.Sp and canJump then
		y = jp
		canJump = false
	end

	if dir.Magnitude > 0 then
		dir = dir.Unit
		part.AssemblyLinearVelocity = Vector3.new(dir.X*spd,y,dir.Z*spd)
	else
		part.AssemblyLinearVelocity = Vector3.new(0,y,0)
	end

	local ray = Ray.new(part.Position, Vector3.new(0,-1.5,0))
	local hit = ws:FindPartOnRay(ray, part)
	if hit then
		canJump = true
	end

	-- spidercola
	local c = lp.Character
	if not c then return end

	for _,a in ipairs(c:GetChildren()) do
		if a:IsA("Accessory") then
			local h = a:FindFirstChild("Handle")
			local m = h and h:FindFirstChildOfClass("SpecialMesh")
			if h and m and m.MeshId:find("3164803967") then
				h.CFrame = part.CFrame
			end
		end
	end
end)

print("spidercola by pwnmaster99")
