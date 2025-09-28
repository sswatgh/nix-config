{ pkgs, platform, ... }: 
{
  home.packages = with pkgs; [
    curl
    direnv
    glances
    htop
    nmap
    ripgrep
    tmux
    wget
  ];
}
