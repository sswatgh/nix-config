{ config, lib, pkgs, platform, ... }:

{
  programs.git = {
    enable = true;
    userName = "sswatgh";
    userEmail = "mail4ssw@tuta.io";
    
    extraConfig = {
      credential.helper = 
        if platform.isDarwin 
        then "osxkeychain" 
        else "cache --timeout=3600";
    };
    
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
      hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      nixup = "!git add . && git commit -m 'nix: update configuration' && git push";
    };
  };
}
