{ config, lib, pkgs, platform, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
  };

  home.activation.nvchad = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
      echo "Cloning NvChad (starter)..."
      git clone https://github.com/NvChad/starter ${config.home.homeDirectory}/.config/nvim --depth 1
    fi
  '';

  xdg.configFile."nvim/lua/custom/plugins.lua".text = ''
    return {
      {
        "ray-x/go.nvim",
        dependencies = {
          "ray-x/guihua.lua",
          "neovim/nvim-lspconfig",
          "nvim-treesitter/nvim-treesitter",
        },
        config = function()
          require("go").setup()
        end,
        event = {"CmdlineEnter"},
        ft = {"go", 'gomod'},
        build = ':lua require("go.install").update_all_sync()'
      }
    }
  '';

  xdg.configFile."nvim/lua/custom/mappings.lua".text = ''
    local M = {}
    M.general = {
      n = {
        ["<leader>gg"] = {"<cmd>GoRun<cr>", "Run Go file"},
        ["<leader>gt"] = {"<cmd>GoTest<cr>", "Run Go test"},
        ["<leader>gd"] = {"<cmd>GoDebug<cr>", "Debug Go"},
      }
    }
    return M
  '';
}
