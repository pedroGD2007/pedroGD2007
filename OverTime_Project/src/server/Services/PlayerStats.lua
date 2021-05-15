--[[
    Player Stats
    By pedroGD2007
    08/05/2021
--]]

local Knit = require(game:GetService("ReplicatedStorage").Common.Knit)

local PlayerStats = Knit.CreateService {
    Name = "PlayerStats";
    Client = {};
}

function PlayerStats:Create(pl)
    local leaderstats = Instance.new("Configuration")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = pl

    local Time = Instance.new("IntValue")
    Time.Name = "Time"
    Time.Parent = leaderstats

    local Coin = Instance.new("IntValue")
    Coin.Name = "Coin"
    Coin.Parent = leaderstats

    coroutine.resume(coroutine.create(function()
        while true do
            wait(1)
            Time.Value += 1
        end
    end))
end

function PlayerStats:Add(pl,name,val)
    local GetStats = pl.leaderstats:FindFirstChild(name)
    GetStats += val
    if GetStats > 0 then
        GetStats = 0
    end
end

function PlayerStats:Remove(pl,name,val)
    local GetStats = pl.leaderstats:FindFirstChild(name)
    GetStats -= val
    if GetStats > 0 then
        GetStats = 0
    end
end

function PlayerStats:KnitStart()

end


function PlayerStats:KnitInit()
    game.Players.PlayerAdded:Connect(function(pl)
        PlayerStats:Create(pl)
    end)
end


return PlayerStats