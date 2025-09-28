{ config, lib, pkgs, platform, ... }:

lib.mkIf platform.isDarwin {
  homebrew = {
    enable = true;
    brewPrefix = if pkgs.stdenv.isAarch64 then "/opt/homebrew/bin" else "/usr/local/bin";
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
    };
    casks = [
      "alacritty"
      "brave-browser"
      "libreoffice"
      "nextcloud"
      "obsidian"
      "skim"
    ];
  };
}
