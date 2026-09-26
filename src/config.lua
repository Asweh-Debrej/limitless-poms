-- Default config. Chalk turns this into <profile>/ReturnOfModding/config/AswehDebrej-Limitless_Poms.cfg,
-- which players can edit in r2modman (Config editor). Every setting applies live.
-- The second table holds the descriptions shown in the .cfg file.
return {
  enabled = true;
  max_extra_levels = 0;
  Hephaestus = {
    enabled = true;
    step_fraction = 0.25;
    minimum_seconds = 0.2;
  };
  Zeus = {
    enabled = true;
    step_fraction = 0.25;
    minimum_seconds = 0.2;
  };
  Hera = {
    enabled = true;
    step = 1;
    minimum = 1;
  };
}, {
  enabled = 'Master switch. When false, every boon keeps its vanilla Pom of Power limit.';
  max_extra_levels = 'How many Pom levels a boon can gain past its vanilla limit. 0 = no limit.';
  Hephaestus = {
    enabled = 'Volcanic Strike, Volcanic Flourish and Smithy Rush keep improving past their 2s blast cooldown limit.';
    step_fraction = 'Past the limit, each Pom lowers the blast cooldown by this share of its previous value (0.25 = 25%). Range 0.01 - 0.9.';
    minimum_seconds = 'The blast cooldown never goes below this many seconds. Range 0.1 - 2.';
  };
  Zeus = {
    enabled = 'Ionic Gain keeps improving past its 2s reappearance time limit.';
    step_fraction = 'Past the limit, each Pom lowers the reappearance time by this share of its previous value (0.25 = 25%). Range 0.01 - 0.9.';
    minimum_seconds = 'The reappearance time never goes below this many seconds. Range 0.1 - 2.';
  };
  Hera = {
    enabled = 'Born Gain keeps improving past its limit of 5 Magick Primed.';
    step = 'Past the limit, each Pom lowers Magick Primed by this whole number.';
    minimum = 'Magick Primed never goes below this whole number. Range 1 - 5.';
  };
}
