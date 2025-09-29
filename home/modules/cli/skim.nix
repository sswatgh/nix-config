{ config, lib, pkgs, platform, ... }:

lib.mkIf platform.isDarwin {
  home.packages = [ pkgs.skim ];
}
