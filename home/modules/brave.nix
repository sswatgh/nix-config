{ config, lib, pkgs, platform, ... }:

{
  home.packages = with pkgs; [ brave ];
  
  xdg.configFile."BraveSoftware/Brave-Browser/Preferences" = lib.mkIf platform.isLinux {
    text = builtins.toJSON {
      browser.enabled_labs_experiments = [ 
        "enable-gpu-rasterization" 
        "enable-accelerated-2d-canvas" 
      ];
    };
  };
}
