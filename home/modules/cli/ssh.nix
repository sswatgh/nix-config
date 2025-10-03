{ lib, platform, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;  
    
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
        controlMaster = "auto";
        controlPath = "~/.ssh/master-%r@%h:%p";
        controlPersist = "10m";
        useKeychain = lib.mkIf platform.isDarwin "yes";
      };
      
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  home.activation.setupSSH = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
  '';
}
