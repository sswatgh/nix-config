{ lib, platform, pkgs, ... }:

{
  services.ssh-agent.enable = platform.isLinux;
  
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    
    extraConfig = ''
      AddKeysToAgent yes
      ${lib.optionalString platform.isDarwin "UseKeychain yes"}
    '';
    
    matchBlocks = {
      "*" = {
        controlMaster = "auto";
        controlPath = "~/.ssh/master-%r@%h:%p";
        controlPersist = "10m";
      };
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  home.activation.setupSSH = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Setting up SSH keys..."
    
    # Ensure SSH commands are available
    export PATH="${pkgs.openssh}/bin:$PATH"
    
    # Start SSH agent if not running (check if SSH_AUTH_SOCK exists and is valid)
    if ! ssh-add -l > /dev/null 2>&1; then
      echo "Starting SSH agent..."
      eval "$(ssh-agent -s)" > /dev/null
    fi
    
    # Common key types and locations
    key_locations=(
      "$HOME/.ssh/id_ed25519"
      "$HOME/.ssh/id_rsa" 
      "$HOME/.ssh/id_ecdsa"
    )
    
    for key in "''${key_locations[@]}"; do
      if [ -f "$key" ]; then
        echo "Adding SSH key: $(basename "$key")"
        ssh-add "$key" 2>/dev/null || echo "  Key already added or could not be added"
      fi
    done
    
    # Ensure proper permissions
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    find "$HOME/.ssh" -type f -name "*" ! -name "*.pub" -exec chmod 600 {} + 2>/dev/null || true
    find "$HOME/.ssh" -type f -name "*.pub" -exec chmod 644 {} + 2>/dev/null || true
    
    echo "SSH setup complete"
  '';
  
  home.packages = with pkgs; [
    openssh
    ssh-copy-id
  ];
}
