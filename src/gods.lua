-- Boons whose Pom of Power scaling stops at a vanilla minimum, grouped by Olympian.
-- Each group has its own section in the config (enabled + how far past the limit it goes).
--
-- rule = 'fraction': past the vanilla limit, each Pom removes `step_fraction` of the previous value,
--                    down to `minimum_seconds` (for time values such as cooldowns).
-- rule = 'amount':   past the vanilla limit, each Pom removes `step` (a whole number), down to
--                    `minimum` (for whole-number values such as Magick).
return {
	Hephaestus = {
		rule = 'fraction',
		boons = {
			'HephaestusWeaponBoon',  -- Volcanic Strike: blast cooldown stops at 2s
			'HephaestusSpecialBoon', -- Volcanic Flourish: blast cooldown stops at 2s
			'HephaestusSprintBoon',  -- Smithy Rush: blast cooldown stops at 2s
		},
	},
	Zeus = {
		rule = 'fraction',
		boons = {
			'ZeusManaBoon', -- Ionic Gain: Magick orb reappearance time stops at 2s
		},
	},
	Hera = {
		rule = 'amount',
		boons = {
			'HeraManaBoon', -- Born Gain: Magick Primed stops at 5
		},
	},
}
