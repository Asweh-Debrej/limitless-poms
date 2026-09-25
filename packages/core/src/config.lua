-- Default config. Chalk turns this into <profile>/ReturnOfModding/config/AswehDebrej-Limitless_Poms_Core.cfg,
-- which players can edit in r2modman. Bump `version` when you change the defaults.
-- The second table holds the descriptions shown in the .cfg file.
return {
  version = 1;
  enabled = true;
  step_fraction = 0.25;
  hard_floor = 0.1;
}, {
  enabled = 'Master switch. When false, every boon keeps its vanilla Pom of Power limit.';
  step_fraction = 'Once a boon reaches its vanilla limit, each extra Pom lowers the value by at most this share of the previous value (0.25 = 25%). Allowed range: 0.01 - 0.9.';
  hard_floor = 'Values are never lowered below this number (seconds, for cooldowns).';
}
