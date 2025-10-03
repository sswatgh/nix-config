{ lib, platform, pkgs, ... }:
{
  services.ssh-agent.enable = platform.isLinux;
  
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;  # Avoid deprecation warnings
    
    # Global SSH configuration
    extraConfig = ''
      # Common settings for all hosts
      AddKeysToAgent yes
      ServerAliveInterval 60
      ServerAliveCountMax 3
      TCPKeepAlive yes
      Compression yes
      
      # Platform-specific settings
      ${lib.optionalString platform.isDarwin "UseKeychain yes"}
    '';
    
    # ControlMaster for faster multiple connections
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

  # Auto-add keys on all platforms
  home.activation.setupSSH = lib.hm.dag.entryAfter ["writeBoundary"] ''
    echo "Setting up SSH keys..."
    
    # Ensure SSH commands are available
    export PATH="${pkgs.openssh}/bin:$PATH"
    
    # Common key types and locations
    key_locations=(
      "$HOME/.ssh/id_ed25519"
      "$HOME/.ssh/id_rsa" 
      "$HOME/.ssh/id_ecdsa"
    )
    
    for key in "''${key_locations[@]}"; do
      if [ -f "$key" ] && ! ssh-add -l | grep -q "$(ssh-keygen -lf "$key" 2>/dev/null | cut -d' ' -f2)"; then
        echo "Adding SSH key: $key"
        ssh-add "$key" 2>/dev/null || true
      fi
    done
    
    # Ensure proper permissions
    chmod 700 "$HOME/.ssh"
    chmod 600 "$HOME/.ssh/"* 2>/dev/null || true
    chmod 644 "$HOME/.ssh/"*.pub 2>/dev/null || true
  '';
  
  home.packages = with pkgs; [
    ssh-copy-id
    openssh
  ] ++ lib.optionals platform.isLinux [
    mosh  # For unstable connections (Linux only)
  ];
}
