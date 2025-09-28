{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.skimpdf;
in
{
  options.programs.skimpdf = {
    enable = mkEnableOption "skim PDF reader";

    package = mkOption {
      type = types.package;
      default = pkgs.skimpdf;
      defaultText = literalExpression "pkgs.skim";
      description = "The skim package to use";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    # Optional: Add configuration for skim if needed
    # xdg.configFile."skim/skimrc".text = ''
    #   # Your skim configuration here
    # '';
  };
}
