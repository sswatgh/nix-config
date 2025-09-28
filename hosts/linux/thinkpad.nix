{ config, pkgs, platform, ... }:

{
  networking = {
    hostName = "NBKB2K";
    computerName = "NBKB2K";
  };

  wsl = {
    enable = true;
    defaultUser = "ssw";
    startMenuLaunchers = true;
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
}
