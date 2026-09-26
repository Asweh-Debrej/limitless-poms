---@meta AswehDebrej-Limitless_Poms
local public = {}

-- Runs `fn(...)` with every Limitless Poms extension switched off (pure vanilla values) and returns
-- its results. The config is not touched. Useful to compare vanilla and modded boons in one session.
---@param fn function
---@return any ...
function public.run_vanilla(fn, ...) end

-- Internal trait names that are extended, with how many values each one has.
---@return table<string, integer>
function public.tagged_traits() end

-- The mod's config (enabled, max_extra_levels, and one section per god).
---@type table
public.config = {}

return public
