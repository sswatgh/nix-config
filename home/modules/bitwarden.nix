{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.bitwarden;
in
{
  options.programs.bitwarden = {
    enable = mkEnableOption "Bitwarden password manager";

    package = mkOption {
      type = types.package;
      default = pkgs.bitwarden;
      defaultText = "pkgs.bitwarden";
      description = "Bitwarden package to use";
    };

    autostart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start Bitwarden automatically on login";
    };

    browserIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Enable browser integration";
    };

    vaultTimeout = mkOption {
      type = types.int;
      default = 15;
      description = "Vault timeout in minutes (0 for never)";
    };

    vaultTimeoutAction = mkOption {
      type = types.enum [ "lock" "logout" ];
      default = "lock";
      description = "Action to take when vault times out";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    launchd.agents.bitwarden = mkIf (cfg.autostart && pkgs.stdenv.isDarwin) {
      enable = true;
      config = {
        Label = "com.bitwarden.desktop";
        ProgramArguments = [ 
          "${cfg.package}/Applications/Bitwarden.app/Contents/MacOS/Bitwarden" 
        ];
        RunAtLoad = true;
        KeepAlive = false;
        ProcessType = "Interactive";
      };
    };

    xdg.configFile."autostart/bitwarden.desktop" = mkIf (cfg.autostart && pkgs.stdenv.isLinux) {
      source = "${cfg.package}/share/applications/bitwarden.desktop";
    };

    # Bitwarden CLI configuration  # package corrupted
#    home.file.".config/Bitwarden CLI/data.json" = mkIf (cfg.vaultTimeout != null) {
#      text = builtins.toJSON {
#        vaultTimeout = cfg.vaultTimeout;
#        vaultTimeoutAction = cfg.vaultTimeoutAction;
#      };
#    };
  };
}
