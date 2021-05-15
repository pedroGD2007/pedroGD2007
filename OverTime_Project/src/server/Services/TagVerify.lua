local Knit = require(game:GetService("ReplicatedStorage").Knit)

local TweenService = game:GetService("TweenService")
local collections = game:GetService("CollectionService")
local debris = game:GetService("Debris")

local GameTagService = Knit.CreateService {
    Name = "GameTagService";
    Client = {};
}

GameTagService.TagEsteira = "Esteira"
GameTagService.TagJumpPad = "JumpPad"
GameTagService.TagTeleport = "Tp"
GameTagService.TagDeadly = "deadly"
GameTagService.TagAnimation = "Animation"
GameTagService.TagFinally = "Final"

local connections = {}

local function onInstanceAdded(object)
    local tag
    if collections:HasTag(object,GameTagService.TagEsteira) then
        local Velocity = 30

        if object:IsA("BasePart") then
            connections[object] = function()
                while true do
                    object.Texture.OffsetStudsV += -0.2
                    object.Velocity = object.CFrame.LookVector * Velocity
                    wait()
                end 
            end
        end
    elseif collections:HasTag(object,GameTagService.TagJumpPad) then
        if object:IsA("BasePart") then
                connections[object] = object.Touched:Connect(function(part)
                if not object.Name == "Base" then
                    for _,v in pairs(object.Parent:GetChildren()) do
                        if v.Name == "Base"then
                            object = v
                        end
                    end
                end 
                if object.Name == "Base" then
                    local Root = part:FindFirstChild("HumanoidRootPart") or part.Parent:FindFirstChild("HumanoidRootPart")
                    local new = Instance.new("BodyVelocity")
                    new.MaxForce = Vector3.new(9999999,999999999999999999999999999999999999999999,9999999)
                    new.Velocity = Vector3.new(0,50,0) + object.CFrame.LookVector * 72
                    new.Parent = Root
                    debris:AddItem(new,0.5)
                end
            end)
        end
    elseif collections:HasTag(object,GameTagService.TagDeadly) then
        if object:IsA("BasePart") then
            local Can
            connections[object] = object.Touched:Connect(function(part)
                if not Can then
                    Can = true

                    local Humanoid = part.Parent:FindFirstChild("Humanoid") or part:FindFirstChild("Humanoid")

                    if object.Name == "HitKill" then
                        Humanoid:TakeDamage(100)
                    else
                        Humanoid:TakeDamage(10)
                    end
                    
                    wait(0.2)
                    Can = false
                end
            end)
        end
    elseif collections:HasTag(object,GameTagService.TagAnimation) then
        if object:IsA("BasePart") then
            connections[object] = function()
                local GetAttributes = {object:GetAttribute("Position"),object:GetAttribute("Orientation"),object:GetAttribute("Delay"),object:GetAttribute("Time"),object:GetAttribute("Reapeat"),object:GetAttribute("Reverse")}
		
                local info = TweenInfo.new(
                    GetAttributes[4],
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut,
                    GetAttributes[5],
                    GetAttributes[6],
                    GetAttributes[3]
                )
                
                local goal = {
                    Position = GetAttributes[1] + object.Position,
                    Orientation = GetAttributes[2] + object.Orientation
                }
                
                TweenService:Create(object,info,goal):Play()
            end
        end
    elseif collections:HasTag(object,GameTagService.TagFinally) then
        if object:IsA("BasePart") then
            local can
            connections[object] = object.Touched:Connect(function(part)
                if not can then
                    can = true
                    
                    local Root = part:FindFirstChild("HumanoidRootPart") or part.Parent:FindFirstChild("HumanoidRootPart")
                    
                    if Root then
                        print("Terminou")
                        --Voltar para o lobby
                    end
                    wait(0.5)
                    can = false
                end
            end)
        end
    elseif collections:HasTag(object,GameTagService.TagTeleport) then
        if object:IsA("BasePart") then
            connections[object] = object.Touched:Connect(function(part)
                local char = part.Parent

                local Root = char:FindFirstChild("HumanoidRootPart")
            
                local Spirit = game:GetService("ReplicatedStorage"):WaitForChild("TpSpirit"):Clone()
            
                local Weld = Instance.new("WeldConstraint")
                Weld.Part0 = Root
                Weld.Part1 = Spirit
                Weld.Parent = Spirit
                Spirit.CFrame = Root.CFrame
                Spirit.Parent = Root
            
                coroutine.resume(coroutine.create(function() 
                    local new = Instance.new("Fire")
                    new.Heat = 25
                    new.Size = 10
                    new.Color = Color3.new(137, 168, 236)
                    new.SecondaryColor = Color3.new(116, 139, 137)
                    new.Parent = object
                    wait(0.5)
                    new.Enabled = false
                    debris:AddItem(new,0.5)
                end))
            
                for i,v in pairs(char:GetChildren())do
                    if v:IsA("BasePart")then
                        v.Transparency = 1
                    elseif v:IsA("Accessory")then
                        v.Handle.Transparency = 1
                    end
                end
                local random = math.random(0,3)
                coroutine.resume(coroutine.create(function()
                    while true do
                        if Spirit then
                            Root.Position = Spirit.Position
                        elseif not Spirit then
                            for i,v in pairs(char:GetChildren())do
                                if v:IsA("Accessory")then
                                    v.Handle.Transparency = 0
                                end
                                if v:IsA("BasePart") and v ~= Root then
                                     v.Transparency = 0
                                end
                            end
                            break
                        end
                        wait()
                    end
                end))
                for i = 0,0.75,0.01 do
                    wait()
                    if random == 0 then
                        Spirit.Position += Vector3.fromAxis(Enum.Axis.X) * math.random(0,3)
                        Spirit.Position += Vector3.fromAxis(Enum.Axis.Z) * math.random(0,3)
                        Spirit.Position += Vector3.fromAxis(Enum.Axis.Y) * math.random(0,3)
                    elseif random == 1 then
                        Spirit.Position -= Vector3.fromAxis(Enum.Axis.X) * math.random(0,3)
                        Spirit.Position += Vector3.fromAxis(Enum.Axis.Z) * math.random(0,3)
                        Spirit.Position += Vector3.fromAxis(Enum.Axis.Y) * math.random(0,3)
                    elseif random == 2 then
                        Spirit.Position -= Vector3.fromAxis(Enum.Axis.X) * math.random(0,3)
                        Spirit.Position -= Vector3.fromAxis(Enum.Axis.Z) * math.random(0,3)
                        Spirit.Position += Vector3.fromAxis(Enum.Axis.Y) * math.random(0,3)
                    elseif random == 3 then
                        Spirit.Position += Vector3.fromAxis(Enum.Axis.X) * math.random(0,3)
                        Spirit.Position -= Vector3.fromAxis(Enum.Axis.Z) * math.random(0,3)
                        Spirit.Position += Vector3.fromAxis(Enum.Axis.Y) * math.random(0,3)
                    end
                    Spirit.Position = Spirit.Position:Lerp(object.Aqui.Position,i)
                end
            
                Spirit:Destroy()
                Spirit = nil
                Weld:Destroy()
                Weld = nil
                coroutine.resume(coroutine.create(function() 
                local new = Instance.new("Fire")
                new.Heat = 25
                new.Size = 10
                new.Color = Color3.new(137, 168, 236)
                new.SecondaryColor = Color3.new(116, 139, 137)
                new.Parent = object.Aqui
                wait(0.5)
                new.Enabled = false
                debris:AddItem(new,0.5)
                end))
            end)
        end
    end
