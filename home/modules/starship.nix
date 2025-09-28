{ pkgs, ... }: 
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # Customize your starship prompt
      add_newline = true;
      format = "$all";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}
