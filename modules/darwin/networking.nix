{ config, lib, pkgs, platform, ... }: 

lib.mkIf platform.isDarwin {
  networking.computerName = "imac";
  networking.hostName = "imac";
}
