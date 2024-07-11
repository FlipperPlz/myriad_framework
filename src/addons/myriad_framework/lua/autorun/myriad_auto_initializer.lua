myriad = {}

function myriad:IncludeShared(path)
    local output = include(path)
    AddCSLuaFile(path)
    return output
end

function myriad:AutoInclude(path, recursive)
    if (string.EndsWith(path, '/')) then
        path = path .. '*'
        local files, folders = file.Find(path, 'LUA')

        for _, name in ipairs(files) do
            if GetExtensionFromFilename(name) == 'lua' then
                myriad:AutoInclude(path .. name)
            end
        end

        if recursive then
            for _, name in ipairs(folders) do
                myriad:AutoInclude(path .. name .. '/', recursive)
            end
        end
    else
        local parts = string.Explode('/', path)
        local prefix = string.Left(parts[#parts], 2)

        if prefix then
            if prefix == 'sv' then
                include(path)
            elseif prefix == 'cl' then
                AddCSLuaFile(path)
            elseif prefix == 'sh' then
                myriad:IncludeShared(path)
            end
        end
    end
end
MYD_COLOR_WHITE = Color(255, 255, 255)
MYD_COLOR_RED = Color(255, 0, 0)
MYD_COLOR_ORANGE = Color(255, 123, 0)
MYD_COLOR_GREEN = Color(90, 158, 35)

function myriad:Format(text, ...)
    for _, arg in ipairs({...}) do
        if isentity(arg) && arg:IsPlayer() then
            arg = arg:Name() .. ' (' .. arg:SteamID() .. ')'
        else
            arg = tostring(arg)
        end

        text = string.gsub(text, '#', arg, 1)
    end

    return text
end


function myriad:PrintWPrefix(color, prefix, text)
    MsgC(
        MYD_COLOR_WHITE, '(', Color(174, 0, 255), 'Myriad', MYD_COLOR_WHITE, ',',
        MYD_COLOR_WHITE, '[', color, prefix,  MYD_COLOR_WHITE, '] ',
        text, '\n'
    )
end

function myriad:Print(text, ...)
    MsgC(
        MYD_COLOR_WHITE, '(', Color(174, 0, 255), 'Myriad', MYD_COLOR_WHITE,
        text, '\n'
    )
end

function myriad:PrintError(text, ...)
    myriad.logger:PrintWPrefix(MYD_COLOR_RED, 'ERROR', text, ...)
end

function myriad:PrintWarning(text, ...)
    myriad.logger:PrintWPrefix(MYD_COLOR_ORANGE, 'WARN', text, ...)
 end

function myriad:PrintInfo(text, ...)
    myriad:PrintWPrefix(MYD_COLOR_WHITE, 'INFO', text, ...)
end

function myriad:PrintSuccess(text, ...)
    myriad:PrintWPrefix(MYD_COLOR_GREEN, 'SUCCESS', text, ...)
end

myriad:IncludeShared('myriad/init.lua')
