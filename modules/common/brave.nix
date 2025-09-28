{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.brave;
in
{
  options.programs.brave = {
    enable = mkEnableOption "Brave browser";
  };

  config = mkIf cfg.enable {
    home-manager.users.ssw = {
      home.packages = with pkgs; [ brave ];
      
      xdg.configFile."BraveSoftware/Brave-Browser/Preferences".text = builtins.toJSON {
        browser = {
          enabled_labs_experiments = [ 
            "enable-gpu-rasterization" 
            "enable-accelerated-2d-canvas" 
          ];
        };
      };
    };
  };
}
