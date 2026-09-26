# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Pom of Power keeps upgrading boons past their vanilla limit, with diminishing returns:
  - Hephaestus: Volcanic Strike, Volcanic Flourish and Smithy Rush (blast cooldown, -25% per extra Pom, down to 0.2s).
  - Zeus: Ionic Gain (Magick orb reappearance time, -25% per extra Pom, down to 0.2s).
  - Hera: Born Gain (Magick Primed, -1 per extra Pom, down to 1).
- Works with every source of boon levels: Pom Slices, Echo's Pom Pom Pom, Natural Selection, Queen's Ransom, King's Ransom and Bridal Glow.
- Config: master switch, `max_extra_levels`, and per god an on/off switch plus its step and minimum. All settings apply live.
- Boons that can't be upgraded with Poms in vanilla (Legendary, Duo, and other fixed boons) are never made upgradeable.
