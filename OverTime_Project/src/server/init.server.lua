--[[
    By pedroGD2007
    09/05/2021
--]]
local Knit = require(game:GetService("ReplicatedStorage").Common.Knit)

--Load Services or Controllers

Knit.AddServicesDeep(script.Services)

local success, err = Knit.Start():Await()
if (not success) then
    error(tostring(err))
end