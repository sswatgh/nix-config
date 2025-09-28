{ pkgs, platform, ... }: 
{
  home.username = "ssw";
  home.homeDirectory = if platform.isDarwin then "/Users/ssw" else "/home/ssw";
  home.stateVersion = "23.11";
}
