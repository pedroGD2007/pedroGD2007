-- By pedroGD2007
-- 11/05/2021
-- Diving Controller

--[[
    Knit    
    Knit.RemoteSignal

    Diving Service

    ContextServiceAction

--]]

local Knit = require(game:GetService("ReplicatedStorage").Common.Knit)
local Diving = Knit.GetService("Diving")

local ContextService = game:GetService("ContextActionService")

local divingController = Knit.CreateController { Name = "divingController" }


function divingController:KnitStart()

end

function divingController:KnitInit()
    local function Dive()
        ContextService:UnbindAction("Diving")
        Diving.RequestDiving:Fire()
        wait(1)
        ContextService:BindAction("Diving",Dive,true,Enum.KeyCode.E)
    end

    ContextService:BindAction("Diving",Dive,true,Enum.KeyCode.E)
end


return divingController