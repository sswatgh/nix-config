{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
  ];

  programs.bitwarden = {
    enable = true;
    autostart = true;
    browserIntegration = true;
    vaultTimeout = 30;
    vaultTimeoutAction = "lock";
  };

  home.packages = with pkgs; [
#    bitwarden-cli  # package broken
  ];
}
