{ config, pkgs, platform, ... }:

{
  home.sessionVariables = {
    DISPLAY = ":0";
    BROWSER = "brave";
  };

  programs = {
    alacritty.enable = true;
  };

  home.packages = with pkgs; [
    bitwarden
    brave
   
    wslu
    
    xorg.xhost
  ];
}
