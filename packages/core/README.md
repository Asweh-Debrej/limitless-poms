# Limitless Poms: Core

Shared library for [Limitless Poms](https://thunderstore.io/c/hades-ii/p/AswehDebrej/Limitless_Poms/). **You don't need to install it yourself.** The Limitless Poms god modules pull it in automatically. On its own it changes nothing.

## Configuration (optional)

These settings apply to every god module (r2modman → Config editor → `AswehDebrej-Limitless_Poms_Core`):

| Setting | Default | Meaning |
| --- | --- | --- |
| `enabled` | `true` | `false` restores every vanilla limit, live. |
| `step_fraction` | `0.25` | After a boon reaches its vanilla limit, each extra Pom lowers the value by at most this share of the previous value. |
| `hard_floor` | `0.1` | Values never go below this. |

## For modders

Boons are processed by wrapping `GetProcessedValue`. Values that are not registered pass straight through to vanilla. To extend a boon whose fixed-base value is clamped by `MinimumSourceValue`, add `AswehDebrej-Limitless_Poms_Core` as a dependency and call:

```lua
local core = rom.mods['AswehDebrej-Limitless_Poms_Core']
core.extend_min_clamps({ 'HephaestusWeaponBoon' })               -- uses the core config
core.extend_min_clamps('SomeBoon', { step_fraction = 0.1 })      -- per-boon override
```

Call it once the game's scripts are loaded, e.g. from `ready_late.lua` of a mod built on the official template. See `def.lua` for the annotated API.

Guarantees, so a module can't accidentally change what is upgradeable:

- Traits with `BlockStacking` (never upgradeable in vanilla) are refused.
- A value is only extended if vanilla Poms were already improving it. A value that never changes in vanilla, for example one already sitting on its minimum at level 1 for some rarity, is returned exactly as vanilla computes it.
- Only traits passed to `extend_min_clamps` are touched.

`core.run_vanilla(fn, ...)` runs `fn` with every extension switched off, which is handy for comparing vanilla and modded values in the same session.
