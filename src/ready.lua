---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- Runs once. The wrap stays a cheap pass-through for every untagged value; tagged ramps are
-- handled by process_tagged_ramp (reload.lua), so the logic itself is hot-reloadable.
modutil.mod.Path.Wrap('GetProcessedValue', function(base, valueToRamp, args, key)
	if type(valueToRamp) == 'table' and valueToRamp[TAG] then
		return process_tagged_ramp(base, valueToRamp, args, key)
	end
	return base(valueToRamp, args, key)
end)
