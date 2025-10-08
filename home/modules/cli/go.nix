{ config, lib, pkgs, platform, ... }:

{
  home.packages = with pkgs; [
    go
    gopls
    delve
    go-tools
    gomodifytags
    impl
    gotests
  ];

  home.sessionPath = [ "$HOME/go/bin" ];
  home.sessionVariables = {
    GOPATH = "$HOME/go";
    GO111MODULE = "on";
  };

  home.activation.initGoWorkspace = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "${config.home.homeDirectory}/go" ]; then
      echo "Initializing Go workspace directory..."
      mkdir -p "${config.home.homeDirectory}/go"/{bin,src,pkg}
    fi
  '';
}
