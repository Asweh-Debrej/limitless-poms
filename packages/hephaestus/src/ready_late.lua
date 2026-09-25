---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- Hephaestus boons whose Pom of Power scaling stops in vanilla.
-- Each one has a blast Cooldown with MinimumSourceValue = 2 (see TraitData_Hephaestus.lua).
local capped_boons = {
	'HephaestusWeaponBoon',  -- Volcanic Strike
	'HephaestusSpecialBoon', -- Volcanic Flourish
	'HephaestusSprintBoon',  -- Smithy Rush
}

local extended = core.extend_min_clamps(capped_boons)
rom.log.info(_PLUGIN.guid .. ': extended ' .. extended .. ' capped values')
