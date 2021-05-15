--[[
    Diving
    By pedroGD2007
    09/05/2021
--]]

--[[
    Knit.Signal    
    
    Debris


--]]


local Knit = require(game:GetService("ReplicatedStorage").Common.Knit)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
local Maid = require(Knit.Util.Maid)
local Debris = game:GetService("Debris")

local Diving = Knit.CreateService {
    Name = "Diving";
    Client = {};
}

Diving.Client.RequestDiving = RemoteSignal.new()

Diving.POWER = 30

local pode

function Animation(pl)
    local ID = 6728632327

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://".. ID
    local track = pl.Character:FindFirstChild("Humanoid"):LoadAnimation(anim)
    
    track:AdjustSpeed(0)

    track:Play()

    Debris:AddItem(anim,track.Length)
    Debris:AddItem(track,track.Length)
    coroutine.resume(coroutine.create(function()
        wait(0.4)
        track:Stop()
    end))
end

function Boost(pl)
    local boost = Instance.new("BodyVelocity")

    boost.MaxForce = Vector3.new(9999999999999999999999,-1,9999999999999999999999)
    boost.Velocity = pl.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * Diving.POWER
    boost.Parent = pl.Character:FindFirstChild("HumanoidRootPart")

    Debris:AddItem(boost,0.5)
end

function Diving:Play(pl)
    pl.Character:FindFirstChild("Humanoid").StateChanged:connect(function(old, new)
        pode = new
	end)
    
    if pode == Enum.HumanoidStateType.Freefall then
        pl.Character:FindFirstChild("Humanoid").WalkSpeed = 0
        pl.Character:FindFirstChild("Humanoid").JumpPower = 0
        Boost(pl)
        Animation(pl)
        wait(0.5)
        pl.Character:FindFirstChild("Humanoid").WalkSpeed = 16
        pl.Character:FindFirstChild("Humanoid").JumpPower = 50
    end
end

function Diving:KnitStart()

end

function Diving:KnitInit()
    self.Client.RequestDiving:Connect(function(pl)
      Diving:Play(pl)
    end)
end

return Diving