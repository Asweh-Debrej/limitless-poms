---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- Re-run on every hot reload, so this file only defines things (and re-applies idempotent tags).
--
-- How the vanilla limit works: GetAllUpgradeableGodTraits (TraitLogic.lua) only offers a boon to
-- Pom of Power if its values change at the next level. Ramped values are computed by
-- GetProcessedValue and clamped by ProcessValue via MinimumSourceValue, so once a value sits on
-- its minimum (e.g. Hephaestus blast cooldown = 2s) the boon can no longer be upgraded.

-- Marker written into the game's ramp tables (inside TraitData): the name of the god group
TAG = 'LimitlessPoms'

local EPSILON = 1e-6

gods = import 'gods.lua'

-- trait name -> number of values tagged; kept across hot reloads
tagged_traits = tagged_traits or {}

-- true while public.run_vanilla is running
suspended = false

local function clamp(value, min, max)
	return math.max(min, math.min(max, tonumber(value) or min))
end

-- Only fixed-base ramps are extended: computing them several times is side-effect free, while
-- ramps with random bases would consume extra RNG rolls and break run determinism.
local function is_extendable_min_clamp(ramp)
	return type(ramp.BaseValue) == 'number'
		and type(ramp.MinimumSourceValue) == 'number'
		and ramp.BaseMin == nil
		and ramp.CustomRarityMultiplier == nil
end

local function tag_min_clamps(node, group, visited)
	if visited[node] then return 0 end
	visited[node] = true
	if is_extendable_min_clamp(node) then
		node[TAG] = group
		return 1
	end
	local count = 0
	for _, value in pairs(node) do
		if type(value) == 'table' then
			count = count + tag_min_clamps(value, group, visited)
		end
	end
	return count
end

local function tag_group(group, traitNames)
	for _, traitName in ipairs(traitNames) do
		local traitData = game.TraitData[traitName]
		if traitData == nil then
			rom.log.warning(_PLUGIN.guid .. ': unknown trait "' .. tostring(traitName) .. '", skipped')
		elseif traitData.BlockStacking then
			-- boons that can never be upgraded in vanilla are off-limits
			rom.log.warning(_PLUGIN.guid .. ': trait "' .. traitName .. '" cannot be upgraded in vanilla (BlockStacking), skipped')
		else
			local count = tag_min_clamps(traitData, group, {})
			if count == 0 then
				rom.log.warning(_PLUGIN.guid .. ': trait "' .. traitName .. '" has no fixed value with a minimum clamp, nothing to extend')
			end
			tagged_traits[traitName] = count
		end
	end
end

-- Reads a god's live settings from the config; nil when the god (or the whole mod) is disabled.
local function group_settings(group, vanillaFloor)
	local section = config[group]
	local rule = gods[group] and gods[group].rule
	if config.enabled == false or section == nil or section.enabled == false or rule == nil then
		return nil
	end
	if rule == 'amount' then
		return {
			amount = math.max(1, math.floor(tonumber(section.step) or 1)),
			floor = clamp(math.floor(tonumber(section.minimum) or 1), 1, vanillaFloor),
		}
	end
	return {
		fraction = clamp(section.step_fraction, 0.01, 0.9),
		floor = clamp(section.minimum_seconds, 0.1, vanillaFloor),
	}
end

local function with_stack(args, stackNum)
	local copy = {}
	for key, value in pairs(args) do
		copy[key] = value
	end
	copy.StackNum = stackNum
	return copy
end

-- Called by the GetProcessedValue wrap (ready.lua) for tagged ramps.
-- Vanilla values are kept while they still improve. Once a level stops improving because the
-- value sits on MinimumSourceValue, every further level removes a share (`step_fraction`) or a
-- fixed amount (`step`) of the previous value, down to the god's minimum, optionally for at most
-- `max_extra_levels` levels.
--
-- Invariant: only values that vanilla Poms were already improving get extended. A value that
-- never changes in vanilla (e.g. already on its minimum at level 1) is returned untouched, so a
-- boon that cannot be upgraded in vanilla can never become upgradeable through this mod.
function process_tagged_ramp(base, ramp, args, key)
	local stackNum = (args and args.StackNum) or 0
	local settings = not suspended and stackNum > 1 and group_settings(ramp[TAG], ramp.MinimumSourceValue)
	if not settings then
		return base(ramp, args, key)
	end

	local maxExtra = math.max(0, math.floor(tonumber(config.max_extra_levels) or 0))
	local vanillaFloor = ramp.MinimumSourceValue
	-- Same rounding as the game's ProcessValue, minus the minimum clamp we are extending past
	local rounding = { AsInt = ramp.AsInt, ToNearest = ramp.ToNearest, DecimalPlaces = ramp.DecimalPlaces }

	local value = base(ramp, with_stack(args, 1), key)
	local improved, extending, extra = false, false, 0
	for level = 2, stackNum do
		if not extending then
			local vanilla = base(ramp, with_stack(args, level), key)
			local stalled = vanilla >= value - EPSILON and value <= vanillaFloor + EPSILON
			if stalled and not improved then
				-- never scaled in vanilla: leave it exactly as the game computes it
				return base(ramp, args, key)
			elseif stalled then
				extending = true
			else
				improved = improved or vanilla < value - EPSILON
				value = vanilla
			end
		end
		if extending then
			if maxExtra > 0 and extra >= maxExtra then break end
			extra = extra + 1
			local nextValue = value * (1 - (settings.fraction or 0))
			if settings.amount then nextValue = value - settings.amount end
			value = math.max(game.ProcessValue(nextValue, rounding), settings.floor)
		end
	end
	return value
end

-- Runs `fn` with every extension switched off (pure vanilla values), without touching the config.
-- Used by dev tools to compare vanilla and modded values in the same session.
function public.run_vanilla(fn, ...)
	suspended = true
	local results = table.pack(pcall(fn, ...))
	suspended = false
	if not results[1] then error(results[2], 2) end
	return table.unpack(results, 2, results.n)
end

---@return table<string, integer>
function public.tagged_traits()
	return tagged_traits
end

-- Tags are idempotent, so re-applying them on every reload is safe (and picks up new boons).
for group, data in pairs(gods) do
	tag_group(group, data.boons)
end
