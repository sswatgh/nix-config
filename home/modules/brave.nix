{ config, lib, pkgs, ... }:

let
  cfg = config.applications.brave;
in {
  options.applications.brave = {
    enable = lib.mkEnableOption "Brave browser";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ brave ];
    
    xdg.configFile."BraveSoftware/Brave-Browser/Preferences" = lib.mkIf pkgs.stdenv.isLinux {
      text = builtins.toJSON {
        browser.enabled_labs_experiments = [ 
          "enable-gpu-rasterization" 
          "enable-accelerated-2d-canvas" 
        ];
      };
    };
  };
}
