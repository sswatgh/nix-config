{ config, lib, pkgs, platform, ... }:

{
  programs.git = {
    enable = true;
    userName = "sswatgh";
    userEmail = "mail4ssw@tuta.io";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      credential.helper = 
        if platform.isDarwin then "osxkeychain" 
        else "store";  
    };
    
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
      hist = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      nixup = "!git add . && git commit -m 'nix: update config' && git push";
    };
  };
}
