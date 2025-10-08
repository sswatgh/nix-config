{ pkgs, lib, platform, ... }:

{
  programs.zsh = {
    enable = true;
    
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.local/share/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      ll = "ls -l";
      la = "ls -A";
      lla = "ls -lA";
      ".." = "cd ..";
      "..." = "cd ../..";
      nc = "cd ~/nix-config";
      nup = "nix flake update";
      ndr = "sudo darwin-rebuild switch --flake .#imac";
      nupdr = "nix flake update && sudo darwin-rebuild switch --flake .#imac";
      ncupdr = "cd ~/nix-config && nix flake update && sudo darwin-rebuild switch --flake .#imac";
      ncupdrthinkpad = "cd ~/nix-config && nix flake update && nix run home-manager/master -- switch --flake .#ssw@NBKB2K";
      ngo = "cd ~/Nextcloud2/main vault/sources/Imperative Programmierung/go";      
      vi = "nvim";  
    };

    envExtra = ''
      export EDITOR="nvim"
      export VISUAL="nvim"
      export PATH="$HOME/.local/bin:$PATH"
    '';

    initContent = ''
      # SSH agent setup
      if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)" > /dev/null
        ssh-add ~/.ssh/id_ed25519 2>/dev/null
      fi     
      
      if ! ssh-add -l > /dev/null 2>&1; then
        eval "$(ssh-agent -s)" > /dev/null
        if ! ssh-add -l | grep -q id_ed25519; then
          ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null || true
        fi
      fi

      export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump-$HOST"
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      
      if command -v starship &>/dev/null; then
        eval "$(starship init zsh)"
      fi
    '';
  };

  home.packages = with pkgs; [
    zsh
    zsh-completions
    zsh-history-substring-search
    nix-zsh-completions
  ];

  home.sessionPath = [ 
    "$HOME/.local/bin"
  ];
  
  programs.bash.enable = true;
}
