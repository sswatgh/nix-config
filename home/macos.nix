{ config, pkgs, platform, ... }:

{
  imports = [
    ./base.nix
  ];

  home.packages = with pkgs; [
#    bitwarden-cli 
  ];
}
