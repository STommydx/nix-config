{ pkgs, ... }:

{

  programs.nixvim = {
    enable = true;
    colorschemes.tokyonight = {
      enable = true;
      settings.style = "night";
    };
    defaultEditor = true;
    extraConfigLua = ''
      require('neoscroll').setup()
      require("scrollbar").setup()
    '';
    extraPlugins = with pkgs.vimPlugins; [
      neoscroll-nvim
      nvim-scrollbar
      vim-illuminate
    ];
    keymaps = [
      {
        mode = "v";
        key = "<C-c>";
        action = ''"+y'';
      }
      {
        mode = "v";
        key = "<C-x>";
        action = ''"+d'';
      }
    ];
    opts = {
      number = true;
    };
    plugins = {
      bufferline = {
        enable = true;
        settings.options.separatorStyle = "slant";
      };
      comment.enable = true;
      coq-nvim.enable = true;
      gitsigns.enable = true;
      lualine.enable = true;
      lsp = {
        enable = true;
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          gopls.enable = true;
          nixd.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
        };
      };
      nix.enable = true;
      noice.enable = true;
      notify.enable = true;
      nvim-autopairs.enable = true;
      nvim-tree.enable = true;
      todo-comments.enable = true;
      treesitter.enable = true;
      trouble.enable = true;
      web-devicons.enable = true;
    };
    viAlias = true;
    vimAlias = true;
  };

}
