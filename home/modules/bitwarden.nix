{ config, lib, pkgs, platform, ... }:

{
  home.packages = [ pkgs.bitwarden ];

  launchd.agents.bitwarden = lib.mkIf platform.isDarwin {
    enable = true;
    config = {
      Label = "com.bitwarden.desktop";
      ProgramArguments = [ 
        "${pkgs.bitwarden}/Applications/Bitwarden.app/Contents/MacOS/Bitwarden" 
      ];
      RunAtLoad = true;
    };
  };

  xdg.configFile."autostart/bitwarden.desktop" = lib.mkIf platform.isLinux {
    source = "${pkgs.bitwarden}/share/applications/bitwarden.desktop";
  };
}
