{ config, pkgs, platform, ... }:
let
  importModules = dir:
    if builtins.pathExists dir then
      let
        entries = builtins.readDir dir;
        files = builtins.attrNames (builtins.filter (name: type: 
          type == "regular" && builtins.match ".*\\.nix" name != null
        ) entries);
        directories = builtins.attrNames (builtins.filter (name: type: 
          type == "directory"
        ) entries);
        fileImports = map (f: dir + "/${f}") files;
        dirImports = builtins.concatLists (map (d: 
          importModules (dir + "/${d}")
        ) directories);
      in
        fileImports ++ dirImports
    else [];
in
{
  imports = [
    ./base.nix
  ] ++ (importModules ./modules/gui);  
}
