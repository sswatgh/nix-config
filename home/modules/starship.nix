{ pkgs, platform, ... }: 
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      format = "$all";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}
