-- Local Player Cache

if (!RetrieveLocalPlayer || !isfunction(RetrieveLocalPlayer)) then
    RetrieveLocalPlayer = LocalPlayer
end

LocalPlayer = function()
    if (!myriad.local_player) then
        local player = RetrieveLocalPlayer()
        myriad.local_player = player
        return player
    end

    return myriad.local_player
end
