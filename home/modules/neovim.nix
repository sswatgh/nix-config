{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
  };

  home.activation = {
    nvchad = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
        echo "Cloning NvChad (starter)..."
        git clone https://github.com/NvChad/starter ${config.home.homeDirectory}/.config/nvim --depth 1
      else
        echo "NvChad already installed, skipping clone."
      fi
    '';
  };
}

