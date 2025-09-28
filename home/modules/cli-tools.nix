{ pkgs, ... }: 

{
  home.packages = with pkgs; [
    # file and text manipulation
    fd        # find alternative
    ripgrep   # pattern searches
    
    # system monitoring
    glances	  # monitoring
    htop	    # process viewer
    tmux	    # terminal multiplexer
   
    # networking
    curl      # from & to server
    wget	    # from web
 
    # security
    nmap	    # network scanner

    # development
    direnv    # dev shell
  ];
}
