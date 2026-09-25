# Limitless Poms: Hephaestus

In vanilla, Hephaestus's blast boons stop accepting Pom of Power once their cooldown reaches **2 seconds**. A Heroic Volcanic Strike is already maxed at level 4.

With this mod they level up exactly like vanilla until that point. After that, every Pom keeps lowering the cooldown, each time by at most 25% of the previous value:

| Level (Heroic Volcanic Strike) | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | … | 12 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Vanilla cooldown | 6s | 4s | 3s | 2s | *maxed* | | | | | |
| With this mod | 6s | 4s | 3s | 2s | 1.5s | 1.1s | 0.9s | 0.6s | … | 0.2s (maxed) |

Affected boons: **Volcanic Strike**, **Volcanic Flourish**, **Smithy Rush**. Other Hephaestus boons, including those that can't be upgraded with Poms at all, stay exactly as in vanilla.

## Installation

Install with [r2modman](https://thunderstore.io/c/hades-ii/p/ebkr/r2modman/) and play. Dependencies (including `Limitless_Poms_Core`) are installed automatically.

Want every god covered? Install [Limitless Poms](https://thunderstore.io/c/hades-ii/p/AswehDebrej/Limitless_Poms/) instead.

## Configuration (optional)

- `AswehDebrej-Limitless_Poms_Hephaestus` → `enabled`: set to `false` to keep vanilla limits for Hephaestus (restart the game afterwards).
- How far values can go past the vanilla limit is set in `AswehDebrej-Limitless_Poms_Core` (`step_fraction`, `hard_floor`).

Bugs and suggestions: [GitHub issues](https://github.com/AswehDebrej/Limitless_Poms/issues).
