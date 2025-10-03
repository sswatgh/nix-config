{ lib, platform, pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    
    extraConfig = ''
      AddKeysToAgent yes
      ${lib.optionalString platform.isDarwin "UseKeychain yes"}
    '';
    
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
      "*" = {
        controlMaster = "auto";
        controlPath = "~/.ssh/master-%r@%h:%p";
        controlPersist = "10m";
      };
    };
  };

  home.activation.setupSSH = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Setting up SSH directory..."
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    echo "SSH configuration applied - run 'ssh-add --apple-use-keychain ~/.ssh/id_ed25519' to store key in keychain"
  '';
  
  home.packages = with pkgs; [
    openssh
  ];
}
