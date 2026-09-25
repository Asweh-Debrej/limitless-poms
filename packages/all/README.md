# Limitless Poms

Some boons stop accepting Pom of Power once one of their values hits a hard limit. The Hephaestus blast cooldown, for example, never goes below 2 seconds, so after that point Poms are never offered for it again.

**Limitless Poms removes those limits.** Boons level up exactly like vanilla until they reach their limit. After that, every Pom still makes them stronger, with diminishing returns: each extra level lowers the value by at most 25% of the previous one.

## What changes

| God | Boon | Vanilla | With Limitless Poms |
| --- | --- | --- | --- |
| Hephaestus | Volcanic Strike, Volcanic Flourish, Smithy Rush | Blast cooldown stops at **2s**. A Heroic boon is maxed at level 4. | 2s → 1.5s → 1.1s → 0.9s → … keeps improving down to ~0.2s. A Heroic boon maxes at level 12. |

More gods are coming. Installing this package gets you every god module, and new ones arrive through normal updates.

## Installation

Install with [r2modman](https://thunderstore.io/c/hades-ii/p/ebkr/r2modman/) (or the Thunderstore Mod Manager), then play. Dependencies are installed automatically, and no configuration is needed.

Only want some gods? Install the individual modules instead, e.g. `Limitless_Poms_Hephaestus`.

## Configuration (optional)

The defaults are meant to be played as-is. In r2modman → Config editor → `AswehDebrej-Limitless_Poms_Core`:

- `step_fraction` (default `0.25`): the largest share of the previous value one extra Pom can remove.
- `hard_floor` (default `0.1`): values never go below this.
- `enabled`: turns every limit back to vanilla.

## What does NOT change

- **Boons that can't be upgraded with Poms in vanilla stay that way.** This covers Legendary and Duo boons and every other fixed boon. The mod only continues scaling that Poms were already doing, and never adds levels to a boon that has none.
- Boons are unchanged until they reach their vanilla limit. Levels 1 up to the limit give exactly the vanilla numbers.

## Compatibility

- Only boons that normally hit a limit are touched; every other boon is untouched.
- Works with other mods that change boons or Poms, as long as they don't replace the same values.
- Safe to add or remove between runs.

Bugs and suggestions: [GitHub issues](https://github.com/AswehDebrej/Limitless_Poms/issues).
