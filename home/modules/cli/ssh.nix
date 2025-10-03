{ lib, platform, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
      "*" = {
        controlMaster = "auto";
        controlPath = "~/.ssh/master-%r@%h:%p";
        controlPersist = "10m";
        addKeysToAgent = "yes";
        useKeychain = lib.mkIf platform.isDarwin "yes";
      };
    };
  };

  home.activation.setupSSH = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
  '';
}
