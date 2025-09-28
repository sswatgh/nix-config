{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.nextcloud;
  nextcloudApp = "/Applications/Nextcloud.app";
in {
  options.programs.nextcloud = {
    enable = mkEnableOption "Nextcloud client autostart and configuration";

    autostart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start Nextcloud automatically on login.";
    };

    # Optional: Add configuration options if needed
    settings = mkOption {
      type = types.attrs;
      default = {};
      description = "Nextcloud configuration settings (optional)";
    };
  };

  config = mkIf cfg.enable {
    # Launchd service for autostart
    launchd.agents.nextcloud = mkIf cfg.autostart {
      enable = true;
      config = {
        ProgramArguments = [ 
          "${nextcloudApp}/Contents/MacOS/nextcloud" 
        ];
        RunAtLoad = true;
        KeepAlive = true;
        ProcessType = "Background";
        StandardOutPath = "/tmp/nextcloud.log";
        StandardErrorPath = "/tmp/nextcloud.log";
      };
    };

    # Optional: Configuration file if you want to pre-configure settings
    home.file.".config/Nextcloud/nextcloud.cfg" = mkIf (cfg.settings != {}) {
      text = generators.toINI {} cfg.settings;
    };

    # Helper script to check if Nextcloud is running
    home.file.".local/bin/nextcloud-status" = {
      text = ''
        #!/bin/sh
        if pgrep -x "nextcloud" > /dev/null; then
          echo "Nextcloud is running"
        else
          echo "Nextcloud is not running"
        fi
      '';
      executable = true;
    };
  };
}
