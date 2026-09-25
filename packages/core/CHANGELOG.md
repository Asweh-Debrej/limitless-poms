# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `extend_min_clamps` API: boons with a fixed value clamped by `MinimumSourceValue` keep scaling past the vanilla limit, each extra Pom removing at most `step_fraction` (25%) of the previous value, down to `hard_floor` (0.1).
- Config: `enabled`, `step_fraction`, `hard_floor`.
- Safeguards: `BlockStacking` traits are refused, and values that never improve with Poms in vanilla stay vanilla, so non-upgradeable boons can never become upgradeable.
- `run_vanilla` API to compare vanilla and modded values in the same session.
