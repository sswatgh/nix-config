{ config, pkgs, platform, ... }:

{
  home.sessionVariables = {
    DISPLAY = ":0";
  };

  programs = {
  };

  home.packages = with pkgs; [
    wslu
    xorg.xhost
  ];
}
