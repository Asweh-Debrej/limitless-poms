---@meta AswehDebrej-Limitless_Poms_Core
local public = {}

--[[
	Lets boons keep scaling with Pom of Power after a value reaches its vanilla minimum.

	Finds every fixed-base ramped value with a `MinimumSourceValue` inside the given traits
	(e.g. Hephaestus blast cooldowns). Vanilla values are kept while they still improve; after
	that each Pom lowers the value by at most `step_fraction` of the previous value, down to
	`hard_floor`. Call it once the game's scripts are loaded (e.g. from ready_late.lua).

	Never makes a non-upgradeable boon upgradeable: BlockStacking traits are refused, and values
	that don't already improve with Poms in vanilla are left exactly as vanilla computes them.

	Usage:
		local core = rom.mods['AswehDebrej-Limitless_Poms_Core']
		core.extend_min_clamps({ 'HephaestusWeaponBoon', 'HephaestusSpecialBoon' })
]]
---@param traitNames string|string[] internal trait names (keys of TraitData)
---@param opts? { step_fraction?: number, hard_floor?: number } per-trait overrides of the core config
---@return integer extended number of values that were extended
function public.extend_min_clamps(traitNames, opts) end

-- Trait names passed to extend_min_clamps, with how many values each one got extended.
---@return table<string, integer>
function public.tagged_traits() end

-- Runs `fn(...)` with every extension switched off (pure vanilla values) and returns its results.
-- The config is not touched. Useful to compare vanilla and modded boons in the same session.
---@param fn function
---@return any ...
function public.run_vanilla(fn, ...) end

-- The core config (enabled, step_fraction, hard_floor).
---@type table
public.config = {}

return public
