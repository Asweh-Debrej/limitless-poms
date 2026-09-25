---@meta _
-- Entry point. Boilerplate from the official Hades2ModTemplate (v0.10.0), trimmed to the "late"
-- loader: god modules only register their boons with Limitless_Poms_Core, which must be loaded first.

---@diagnostic disable-next-line: undefined-global
local mods = rom.mods

---@module 'LuaENVY-ENVY-auto'
mods['LuaENVY-ENVY'].auto()
-- ^ this gives us `public` and `import`, among others
--	and makes all globals we define private to this plugin.
---@diagnostic disable: lowercase-global

---@diagnostic disable-next-line: undefined-global
rom = rom
---@diagnostic disable-next-line: undefined-global
_PLUGIN = _PLUGIN

-- get definitions for the game's globals
---@module 'game'
game = rom.game
---@module 'game-import'
import_as_fallback(game)

---@module 'SGG_Modding-ModUtil'
modutil = mods['SGG_Modding-ModUtil']
---@module 'SGG_Modding-Chalk'
chalk = mods['SGG_Modding-Chalk']
---@module 'SGG_Modding-ReLoad'
reload = mods['SGG_Modding-ReLoad']
---@module 'AswehDebrej-Limitless_Poms_Core'
core = mods['AswehDebrej-Limitless_Poms_Core']

---@module 'config'
config = chalk.auto 'config.lua'
-- ^ this updates our `.cfg` file in the config folder!
public.config = config -- so other mods can access our config

local function on_ready_late()
	-- what to do when we are ready after all other mods
	--   but not re-do on reload.
	if config.enabled == false then return end

	import 'ready_late.lua'
end

-- this allows us to limit certain functions to not be reloaded.
local loader = reload.auto_multiple()

-- loaded after all other mods, so the core's public API is guaranteed to exist
mods.on_all_mods_loaded(function()
	modutil.once_loaded.game(function()
		loader.load("late", on_ready_late)
	end)
end)