end

local function onInstanceRemoved(object)
	if connections[object] then
		connections[object]:disconnect()
		connections[object] = nil
	end
end


function GameTagService:KnitStart()
    
end


function GameTagService:KnitInit()
    collections:GetInstanceAddedSignal(GameTagService.TagEsteira):Connect(onInstanceAdded)

    collections:GetInstanceAddedSignal(GameTagService.TagAnimation):Connect(onInstanceAdded)

    collections:GetInstanceAddedSignal(GameTagService.TagDeadly):Connect(onInstanceAdded)

    collections:GetInstanceAddedSignal(GameTagService.TagTeleport):Connect(onInstanceAdded)

    collections:GetInstanceAddedSignal(GameTagService.TagFinally):Connect(onInstanceAdded)

    collections:GetInstanceAddedSignal(GameTagService.TagJumpPad):Connect(onInstanceAdded)

    coroutine.resume(coroutine.create(function ()
        for _, object in pairs(collections:GetTagged(GameTagService.TagEsteira)) do
            onInstanceAdded(object)
        end
    end))
    
    coroutine.resume(coroutine.create(function ()
        for _, object in pairs(collections:GetTagged(GameTagService.TagAnimation)) do
            onInstanceAdded(object)
        end
    end))
    
    coroutine.resume(coroutine.create(function ()
        for _, object in pairs(collections:GetTagged(GameTagService.TagDeadly)) do
            onInstanceAdded(object)
        end
    end))
    
    coroutine.resume(coroutine.create(function ()
        for _, object in pairs(collections:GetTagged(GameTagService.TagTeleport)) do
            onInstanceAdded(object)
        end
    end))
    
    coroutine.resume(coroutine.create(function ()
        for _, object in pairs(collections:GetTagged(GameTagService.TagFinally)) do
            onInstanceAdded(object)
        end
    end))

    coroutine.resume(coroutine.create(function ()
        for _, object in pairs(collections:GetTagged(GameTagService.TagJumpPad)) do
            onInstanceAdded(object)
        end
    end))
end


return GameTagService