{
  config,
  pkgs,
  ...
}: {
  programs.nushell = {
    enable = true;
    envFile.source = config/nushell/env.nu;
    configFile.source = config/nushell/config.nu;
  };
}
