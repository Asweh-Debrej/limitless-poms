# Limitless Poms

Some boons stop accepting Pom of Power once one of their values hits a hard limit. The Hephaestus blast cooldown, for example, never goes below 2 seconds, so after that point Poms are never offered for it again.

**Limitless Poms removes those limits.** Boons level up exactly like vanilla until they reach their limit. After that, every Pom keeps making them stronger, with diminishing returns.

## What changes

| God | Boon | Vanilla | With Limitless Poms |
| --- | --- | --- | --- |
| Hephaestus | Volcanic Strike, Volcanic Flourish, Smithy Rush | Blast cooldown stops at **2s**. A Heroic Volcanic Strike is maxed at level 4. | Each extra Pom: -25% cooldown, down to 0.2s. 2s → 1.5s → 1.1s → 0.9s → … A Heroic Volcanic Strike maxes at level 12. |
| Zeus | Ionic Gain | Magick orb reappearance time stops at **2s**. A Heroic Ionic Gain is maxed at level 6. | Each extra Pom: -25% time, down to 0.2s. A Heroic Ionic Gain maxes at level 14. |
| Hera | Born Gain | Magick Primed stops at **5**. A Heroic Born Gain is maxed at level 9. | Each extra Pom: -1 Magick Primed, down to 1 (Magick stays a whole number). A Heroic Born Gain maxes at level 13. |

It works with every source of boon levels, not just Pom of Power: Pom Slices (shop and Icarus's Supply Drop), Echo's Pom Pom Pom, Natural Selection, Queen's Ransom, King's Ransom and Bridal Glow. Levels those used to waste on a maxed boon now count.

The game never lets Bridal Glow (or other rarity upgrades) pick a Hephaestus blast boon once its cooldown is 2s or lower. That vanilla rule still applies.

## What does NOT change

- **Boons that can't be upgraded with Poms in vanilla stay that way.** This covers Legendary and Duo boons and every other fixed boon. The mod only continues scaling that Poms were already doing, and never adds levels to a boon that has none.
- Levels 1 up to the vanilla limit give exactly the vanilla numbers.
- Every boon not listed above is untouched.

## Installation

Install with [r2modman](https://thunderstore.io/c/hades-ii/p/ebkr/r2modman/) (or the Thunderstore Mod Manager), then play. Dependencies are installed automatically and no configuration is needed.

## Configuration (optional)

r2modman → Config editor → `AswehDebrej-Limitless_Poms`. Changes apply immediately, even mid-run.

| Setting | Default | Meaning |
| --- | --- | --- |
| `enabled` | `true` | Master switch. `false` restores every vanilla limit. |
| `max_extra_levels` | `0` | How many Pom levels a boon can gain past its vanilla limit. `0` = no limit. |
| `Hephaestus.enabled` / `Zeus.enabled` / `Hera.enabled` | `true` | Turn a god off to keep its vanilla limits. |
| `Hephaestus.step_fraction` / `Zeus.step_fraction` | `0.25` | Share of the previous value each extra Pom removes (0.25 = 25%). |
| `Hephaestus.minimum_seconds` / `Zeus.minimum_seconds` | `0.2` | The cooldown / reappearance time never goes below this. |
| `Hera.step` | `1` | Magick Primed removed per extra Pom. |
| `Hera.minimum` | `1` | Magick Primed never goes below this. |

## Compatibility

- Only the boons listed above are touched.
- Works with other mods that change boons or Poms, as long as they don't replace the same values.
- Safe to add or remove between runs.

Bugs and suggestions: [GitHub issues](https://github.com/Asweh-Debrej/limitless-poms/issues).
