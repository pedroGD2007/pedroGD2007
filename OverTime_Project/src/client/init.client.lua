-- By pedroGD2007
-- Main Client
-- 09/05/2021

--[[
    
    Diving

    Double Jump

--]]


local Knit = require(game:GetService("ReplicatedStorage").Common.Knit)

Knit.AddControllersDeep(script.Controller)

local success, err = Knit.Start():Await()
if (not success) then
    error(tostring(err))
end