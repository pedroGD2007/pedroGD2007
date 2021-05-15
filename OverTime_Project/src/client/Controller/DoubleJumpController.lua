--By Roblox
-- ???
-- Double Jump
--[[
    Knit

    UserInputService
	Debris
--]]

local Knit = require(game:GetService("ReplicatedStorage").Common.Knit)

local Player = game:GetService("Players").localPlayer

local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local DoubleJumpController = Knit.CreateController { Name = "DoubleJumpController" }

DoubleJumpController.character = nil
DoubleJumpController.humanoid = nil

DoubleJumpController.canDoubleJump = false
DoubleJumpController.hasDoubleJumped = false
DoubleJumpController.oldPower = nil
DoubleJumpController.TIME_BETWEEN_JUMPS = 0.2
DoubleJumpController.DOUBLE_JUMP_POWER_MULTIPLIER = 1.35

function DoubleJumpController:onJumpRequest()
	if not DoubleJumpController.character or not DoubleJumpController.humanoid or not DoubleJumpController.character:IsDescendantOf(workspace) or
    DoubleJumpController.humanoid:GetState() == Enum.HumanoidStateType.Dead then
		return
	end

	if DoubleJumpController.canDoubleJump and not DoubleJumpController.hasDoubleJumped then
		DoubleJumpController.hasDoubleJumped = true
		DoubleJumpController.humanoid.JumpPower = DoubleJumpController.oldPower * DoubleJumpController.DOUBLE_JUMP_POWER_MULTIPLIER
		
		DoubleJumpController.humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end
 
function DoubleJumpController:characterAdded(newCharacter)
	DoubleJumpController.character = newCharacter
	DoubleJumpController.humanoid = newCharacter:WaitForChild("Humanoid")
	DoubleJumpController.hasDoubleJumped = false
	DoubleJumpController.canDoubleJump = false
	DoubleJumpController.oldPower = DoubleJumpController.humanoid.JumpPower
	
	DoubleJumpController.humanoid.StateChanged:connect(function(old, new)
		if new == Enum.HumanoidStateType.Landed then
			DoubleJumpController.canDoubleJump = false
			DoubleJumpController.hasDoubleJumped = false
			DoubleJumpController.humanoid.JumpPower = DoubleJumpController.oldPower
		elseif new == Enum.HumanoidStateType.Freefall then
			wait(DoubleJumpController.TIME_BETWEEN_JUMPS)
			DoubleJumpController.canDoubleJump = true
		end
	end)
end

function DoubleJumpController:KnitStart()
    
end


function DoubleJumpController:KnitInit()

    if Player.Character then
        DoubleJumpController:characterAdded(Player.Character)
    end 

    Player.CharacterAdded:Connect(function(char)
        DoubleJumpController:characterAdded(char)
    end)

    UserInputService.JumpRequest:Connect(function()
        DoubleJumpController:onJumpRequest()
    end)
end     

return DoubleJumpController