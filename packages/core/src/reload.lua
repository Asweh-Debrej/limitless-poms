---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- Core logic. Re-run on every hot reload, so this file only defines things.
--
-- How the vanilla cap works: GetAllUpgradeableGodTraits (TraitLogic.lua) only offers a boon to
-- Pom of Power if its values change at the next level. Ramped values are computed by
-- GetProcessedValue and clamped by ProcessValue via MinimumSourceValue, so once a value sits on
-- its minimum (e.g. Hephaestus blast cooldown = 2s) the boon can no longer be upgraded.

-- Marker keys written into the game's ramp tables (inside TraitData) by extend_min_clamps
TAG = 'LimitlessPoms'
TAG_STEP = 'LimitlessPoms_StepFraction'
TAG_HARD_FLOOR = 'LimitlessPoms_HardFloor'

local EPSILON = 1e-6

-- trait name -> number of values extended; kept across hot reloads
tagged_traits = tagged_traits or {}

-- true while public.run_vanilla is running
suspended = false

local function clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

-- Only fixed-base ramps are extended: computing them several times is side-effect free, while
-- ramps with random bases would consume extra RNG rolls and break run determinism.
local function is_extendable_min_clamp(ramp)
	return type(ramp.BaseValue) == 'number'
		and type(ramp.MinimumSourceValue) == 'number'
		and ramp.BaseMin == nil
		and ramp.CustomRarityMultiplier == nil
end

local function tag_min_clamps(node, opts, visited)
	if visited[node] then return 0 end
	visited[node] = true
	if is_extendable_min_clamp(node) then
		node[TAG] = true
		node[TAG_STEP] = opts.step_fraction
		node[TAG_HARD_FLOOR] = opts.hard_floor
		return 1
	end
	local count = 0
	for _, value in pairs(node) do
		if type(value) == 'table' then
			count = count + tag_min_clamps(value, opts, visited)
		end
	end
	return count
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
-- value sits on MinimumSourceValue, every further level removes at most `step_fraction` of the
-- previous value: it keeps approaching 0 (down to the hard floor) instead of stopping.
--
-- Invariant: only values that vanilla Poms were already improving get extended. A value that
-- never changes in vanilla (e.g. already on its minimum at level 1) is returned untouched, so a
-- boon that cannot be upgraded in vanilla can never become upgradeable through this mod.
function process_tagged_ramp(base, ramp, args, key)
	local stackNum = (args and args.StackNum) or 0
	if suspended or config.enabled == false or stackNum <= 1 then
		return base(ramp, args, key)
	end

	local step = clamp(ramp[TAG_STEP] or config.step_fraction, 0.01, 0.9)
	local vanillaFloor = ramp.MinimumSourceValue
	local hardFloor = math.min(ramp[TAG_HARD_FLOOR] or config.hard_floor, vanillaFloor)
	-- Same rounding as the game's ProcessValue, minus the minimum clamp we are extending past
	local rounding = { AsInt = ramp.AsInt, ToNearest = ramp.ToNearest, DecimalPlaces = ramp.DecimalPlaces }

	local value = base(ramp, with_stack(args, 1), key)
	local improved, extending = false, false
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
			value = math.max(game.ProcessValue(value * (1 - step), rounding), hardFloor)
		end
	end
	return value
end

---@param traitNames string|string[]
---@param opts? { step_fraction?: number, hard_floor?: number }
---@return integer extended
function public.extend_min_clamps(traitNames, opts)
	if type(traitNames) == 'string' then traitNames = { traitNames } end
	opts = opts or {}
	local total = 0
	for _, traitName in ipairs(traitNames) do
		local traitData = game.TraitData[traitName]
		if traitData == nil then
			rom.log.warning(_PLUGIN.guid .. ': unknown trait "' .. tostring(traitName) .. '", skipped')
		elseif traitData.BlockStacking then
			-- boons that can never be upgraded in vanilla are off-limits
			rom.log.warning(_PLUGIN.guid .. ': trait "' .. traitName .. '" cannot be upgraded in vanilla (BlockStacking), skipped')
		else
			local count = tag_min_clamps(traitData, opts, {})
			if count == 0 then
				rom.log.warning(_PLUGIN.guid .. ': trait "' .. traitName .. '" has no fixed value with a minimum clamp, nothing to extend')
			end
			tagged_traits[traitName] = count
			total = total + count
		end
	end
	return total
end

---@return table<string, integer>
function public.tagged_traits()
	return tagged_traits
end

-- Runs `fn` with every extension switched off (pure vanilla values), without touching the config.
-- Used by dev tools to compare vanilla and modded boons in the same session.
function public.run_vanilla(fn, ...)
	suspended = true
	local results = table.pack(pcall(fn, ...))
	suspended = false
	if not results[1] then error(results[2], 2) end
	return table.unpack(results, 2, results.n)
end
