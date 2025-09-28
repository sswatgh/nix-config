{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "sswatgh";
    userEmail = "mail4ssw@tuta.io";
    
    extraConfig = {
      credential.helper = 
        if pkgs.stdenv.isDarwin 
        then "osxkeychain" 
        else "cache --timeout=3600";
    };
    
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
      hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      type = "cat-file -t";
      dump = "cat-file -p";
      nixup = "!git add . && git commit -m 'nix: update configuration' && git push";
    };
  };
}
