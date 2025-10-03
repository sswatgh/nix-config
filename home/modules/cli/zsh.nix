{ pkgs, lib, platform, ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
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
      vi = "nvim";  
    };

    envExtra = ''
      export EDITOR="nvim"
      export VISUAL="nvim"
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/.nix-profile/bin:$PATH"
    '';

    initContent = ''
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
}
