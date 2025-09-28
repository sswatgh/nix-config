{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }: let
    importModules = dir:
      if builtins.pathExists dir then
        let
          files = builtins.attrNames (builtins.readDir dir);
          nixFiles = builtins.filter 
            (f: builtins.match ".*\\.nix" f != null) files;
        in
          map (f: dir + "/${f}") nixFiles
      else [];
  in {
    darwinConfigurations."imac" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./hosts/darwin/imac.nix
        home-manager.darwinModules.home-manager
        {
          users.users.ssw = {
            name = "ssw";
            home = "/Users/ssw";
          };
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.ssw = {
              imports = [
                ./home/base.nix
                ./home/macos.nix
              ] ++ (importModules ./home/modules);
            };
          };
        }
      ];
    };
  };
}
