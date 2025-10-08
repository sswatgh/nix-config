{ config,lib, pkgs, ... }:

{
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
