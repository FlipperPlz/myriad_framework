
-- SteamID Cache

local player_table = FindMetaTable('Player')

if (!player_table.RetrieveSteamID || !isfunction(player_table.RetrieveSteamID)) then
    player_table.RetrieveSteamID = player_table.SteamID
end

player_table.SteamID = function()
    if (!player_table.steam_id) then
        local id = player_table.RetrieveSteamID()
        myriad.steam_id = id
        return id
    end
    return player_table.steam_id
end