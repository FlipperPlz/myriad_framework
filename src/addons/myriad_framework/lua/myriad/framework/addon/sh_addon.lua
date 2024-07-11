local MODULE_ROOT = 'myriad/modules/'

do
    for _, name in ipairs(file.Find(MODULE_ROOT .. '*', 'LUA')) do
        local root = MODULE_ROOT .. name ..  '/'
        local module = {
            name = name,
        }

        function module:PrintError(text, color)
            myriad:PrintError(text, color || self.color || MYD_COLOR_RED, self.name)
        end

        function module:PrintWarning(text, color)
            myriad:PrintWarning(text, color || self.color || MYD_COLOR_ORANGE, self.name)
        end

        function module:PrintSuccess(text, color)
            myriad:PrintSuccess(text, color || self.color || MYD_COLOR_GREEN, self.name)
        end

        function module:PrintInfo(text, color)
            myriad:PrintInfo(text, color || self.color || MYD_COLOR_WHITE, self.name)
        end

        function module:IsInitialized()
            return module.init_result != nil
        end

        module:PrintSuccess('Pre Initialization has started')
        myriad.modules[name] = module

        local init = root .. 'init.lua'
        if file.Exists(init, 'LUA') then
            module.preinit_result = myriad:IncludeShared(init) || true
        else
            if SERVER then
                myriad:PrintWarning('Missing init.lua file for module \'' .. name .. '\'. Defaulting to version 0, database migration will not available ')
            end

            module.preinit_result = true
        end
        module:PrintSuccess('Pre Initialization has completed')
    end
end

function AssignModuleMeta(module, name_override, version, color, dependencies, initialize )
    if name_override then
        module.name = name_override
    end

    if version || !module.version then
        module.version = version || 0
    end

    if color || !module.color then
        module.color = version || MYD_COLOR_WHITE
    end

    if dependencies && istable(dependencies) then
        myriad.dependencies = dependencies
    end

    if initialize && isfunction(initialize) then
        function module:Initialize()
            if myriad.init_result then
                return myriad.init_result
            end

            myriad.init_result = initialize(module) || true
        end
    end

    return module
end