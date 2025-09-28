{ config, lib, pkgs, platform, ... }:

{
  home.packages = lib.mkIf platform.isLinux [ 
    pkgs.nextcloud-client 
  ];

  launchd.agents.nextcloud = lib.mkIf platform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [ 
        "/Applications/Nextcloud.app/Contents/MacOS/nextcloud" 
      ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  xdg.configFile."autostart/nextcloud.desktop" = lib.mkIf platform.isLinux {
    source = "${pkgs.nextcloud-client}/share/applications/nextcloud.desktop";
  };
}
