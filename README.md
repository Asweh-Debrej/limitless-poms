# Limitless Poms

Hades II mods that let boons keep scaling with Pom of Power after they hit their vanilla limit.
Player-facing descriptions live in each package's `README.md` (shown on Thunderstore).

## Packages

| Folder | Thunderstore package | Role |
| --- | --- | --- |
| `packages/core` | `AswehDebrej-Limitless_Poms_Core` | Library: wraps `GetProcessedValue`, exposes `extend_min_clamps` |
| `packages/hephaestus` | `AswehDebrej-Limitless_Poms_Hephaestus` | Volcanic Strike, Volcanic Flourish, Smithy Rush |
| `packages/all` | `AswehDebrej-Limitless_Poms` | No code: depends on every god module |

Each package follows the [official Hades II mod template](https://github.com/SGG-Modding/Hades2ModTemplate) layout (`thunderstore.toml`, `src/` → `plugins/`).

## How it works

Pom of Power only offers boons whose values change at the next level (`GetAllUpgradeableGodTraits`). Values are ramped by `GetProcessedValue` and clamped by `MinimumSourceValue`, so a boon whose only scaling value sits on its minimum can no longer be upgraded. The core tags those ramps and, past the vanilla limit, lowers them by at most `step_fraction` (25%) of the previous value per level, down to `hard_floor`.

## Adding a god module

1. Create `packages/<god>` (the workspace's `tools/new-package.ps1` does this) that depends on `AswehDebrej-Limitless_Poms_Core`.
2. In `src/ready_late.lua`, call `core.extend_min_clamps({ ... })` with the god's capped trait names.
3. Add the folder to the `package` options in `.github/workflows/release.yaml` and as a dependency of `packages/all`.
4. Add a `{ "kind": "god", "god": "<God>" }` entry to the workspace's `tools/icons/icons.json` and run `tools/icons.ps1`.

## Releasing

Actions → **Release** → choose the package and version. Tick **dry-run** first to inspect the built zip.
Release order: `core` → god modules → `all`, because Thunderstore rejects dependencies that are not published yet.
Requires the repository secret `TCLI_AUTH_TOKEN` (Thunderstore service account token of the `AswehDebrej` team).
