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
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, nixos-wsl, ... }: 
  let
    #####################
    # modules auto-import
    #####################
    importModules = dir:
      if builtins.pathExists dir then
        let
          files = builtins.attrNames (builtins.readDir dir);
          nixFiles = builtins.filter (f: builtins.match ".*\\.nix" f != null) files;
        in
          map (f: dir + "/${f}") nixFiles
      else [];
    
    ####################
    # platform detection
    ####################
    withPlatform = pkgs: {
      isDarwin = pkgs.stdenv.isDarwin;
      isLinux = pkgs.stdenv.isLinux;
      isWSL = pkgs.stdenv.isLinux && (builtins.getEnv "WSL_DISTRO_NAME" != "");
      platform = if pkgs.stdenv.isDarwin then "darwin" else "linux";
    };
    
  in {
    ###############
    # Darwin config
    ###############
    darwinConfigurations."imac" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      specialArgs = { 
        platform = withPlatform nixpkgs.legacyPackages.x86_64-darwin;
      };
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
            backupFileExtension = "bak";
            users.ssw = {
              imports = [
                ./home/base.nix
                ./home/macos.nix
              ] ++ (importModules ./home/modules/cli);
              _module.args.platform = withPlatform nixpkgs.legacyPackages.x86_64-darwin;
            };
          };
        }
      ] ++ (importModules ./modules/darwin);
    };
    
    ############
    # WSL config
    ############
    nixosConfigurations.NBKB2K = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        platform = withPlatform nixpkgs.legacyPackages.x86_64-linux;
      };
      modules = [
        nixos-wsl.nixosModules.wsl
        ./hosts/linux/thinkpad.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.ssw = {
              imports = [
                ./home/base.nix
                ./home/linux.nix
              ] ++ (importModules ./home/modules/cli ./home/modules/gui);
              _module.args.platform = withPlatform nixpkgs.legacyPackages.x86_64-linux;
            };
          };
        }
      ];
    };

    #############################
    # WSL home-manager standalone
    #############################
    homeConfigurations."ssw@NBKB2K" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { 
        platform = withPlatform nixpkgs.legacyPackages.x86_64-linux;
      };
      modules = [
        ./home/base.nix
        ./home/linux.nix
      ] ++ (importModules ./home/modules/cli);
    };
  };
}
