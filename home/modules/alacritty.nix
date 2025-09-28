{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.9;
        decorations = "none";
        dimensions = {
          columns = 120;
          lines = 68;
        };   
        position = { 
          x = 5; 
        };
      };

      colors = {
        primary = {
          background = "0x282828";
          foreground = "0xebdbb2";
        };
        cursor = {
          text = "0x282828";
          cursor = "0xebdbb2";
        };
        normal = {
          black =   "0x282828";
          red =     "0xcc241d";
          green =   "0x98971a";
          yellow =  "0xd79921";
          blue =    "0x458588";
          magenta = "0xb16286";
          cyan =    "0x689d6a";
          white =   "0xa89984";
        };
      };

      font = {
        size = 18;
        normal.family = "Menlo";
      };

      terminal.shell.program = "${pkgs.zsh}/bin/zsh";
    };
  };
}
