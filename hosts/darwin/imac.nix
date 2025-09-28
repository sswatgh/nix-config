{ pkgs, config, ... }: 

{
  system =  {
    primaryUser = "ssw";
    activationScripts.alacrittyPosition = {
      text = ''
        osascript <<EOF
        tell application "Alacritty"
         set bounds of front window to {1280, 0, 2560, 1440}
        end tell
        EOF
      '';
      deps = [];
    };
    stateVersion = 4;
  };
 
  nix = {
    enable = false;
    settings.experimental-features = "nix-command flakes";
  };
 
  imports = [
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/networking.nix
  ];
}
