--[[
    Data Store
    By pedroGD2007
    08/05/2021
--]]

local Knit = require(game:GetService("ReplicatedStorage").Common.Knit)
local DataService = game:GetService("DataStoreService")
local PlayerStats = Knit.GetService("PlayerStats")

local DataStore = Knit.CreateService {
    Name = "DataStore";
    Client = {};
}

DataStore.NAME_DATA = "GameData"
DataStore.GAME_DATA = DataService:GetDataStore(DataStore.NAME_DATA) 

DataStore.SaveCount = 0

function DataStore:Save(pl)
    local Key = "Player_"..pl.UserId
    local ToSave = {}

    for i,v in pairs(pl.leaderstats:GetChildren())do
        table.insert(ToSave,i,v.Name.."|"..v.Value)
    end

    print(ToSave)
    DataStore.GAME_DATA:SetAsync(Key,ToSave)
end

function DataStore:Load(pl)
    local Key = "Player_"..pl.UserId
    local ToLoad

    if not DataStore.GAME_DATA:GetAsync(Key) then return warn("Do not have stats to save") end
    ToLoad = DataStore.GAME_DATA:GetAsync(Key)
    
    for i,v in pairs(ToLoad)do 
        local separe = string.split(v,"|")
        local Class = separe[1]
        local Val = separe[2]
        if Class == "Time" then
            pl:WaitForChild("leaderstats").Time.Value = Val
        elseif Class == "Coin" then
            pl:WaitForChild("leaderstats").Coin.Value = Val
        end
    end
end

function DataStore:KnitStart()
end

function DataStore:KnitInit()
    game:GetService("Players").PlayerAdded:Connect(function(pl)
        coroutine.wrap(function()
            DataStore:Load(pl)
        end)()
    end)
    
    game:GetService("Players").PlayerRemoving:Connect(function(pl)
        DataStore:Save(pl)
    end)

    game:BindToClose(function()
        if game:GetService('RunService'):IsStudio() then
            return warn("IsStudio")
        end

        local players = game:GetService("Players"):GetPlayers()
        for _, pl in ipairs(players) do

            coroutine.wrap(function()
                
            DataStore:Save(pl)

            DataStore.SaveCount += 1
            end)
        end

        repeat
            wait()
        until DataStore.SaveCount >= players
    end)
end

return DataStore